
require "psych"
require "net/http"
require "uri/http"
require "mechanize"

module GerritHooks

    ROOT_PATH = File.join(File.dirname(__FILE__), "..")

    class Base
        def initialize
            parse_config
        end

        def request_build project_name, checkout_command
            headers = {
                "additional_command" => checkout_command
            }
            result = post_request @integrity_uri, "/#{project_name}/builds", headers

            if result.instance_of? Net::HTTPFound
                headers = result.to_hash
                location = headers["location"][0]
                return location
            end

            result
        end

        # uses Net::HTTP
        def post_request host, path, payload = {}
            uri = URI("#{host}#{path}")
            req = Net::HTTP::Post.new uri.path
            req.basic_auth @integrity_user, @integrity_pass
            req.set_form_data payload

            result = nil
            Net::HTTP.start(uri.hostname, uri.port) do |http|
                result = http.request(req)
            end

            if result.instance_of? Net::HTTPNotFound
                puts "Requested page does not exist (404)"
                puts "host: #{host}"
                puts "path: #{path}"
                result = nil
            end

            result
        end

        # uses Mechanize
        def request_page uri
            raise "invalid uri" if uri.nil?
            raise "integrity user or pass missing" if @integrity_user.nil? or @integrity_pass.nil?

            agent = Mechanize.new
            agent.add_auth uri, @integrity_user, @integrity_pass
            agent.get uri
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

            checkout_command = eval "\"#{@additional_command}\"" if permission_for_additional_command
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

        private

        def parse_config
            config = Psych.load_file "#{ROOT_PATH}/config/config.yml"
            i = config["integrity"]
            @integrity_uri = i["uri"]
            @integrity_user = i["user"]
            @integrity_pass = i["password"]
            additional = i["additional_command"]
            @additional_command = additional["command"]
            @includes = additional["include_projects"]
            @excludes = additional["exclude_projects"]

            g = config["gerrit"]
            @git_url = g["git_url"]
            @ssh_url = g["ssh_params"]
        end

        def permission_for_additional_command
            return false unless @includes.include? @project_name or @includes[0] != "all"
            return false if @excludes.include? @project_name
            true
        end
    end

end