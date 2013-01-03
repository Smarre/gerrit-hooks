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

    # this requires actual verification that build succeeded
    pending
end
