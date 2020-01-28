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
