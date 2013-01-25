class Url < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user

  def self.generate_url(user)
    puts "Where are you trying to go?"
    print "Long-form url > "
    longurl = gets.chomp
    tags = ['News', 'Sports', 'Lifestyle', 'Travel', 'Other']
    tags.each_with_index do |t, i|
      puts "#{i.to_s.rjust(2, '0')}: #{t}"
    end
    print "Choose a relevant tag > "
    tag = tags[gets.chomp.to_i]

    while true
      shorturl = rand(9999).to_s.rjust(4, '0')
      break if Url.where(:shorturl => shorturl).empty?
    end

    puts "Using shorturl #{shorturl}"

    u = Url.new
    u.shorturl = shorturl
    u.longurl = longurl
    u.user = user
    u.tag = tag
    u.save!
    u
  end
end
