require "rubygems"
require 'compass'
require 'ruby_gntp'


module CompassGrowl
  ICON = File.join(File.expand_path('../', __FILE__), '..', 'assets', 'compass_icon.png')
  GROWL = GNTP.new

  LOADED = "Compass Growl Loaded"
  STYLESHEET_SAVED = "Stylesheet Saved"
  STYLESHEET_ERROR = "Stylesheet Error"
  SPRITE_SAVED = "Sprite Saved"
  GROWL.register({:notifications => [{ :name => LOADED, :enabled => true },
                  { :name => STYLESHEET_SAVED, :enabled => true },
                  { :name => SPRITE_SAVED, :enabled => true },
                  { :name => STYLESHEET_ERROR, :enabled => true }]
  })

  def growl(type, message)
    GROWL.notify({
    :name => type,
    :title =>  "Compass",
    :text => message,
    :icon => "file://#{ICON}"
    })
  end

  def init
    CompassGrowl.growl(STYLESHEET_ERROR, "Compass Growl has been initialized")

    config = Compass.configuration

    config.on_stylesheet_saved do |filename|
      CompassGrowl.growl(STYLESHEET_SAVED, "Stylesheet: #{File.basename(filename)} saved")
    end

    config.on_sprite_saved do |filename|
      CompassGrowl.growl(SPRITE_SAVED, "Sprite: #{File.basename(filename)} saved")
    end

    config.on_stylesheet_error do |filename, error|
      CompassGrowl.growl(STYLESHEET_ERROR, "Stylesheet Error: #{File.basename(filename)} \n had the following error:\n #{error}")
    end

  end

  extend self

end

CompassGrowl.init

