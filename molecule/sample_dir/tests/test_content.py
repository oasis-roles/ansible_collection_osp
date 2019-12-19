# Without at least a file here, tests in the additional directory will not
# get picked up. If you add actual tests to this directory, then you can
# safely eliminate this file. Otherwise, it exists only to cause the tests in
# shared/tests to be discovered.
#
# Most tests should be written in the shared/tests directory so that they can
# be captured by all the scenarios. Only add tests here if there are tests
# only relevant to a particular scenario


def test_file_a(host):
    a_in = host.file("/out/a.in")
    assert not a_in.exists


def test_file_raw(host):
    content = host.file("/out/b.in").content_string
    assert content == 'file_b: my value'


def test_folder_exist(host):
    git_folder = host.file("/out/.git")
    assert git_folder.exists
    assert git_folder.is_directory
