require 'ostruct'
require 'yaml'

config = OpenStruct.new(YAML.load_file("#{Rails.root}/config/app_config.yml"))
common = config.common || {}
common.update(config.send(Rails.env))
::AppConfig = OpenStruct.new(common)