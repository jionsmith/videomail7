require "yaml"
require "erb"
path = Rails.root.join("config/hdfvr.yml")
HDFVR = YAML.load(ERB.new(File.read(path)).result)[Rails.env]
