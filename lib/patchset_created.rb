
require "trollop"

require_relative "base"

module GerritHooks

    class PatchsetCreated < Base

        def initialize
            parse_args

            super
        end

        def parse_args args = ARGV
            return false if args.empty?

            p = Trollop::Parser.new do
                opt :change, "Change id", type: :string, required: true
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
                p.parse args
            end

            if opts[:is_draft] == "true" then @is_draft = true else @is_draft = false end

            @change_id = opts[:change]
            @change_url = opts[:change_url]
            @project_name = opts[:project]
            @branch_name = opts[:branch]
            @topic_name = opts[:topic]
            @uploader_name = opts[:uploader]
            @commit_id = opts[:commit]
            @patchset_id = opts[:patchset]

            @identifier = @change_url.split("/")[-1]
            @short_identifier = @identifier[-2, 2]

            true
        end

        def submit
            checkout_command = "git fetch #{@git_url}/#{@project_name} refs/changes/#{@short_identifier}/#{@identifier}/#{@patchset_id} && git checkout FETCH_HEAD"
            request_build @project_name, checkout_command
        end
    end

end