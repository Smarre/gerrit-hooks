#!/usr/bin/env ruby

require_relative "lib/manual_request"

request = GerritHooks::ManualRequest.new
request.parse_args
uri = request.submit

success = request.check_for_success uri

request.change_changeset_status success

raise "Change set build failed" if success == false
exit 0
