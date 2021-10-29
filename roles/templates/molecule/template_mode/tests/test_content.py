# Without at least a file here, tests in the additional directory will not
# get picked up. If you add actual tests to this directory, then you can
# safely eliminate this file. Otherwise, it exists only to cause the tests in
# shared/tests to be discovered.
#
# Most tests should be written in the shared/tests directory so that they can
# be captured by all the scenarios. Only add tests here if there are tests
# only relevant to a particular scenario


def test_file_a(host):
    """Test that the file is properly uploaded AND templated"""
    f = host.file("/out/file.yml")
    assert f.content == b'key: "my string"'


def test_file_raw(host):
    """Test that the file is properly uploaded, templated, and still includes
    raw content."""
    f = host.file("/out/raw.in")
    assert f.content == b'key: {{ value }}'
