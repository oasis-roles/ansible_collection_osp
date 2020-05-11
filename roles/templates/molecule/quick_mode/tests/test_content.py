# Without at least a file here, tests in the additional directory will not
# get picked up. If you add actual tests to this directory, then you can
# safely eliminate this file. Otherwise, it exists only to cause the tests in
# shared/tests to be discovered.
#
# Most tests should be written in the shared/tests directory so that they can
# be captured by all the scenarios. Only add tests here if there are tests
# only relevant to a particular scenario


def test_file_a(host):
    """In quick mode, only files that are reported as changed in a git status
    are uploaded. During this test, we do not modify the a.in file, so there
    should be no a.in file on the target host."""
    a_in = host.file("/out/a.in")
    assert not a_in.exists


def test_file_raw(host):
    """The b.in file is modified prior to running the test in quick mode. This
    should cause git to report the b.in file is changed. Thus, it should be
    templated and uploaded into place on the target system."""
    content = host.file("/out/b.in").content_string
    assert content == 'file_b: my value'


def test_folder_exist(host):
    """Since we are uploading a git repository, the .git folder should also be
    sent as part of the upload. While it might not be best practice to actually
    upload an entire .git structure to the remote system (particular if the
    goal is to expose a folder to the web), there are times when it is
    appropriate to do so. This is just testing for completeness that our
    quick_mode is operating the way we expect it to. While none of the .git
    files should be populated, as they are not going to be listed as "changed"
    in the output of git, the folder structure itself will still be duplicated
    on the taret system because of how this role operates."""
    git_folder = host.file("/out/.git")
    assert git_folder.exists
    assert git_folder.is_directory
