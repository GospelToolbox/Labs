require "webpacker/helper"


module SetLive
  module ApplicationHelper
    include ::Webpacker::Helper

    def current_webpacker_instance
      SetLive.webpacker
    end
  end
end
