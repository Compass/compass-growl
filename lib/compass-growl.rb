require "rubygems"
require 'growl_notify'

module CompassGrowl
  ICON = File.join(File.expand_path('../', __FILE__), '..', 'assets', 'compass_icon.png')
end

GrowlNotify.config do |config|
  config.notifications = config.default_notifications = ["compass"]
  config.application_name = config.notifications.first
  config.icon = CompassGrowl::ICON
end

GrowlNotify.normal(:title => 'Compass', :description => "Compass Growl Loaded")

module Compass
  module Configuration
    class Data
      alias :old_run_callback :run_callback
      def run_callback(event, *args)
        case event
          when :stylesheet_saved
            GrowlNotify.normal(:title => 'Compass', :description => "Stylesheet: #{File.basename(args.first)} saved")
          when :sprite_saved
            GrowlNotify.normal(:title => 'Compass', :description => "Sprite: #{File.basename(args.first)} saved")
          when :stylesheet_error
            GrowlNotify.normal(:title => 'Compass', :description => "Stylesheet Error: #{File.basename(args.first)} \n had the following error:\n #{args.last}")
        end
        old_run_callback(event, *args)
      end
      
    end
  end
end