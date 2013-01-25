class Visit < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :url

  def self.make_a_visit
    print "Username > "
    username = gets.chomp
    print "Short url > "
    shorturl = gets.chomp[0...4]
    print "Comment? > "
    comment = gets.chomp

    user = User.where(:username => username)
    if user.empty?
      r = User.create_user(username)
    else
      r = user.first
    end

    url = Url.where(:shorturl => shorturl)
    if url.empty?
      puts "That shorturl does not exist!"
      u = Url.generate_url(r)
    else
      u = url.first
    end

    v = Visit.new
    v.user = r
    v.url = u
    v.comment = comment
    v.save!
    v
  end

  def self.make_short_url
    print "Username > "
    username = gets.chomp

    user = User.where(:username => username)
    if user.empty?
      r = User.create_user(username)
    else
      r = user.first
    end
    Url.generate_url(r)
  end

  def self.print_comments(shorturl)
    link = Url.where(:shorturl => shorturl)
    if link.empty?
      puts "This shorturl does not exist."
    else
      comments = Visit.where(:url_id => link.first).select(:comment)
      comments.each_with_index do |comment, i|
        puts "#{i.to_s.rjust(2,'0')}: #{comment.comment}"
        puts
      end
    end
    nil
  end

  def self.clicks
    print "Short url > "
    shorturl = gets.chomp

    link = Url.where(:shorturl => shorturl)
    if link.empty?
      puts "This shorturl does not exist."
    else
      count = Visit.where(:url_id => link.first).count
      puts "This link has been visited #{count} times!"
    end
    nil
  end

  def self.last_ten
    print "Short url > "
    shorturl = gets.chomp

    link = Url.where(:shorturl => shorturl)
    if link.empty?
      puts "This shorturl does not exist."
    else
      recent_clicks = Visit.where(:url_id => link.first).
                            where('created_at > (?)', Time.now-600).count
      puts "This link has been visited #{recent_clicks} times recently!"
    end
    nil
  end

  def self.unique_visitors
    print "Short url > "
    shorturl = gets.chomp

    link = Url.where(:shorturl => shorturl)
    if link.empty?
      puts "This shorturl does not exist."
    else
      count = Visit.where(:url_id => link.first).select(:user_id).uniq.count
      puts "This link has been visited by #{count} unique visitors"
    end
    nil
  end

  def self.get_links
    print "Enter a username > "
    name = gets.chomp

    user = User.where(:username => name)
    if user.empty?
      puts "No such user exists."
    else
      urls = Url.where(:user_id => user.first)
      urls.each_with_index do |url,i|
        puts "#{i.to_s.rjust(2, '0')}: #{url.shorturl} -> #{url.longurl}"
      end
    end
    nil
  end

  def self.get_popular
    tags = ['News', 'Sports', 'Lifestyle', 'Travel', 'Other']
    tags.each_with_index do |t, i|
      puts "#{i.to_s.rjust(2, '0')}: #{t}"
    end
    print "Choose a tag to see popular links > "
    tag = tags[gets.chomp.to_i]

    urls = Url.where(:tag => tag)
    urls.map! do |url|
      [url.shorturl, Visit.where(:url_id => url).count]
    end

    urls.sort! { |a, b| b[1] <=> a[1] }

    urls.each_with_index do |url, i|
      puts "#{i.to_s.rjust(2, '0')}: #{url[0]} -> #{url[1]}"
    end
    nil
  end
end
