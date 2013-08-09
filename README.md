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

Set the following environment variables:

  * `RACKSPACE_API_KEY`: your API key
  * `RACKSPACE_USERNAME`: your Rackspace username
  * `RACKSPACE_CLOUDFILES_CONTAINER`: the default container you want to access
  * `RACKSPACE_AUTH_URL`: (optional) defaults to https://auth.api.rackspacecloud.com/v1.0

For example, I add these in a `.rackspace` file, and I either source that from
my `.profile`, or manually source it whenever I need it.

Then, source the `swift_wrapper.sh` file (again from your `.profile` or
whenever you need this), and run `swifthelp` for a list of available commands.


## Disclaimer/Contributing

I'm certainly no bash expert, so feel free to open an Issue if you spot a bug
or if you've got suggestions on ways to make this better!
