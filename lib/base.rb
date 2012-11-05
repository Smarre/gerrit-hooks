
require "psych"
require "net/http"
require "uri/http"

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

        private

        def parse_config
            config = Psych.load_file "#{ROOT_PATH}/config/config.yml"
            i = config["integrity"]
            @integrity_uri = i["uri"]
            @integrity_user = i["user"]
            @integrity_pass = i["password"]

            g = config["gerrit"]
            @git_url = g["git_url"]
        end
    end

end