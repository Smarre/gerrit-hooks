
require "trollop"

require_relative "base"

module GerritHooks

    class PatchsetCreated < Base

        def initialize
            super
        end

        def parse_args args = ARGV

            p = Trollop::Parser.new do
                opt :change, "Change id, like Id0eec3a5198489bf35ef016dba39961f8675a77c", type: :string, required: true
                opt :is_draft, "Whether the change is a draft", type: :string, default: "false", required: false
                opt :change_url, "URL to the change", type: :string, required: true
                opt :project, "Project of the change", type: :string, required: true
                opt :branch, "Branch of the project for the change", type: :string, required: true
                opt :topic, "Optional topic for the change", type: :string, required: false
                opt :uploader, "Uploader of the change", type: :string, required: true
                opt :commit, "Commit id of the change", type: :string, required: true
                opt :patchset, "Patch set id of the change", type: :string, required: true
            end

            opts = Trollop::with_standard_exception_handling p do
                raise Trollop::HelpNeeded if args.empty?
                p.parse args
            end

            if opts[:is_draft] == "true" then @is_draft = true else @is_draft = false end

            @git_change_id = opts[:change]
            @change_url = opts[:change_url]
            @project_name = opts[:project]
            @branch_name = opts[:branch]
            @topic_name = opts[:topic]
            @uploader_name = opts[:uploader]
            @commit_id = opts[:commit]
            @patchset_id = opts[:patchset]

            @identifier = @change_url.split("/")[-1]
            @change_id = @identifier
            @short_identifier = @identifier[-2, 2]

            true
        end
    end

end