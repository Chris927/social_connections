#!/bin/bash -e

VERSION=`gem build social_connections.gemspec | awk '/Version:/ {print $2}'`
gem push social_connections-$VERSION.gem
echo "Done!"
