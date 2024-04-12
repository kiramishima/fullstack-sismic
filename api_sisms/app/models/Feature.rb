require 'will_paginate'
require 'will_paginate/sequel'
require 'sequel/extensions/pagination'
require 'json'

class Feature < Sequel::Model(:features)
  # plugin :json_serializer, :json
  # attr_accessor :id, :mag, :place, :time, :url, :tsunami, :magtype, :title, :latitude, :longitude
end