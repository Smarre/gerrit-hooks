#!/usr/bin/env ruby

require_relative "lib/manual_request"
require_relative "lib/cli"

request = GerritHooks::ManualRequest.new
request.parse_args
uri = request.submit

cli = GerritHooks::Cli.new

success = cli.check_for_success uri

request.change_changeset_status success

raise "Change set build failed" if success == false
exit 0
