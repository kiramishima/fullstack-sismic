require 'will_paginate'
require 'will_paginate/sequel'
require 'sequel/extensions/pagination'
require 'json'

class FeatureComment < Sequel::Model(:features_comments)
end
