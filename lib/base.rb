
require "psych"
require "notify-integrity"

module GerritHooks

    ROOT_PATH = File.join(File.dirname(__FILE__), "..")

    class Base
        def initialize
            parse_config

            @notifier = NotifyIntegrity.new
            @notifier.auth @integrity_user, @integrity_pass
        end

        def request_build project_name, checkout_command
            headers = {
                "additional_command" => checkout_command
            }
            result = @notifier.post_request @integrity_uri, "/#{project_name}/builds", headers

            if result.instance_of? Net::HTTPFound
                headers = result.to_hash
                location = headers["location"][0]
                return location
            end

            result
        end

        def submit
            raise "@project_name missing" if @project_name.nil?
            raise "@git_url missing" if @git_url.nil?
            raise "@short_identifier missing" if @short_identifier.nil?
            raise "@identifier missing" if @identifier.nil?
            raise "@patchset_id missing" if @patchset_id.nil?

            project_name = @project_name.gsub "\/" do
                "-"
            end
            project_name.gsub! "_" do
                "-"
            end

            request_build project_name, checkout_command
        end

        def change_changeset_status success
            raise "@project_name missing" if @project_name.nil?
            raise "@ssh_url missing" if @ssh_url.nil?
            raise "@change_id missing" if @change_id.nil?
            raise "@patchset_id missing" if @patchset_id.nil?

            if success == true then verified = "1" else verified = "-1" end
            puts `ssh #{@ssh_url} gerrit review --verified #{verified} --project #{@project_name} #{@change_id},#{@patchset_id}`
        end

        def request_page uri
            @notifier.request_page uri
        end

        def check_for_success uri
            @notifier.check_for_success uri
        end

        private

        def parse_config
            config = Psych.load_file "#{ROOT_PATH}/config/config.yml"
            i = config["integrity"]
            @integrity_uri = i["uri"]
            @integrity_user = i["user"]
            @integrity_pass = i["password"]
            @additional_commands = i["additional_commands"]

            g = config["gerrit"]
            @git_url = g["git_url"]
            @ssh_url = g["ssh_params"]
        end

        def checkout_command
            @additional_commands.each do |arr|
                command = arr["command"]
                includes = arr["include_projects"]
                excludes = arr["exclude_projects"]

                next if includes[0].nil?

                if includes[0] == "all"
                    next if excludes.include? @project_name
                    return eval "\"#{command}\""
                end

                return eval "\"#{command}\"" if includes.include? @project_name
            end

            nil
        end
    end

end