#!/usr/bin/env ruby

require_relative "lib/patchset_created"
require_relative "lib/cli"

created = GerritHooks::PatchsetCreated.new
created.parse_args
uri = created.submit

cli = GerritHooks::Cli.new

success = cli.check_for_success uri

created.change_changeset_status success

exit 1 if success == false
exit 0
