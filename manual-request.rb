#!/usr/bin/env ruby

require_relative "lib/manual_request"
require_relative "lib/cli"

request = GerritHooks::ManualRequest.new
request.parse_args
request.submit

cli = GerritHooks::Cli.new

success = cli.check_for_success

request.change_changeset_status success

exit 1 if success == false
exit 0
