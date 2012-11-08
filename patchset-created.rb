#!/usr/bin/env ruby

require_relative "lib/patchset_created"

created = GerritHooks::PatchsetCreated.new
created.parse_args
created.submit
