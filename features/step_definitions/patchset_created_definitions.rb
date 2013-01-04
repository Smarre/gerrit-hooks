# encoding: utf-8

require "patchset_created"

Given /^PatchsetCreated created$/ do
  @set = GerritHooks::PatchsetCreated.new
end

# table is a Cucumber::Ast::Table
Given /^patchset’s input arguments are:$/ do |table|

    hash = table.rows_hash
    args = Array.new
    hash.each do |key, value|
        @project = value if key == "project"
        args << "--#{key}" << "#{value}"
    end

    @set.parse_args(args).should == true
end

When /^build request is submitted$/ do
    @result = @set.submit
end

Then /^validate that build succeeds$/ do
    project_name = @project.gsub "\/" do
        "-"
    end
    #regexp = Regexp.new "http:\/\/integrity.service.slm.fi\/alarmsystem\/builds\/\d{1,}"
    @result.should match /http:\/\/integrity.service.slm.fi\/#{project_name}\/builds\/\d{1,}/

    element = nil

    while true

        base = GerritHooks::Base.new
        page = base.request_page @result

        element = page.parser.at_xpath "//div[@class='building']"
        break if element.to_s == ""
        sleep 1
    end

    element = page.parser.at_xpath "//div[@class='success']"

    element.to_s.should_not == ""
end
