#!/bin/bash

# About
# -----
#
# This script contains some bash wrappers for swift, the command-line
# interface to Rackspace's OpenStack Storage API.
#
# To get started, you'll need to install the python-swiftclient
#
#     pip install python-swiftclient
#
# It's also available on github:
# https://github.com/openstack/python-swiftclient
#
# Usage
# -----
#
# Set the following environment variables (note: I just these in ~/.rackspace
# and source that file whenever I need it).
#
#   RACKSPACE_API_KEY  -- your API key
#   RACKSPACE_USERNAME -- your Rackspace username
#   RACKSPACE_CLOUDFILES_CONTAINER  -- the default container you want to access
#   RACKSPACE_AUTH_URL -- (optional) defaults to
#       https://auth.api.rackspacecloud.com/v1.0
#
# Source this file (swift_wrapper.sh), and run `swifthelp` for a list of
# available commands.
#
# License
# -------
#
# The MIT License (MIT)
#
# Copyright (c) 2013 Brad Montgomery
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


if [ -z "$RACKSPACE_AUTH_URL" ]
then
    export RACKSPACE_AUTH_URL=https://auth.api.rackspacecloud.com/v1.0
fi
if [ -z "$RACKSPACE_USERNAME" ]
then
    echo "* You Need to set a RACKSPACE_USERNAME environment variable"
fi
if [ -z "$RACKSPACE_API_KEY" ]
then
    echo "* You Need to set a RACKSPACE_API_KEY environment variable"
fi
if [ -z "$RACKSPACE_CLOUDFILES_CONTAINER" ]
then
    echo "* You Need to set a RACKSPACE_CLOUDFILES_CONTAINER environment variable"
fi

# Prefix for all swift commands
SWIFT="swift -A $RACKSPACE_AUTH_URL -U $RACKSPACE_USERNAME -K $RACKSPACE_API_KEY"

# just print out the swift command in case we need to tack on more options.
function swiftcommand
{
    echo
    echo "$SWIFT"
    echo
}


# Change your container
function swiftcontainer
{
    if [ -z "$1" ]
    then
        echo
        echo "Your current container is: $RACKSPACE_CLOUDFILES_CONTAINER"
        echo
        echo "USAGE: swiftcontainer <container-name>"
        echo
    else
        export RACKSPACE_CLOUDFILES_CONTAINER=$1
        echo "Changed container to: $RACKSPACE_CLOUDFILES_CONTAINER"
    fi

}

# Delete a container
function swiftdeletecontainer
{
    if [ -z "$1" ]
    then
        echo "Usage: swiftdeletecontainer <container_name>"
    else
        $SWIFT delete $1
    fi
}

function swiftlistcontainers
{
    $SWIFT list
}

function swiftlist
{
    if [ -z "$1" ]
    then
        # List all items in the container
        $SWIFT list $RACKSPACE_CLOUDFILES_CONTAINER
    else
        # Filter by a prefix
        $SWIFT list --prefix $1 $RACKSPACE_CLOUDFILES_CONTAINER
    fi
}

function swiftupload
{
    if [ -z "$@" ]
    then
        echo "Usage: swiftupload <file_or_directory> [...]"
    else
        $SWIFT upload --changed $RACKSPACE_CLOUDFILES_CONTAINER $@
    fi
}

# Delete an object(s) from a container
function swiftdelete
{
    if [ -z "$@" ]
    then
        echo "Usage: swiftdelete <object> [...]"
    else
        $SWIFT delete $RACKSPACE_CLOUDFILES_CONTAINER $@
    fi
}

function swiftdownload
{
    if [ -z "$@" ]
    then
        echo "Usage: swiftdownload <object> [...]"
        echo "       swiftdownload \*  -- to get all files in the container."
    elif [ "$@" == '*' ]; then
        $SWIFT download $RACKSPACE_CLOUDFILES_CONTAINER
    else
        $SWIFT download $RACKSPACE_CLOUDFILES_CONTAINER $@
    fi
}

function swiftstat
{
    if [ -z "$1" ]
    then
        $SWIFT stat
    else
        $SWIFT stat $RACKSPACE_CLOUDFILES_CONTAINER $1
    fi
}

function swifthelp
{
    verbose=false
    while getopts ":v" opt; do
    case $opt in
        v)
            verbose=true
            ;;
    esac
    done
    echo
    echo "* swiftcontainer - view or set your current container"
    echo "* swiftdeletecontainer - Delete a container and all of its contents"
    echo "* swiftlistcontainers - lists the containers in CloudFiles"
    echo "* swiftlist - lists the items in your default container"
    if $verbose ; then
        echo "
    Usage:

        swiftlist -- lists all items
        swiftlist <prefix> -- filters by the given prefix
    "
    fi

    echo "* swiftupload - uploads one or more files or directories if their"
    echo "  contents have changed"
    if $verbose ; then
        echo "
    Usage:

        swiftupdload <file_or_directory> [...]
    "
    fi

    echo "* swiftdelete - Deletes one or more items."
    if $verbose ; then
        echo "
    Usage:

        swiftdelete <object> [...]
    "
    fi

    echo "* swiftdownload - Downloads one or more files or directories (saving"
    echo "  to the current directory)"
    if $verbose ; then
        echo "
    Usage:

        swiftdownload <object> [...] -- Download one or more specific object
        swiftdownload \*  -- download every object in the current container

    "
    fi

    echo "* swiftstat - Print the status for the default container or for a"
    echo "  single object"
    if $verbose ; then
        echo "
    Usage:

        swiftstat  -- stat for the container
        swiftstat <object> -- stat for the given object
    "
    fi

    echo "* swifthelp - Prints this content!"
    echo
}
