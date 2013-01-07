
module GerritHooks

    class Cli

        # #
        # Returns true is success, false if not
        #
        def check_for_success uri
            element = nil

            while true

                base = GerritHooks::Base.new
                page = base.request_page uri

                element = page.parser.at_xpath "//div[@class='building']"
                break if element.to_s == ""
                sleep 1
            end

            element = page.parser.at_xpath "//div[@class='success']"

            # failure
            if element.to_s == ""
                success = false
            else
                success = true
            end

            success
        end

    end

end