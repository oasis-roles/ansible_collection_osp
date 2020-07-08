"""
Exposes the filter "env_to_dict([only=REGEX_LIST])

This is a plugin that can take the stdout result of running the Bash built-in
`env` command and return a dictionary. This can be used for passing into the
`environment` key in later tasks. This can avoid needing to use the `shell`
module to read an RC file prior to running a command.

Ansible best practices is that you avoid using the "shell" command whenever
possible. This is to avoid problems with pipes, exit codes, etc. It also limits
the possibility of problems related to isolating change conditions when a shell
script is run from within an Ansible command.

`REGEX_LIST` is a list of strings, each of which is a regular expression. If
provided, then only environment variable names which match ANY member of the
list will be returned. This can allow you to avoid passing around unnecessary
or incorrect data. So, if you only want OS_ and NOVA_ prefixed values then
invoke this command like `{{ _my_output | env_to_dict(['OS_.*', 'NOVA_.*']) }}`

For instance, this can replace something like

```yaml
- name: do a thing
  shell: |
    set -e
    source ~/stackrc
    openstack image save --file ~/foo.img foo creates=~/foo.img

- name: do another thing
  shell: |
    set -e
    source ~/stackrc
    openstack image save --file ~/bar.img bar creates=~/bar.img

- name keep doing other things...
```

with the following

```yaml
- name: create openstack image
  shell: |
    set -e
    source ~/stackrc
    env
  register: _stackrc_output
  changed_when: false

- name: extract environment
  set_fact:
    _stackrc: "{{ _stackrc_output.stdout_lines | env_to_dict }}"

- name: do a thing
  command: openstack image save --file ~/foo.img foo creates=~/foo.img
  environment: "{{ _stackrc }}"

- name: do another thing
  command: openstack image save --file ~/bar.img bar creates=~/bar.img
  environment: "{{ _stackrc }}"

- name: keep doing other things...
```
"""
import re
from ansible.module_utils.six import string_types


# We're not exactly rigorous here, but, there are a number
# of things we can say for sure don't include lines that we're interested
# in parsing.
def _is_var(line):
    """Determines if the given line in the output of 'env' is likely to be
    a variable line. The following types of lines are not likely to contain
    a variable definition:

    * A line that is just '}' is the end of a bash function defintion
    * A line that has length of 0 is not going to contain anything of interest
    * A line that begins with whitespace is likely the body of a function
    * A line that doesn't include the '=' character can't be parsed by us
    * Function names start with BASH_FUNC_some_func_name, and are not for us
      to parse"""
    if line.strip() == '}':
        return False
    if len(line) == 0:
        return False
    if line[0] == ' ' or line[0] == "\t":
        return False
    if "=" not in line:
        return False
    if line.startswith("BASH_FUNC"):
        return False
    return True


def split_lines(lines):
    """Takes the stdout from the command 'env' and converts it into a list of
    tuples (VAR_NAME, value) if they are parseable. Does basic filtering on
    lines that are likely to be easily parseable as variables.

    :param lines A multi-line string or array of single-line strings
    :return List of tuples (VAR_NAME, value) found in the lines"""
    if isinstance(lines, string_types):
        line_list = lines.split("\n")
    else:
        line_list = lines
    return [l.split("=", 1) for l in line_list if _is_var(l)]


def is_wanted(item, only):
    """Tests a single (VAR_NAME, tuple) pair to determine if it matches a
    regex passed in. The VAR_NAME is compared against all the regexes in 'only'
    and is considered "wanted" if it matches any of them as a prefix.

    :param item A tuple in the form (VAR_NAME, value)
    :param only An array of regex strings to search for as prefixes of the name
    :return True if VAR_NAME matches any regex, False otherwise"""
    name = item[0]
    for regex in only:
        if re.match(regex, name):
            return True
    return False


def env_to_dict(env, only=[r'.*']):
    """Entrypoint for the filter. Converts the output of the Bash 'env' command
    into a dictionary of VAR_NAME:value keys, optionally filtering based on
    variable name prefix regexes.

    :param env A multi-line string, or array of strings, that is the raw output
    captured from the 'env' command
    :param only A list of regex strings to match. Only variables whose names
    match an entry in the list will be returned
    :return A dict of parsed Bash variables whose names match an entry in the
    only list"""
    if isinstance(only, string_types):
        only = [only]
    splits = split_lines(env)
    parsed_env = {i[0]: i[1] for i in splits if is_wanted(i, only)}
    return parsed_env


class FilterModule(object):
    def filters(self):
        filters = {
            'env_to_dict': env_to_dict
        }

        return filters
