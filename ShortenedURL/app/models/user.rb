class User < ActiveRecord::Base
  # attr_accessible :title, :body

  def self.create_user(username)
    print "Email > "
    email = gets.chomp

    r = User.new
    r.email = email
    r.username = username
    r.save!
    r
  end

end
