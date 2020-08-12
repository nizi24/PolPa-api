class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :screen_name, :level, :uid
end
