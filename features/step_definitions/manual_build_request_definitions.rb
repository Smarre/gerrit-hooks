
require "manual_request"

Given /^manual build request is issued with data:$/ do |table|

    @set = GerritHooks::ManualRequest.new

    hash = table.rows_hash
    args = Array.new
    hash.each do |key, value|
        @project = value if key == "project"
        args << "--#{key}" << "#{value}"
    end

    @set.parse_args(args).should == true

    @result = @set.submit
end
