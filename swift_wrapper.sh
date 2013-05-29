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
# Copyright (c) 2013 Brad Montgomery.
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


if [ -n "$RACKSPACE_AUTH_URL" ]
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

        swiftdownload <object> [...]
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