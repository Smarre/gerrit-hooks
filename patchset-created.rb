#!/usr/bin/env ruby

require_relative "lib/patchset_created"
require_relative "lib/cli"

created = GerritHooks::PatchsetCreated.new
created.parse_args
created.submit

success = cli.check_for_success

if element.to_s == "" then success = true else success = false end

created.change_changeset_status success

exit 1 if success == false
exit 0
