#!/usr/bin/env ruby

require_relative "lib/patchset_created"

created = GerritHooks::PatchsetCreated.new
created.parse_args
created.submit

element = nil

while true

    base = GerritHooks::Base.new
    page = base.request_page @result

    element = page.parser.at_xpath "//div[@class='building']"
    break if element.to_s == ""
    sleep 1
end

element = page.parser.at_xpath "//div[@class='success']"

# failure
if element.to_s == "" then success = true else success = false end

created.change_changeset_status success

exit 1 if success == false
exit 0
