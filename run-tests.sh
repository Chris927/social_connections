#!/bin/bash -ex

# Idea is to run all automated tests from a single script

rake test
rspec spec -f d
