# frozen_string_literal: true

namespace :katalyst_basic_auth do
  desc "Display basic auth information for the app"
  task info: :environment do
    puts Katalyst::Basic::Auth::Config.description
  end
end
