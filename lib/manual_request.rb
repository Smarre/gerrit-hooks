
require "trollop"

require_relative "base"

module GerritHooks

    class ManualRequest < Base

        def initialize
            super
        end

        def parse_args args = ARGV

            p = Trollop::Parser.new do
                opt :change_id, "Change id", type: :string, required: true
                opt :project, "Project of the change", type: :string, required: true
                opt :patchset_id, "Patch set id of the change", type: :string, required: true
            end

            opts = Trollop::with_standard_exception_handling p do
                raise Trollop::HelpNeeded if args.empty?
                p.parse args
            end

            if opts[:is_draft] == "true" then @is_draft = true else @is_draft = false end

            @change_id = opts[:change_id]
            @project_name = opts[:project]
            @patchset_id = opts[:patchset_id]

            @identifier = @change_id
            @short_identifier = @identifier[-2, 2]

            true
        end
    end

end