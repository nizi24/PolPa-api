class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :screen_name
end