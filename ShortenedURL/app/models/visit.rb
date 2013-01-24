class Visit < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user, :url
end
