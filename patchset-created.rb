#!/usr/bin/env ruby

require_relative "lib/patchset_created"

created = GerritHooks::PatchsetCreated.new
created.parse_args
uri = created.submit

success = created.check_for_success uri

created.change_changeset_status success

exit 1 if success == false
exit 0
