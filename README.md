# swift_wrapper.sh

Some bash functions that make using swift (python cli for OpenStack /
Rackspace CloudFiles) less verbose.

## About

This script contains some bash wrappers for swift, the command-line
interface to Rackspace's OpenStack Storage API.

To get started, you'll need to install the python-swiftclient

    pip install python-swiftclient

It's also available on github:
https://github.com/openstack/python-swiftclient

## Usage

Set the following environment variables (note: I just these in ~/.rackspace
and source that file whenever I need it).

  * `RACKSPACE_API_KEY`: your API key
  * `RACKSPACE_USERNAME`: your Rackspace username
  * `RACKSPACE_CLOUDFILES_CONTAINER`: the default container you want to access
  * `RACKSPACE_AUTH_URL`: (optional) defaults to https://auth.api.rackspacecloud.com/v1.0

Source the `swift_wrapper.sh` file, and run `swifthelp` for a list of
available commands.
