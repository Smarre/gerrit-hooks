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
        args << "--#{key}" << "#{value}"
    end

    @set.parse_args(args).should == true
end

When /^build request is submitted$/ do
    @result = @set.submit
end

Then /^validate that build succeeds$/ do
    #regexp = Regexp.new "http:\/\/integrity.service.slm.fi\/alarmsystem\/builds\/\d{1,}"
    @result.should match /http:\/\/integrity.service.slm.fi\/alarmsystem\/builds\/\d{1,}/
end
