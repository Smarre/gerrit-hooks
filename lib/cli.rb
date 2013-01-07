
module GerritHooks

    class Cli

        # #
        # Returns true is success, false if not
        #
        def check_for_success
            element = nil

            while true

                base = GerritHooks::Base.new
                page = base.request_page @result

                element = page.parser.at_xpath "//div[@class='building']"
                break if element.to_s == ""
                sleep 1
            end

            element = page.parser.at_xpath "//div[@class='success']"

            # failure
            if element.to_s == "" then success = true else success = false end

            success
        end

    end

end