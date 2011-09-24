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


Compass.configuration.on_sprite_saved do |filename|
  GrowlNotify.normal(:title => 'Compass', :description => "Sprite: #{File.basename(filename)} saved")
end

Compass.configuration.on_stylesheet_saved do |filename|
  GrowlNotify.normal(:title => 'Compass', :description => "Stylesheet: #{File.basename(filename)} saved")
end

Compass.configuration.on_sprite_removed do |filename|
  GrowlNotify.normal(:title => 'Compass', :description => "Sprite: #{File.basename(filename)} removed")
end

Compass.configuration.on_stylesheet_error do |filename, error|
  GrowlNotify.normal(:title => 'Compass', :description => "Stylesheet Error: #{File.basename(filename)} \n had the following error:\n #{error}")
end


#I hate doing this hacky shit lets hope this api is stablish
if defined?(Sprockets)
  module Sprockets
    class BundledAsset
      
      alias :old_build_dependency_context_and_body :build_dependency_context_and_body
      
      def build_dependency_context_and_body
        data = old_build_dependency_context_and_body
        if pathname.to_s =~ /(scss|sass)/
          GrowlNotify.normal(:title => 'Compass', :description => "Stylesheet Rendered: #{File.basename(pathname)} ")
        end
        return data
      end
      
    end
  end    
end