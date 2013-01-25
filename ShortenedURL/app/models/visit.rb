class Visit < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :url

  def self.make_a_visit
    print "Username > "
    username = gets.chomp
    print "Short url > "
    shorturl = gets.chomp
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
      puts "That shorturl does not exist!".red
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
      puts "This shorturl does not exist!".green
    else
      comments = Visit.where(:url_id => link.first).select(:comment)
      comments.each_with_index do |comment, i|
        print "#{i.to_s.rjust(2,'0')}:".magenta
        print " #{comment.comment}\n"
      end
    end
    nil
  end

  def self.clicks
    print "Short url > "
    shorturl = gets.chomp

    link = Url.where(:shorturl => shorturl)
    if link.empty?
      puts "This shorturl does not exist!".red
    else
      count = Visit.where(:url_id => link.first).count
      puts "This link has been visited #{count} times!".magenta
    end
    nil
  end

  def self.last_ten
    print "Short url > "
    shorturl = gets.chomp

    link = Url.where(:shorturl => shorturl)
    if link.empty?
      puts "This shorturl does not exist!".red
    else
      recent_clicks = Visit.where(:url_id => link.first).
                            where('created_at > (?)', Time.now-600).count
      puts "This link has been visited #{recent_clicks} times recently!".magenta
    end
    nil
  end

  def self.unique_visitors
    print "Short url > "
    shorturl = gets.chomp

    link = Url.where(:shorturl => shorturl)
    if link.empty?
      puts "This shorturl does not exist!".red
    else
      count = Visit.where(:url_id => link.first).select(:user_id).uniq.count
      puts "This link has been visited by #{count} unique visitors".magenta
    end
    nil
  end

  def self.get_links
    print "Enter a username > "
    name = gets.chomp

    user = User.where(:username => name)
    if user.empty?
      puts "No such user exists!".red
    else
      urls = Url.where(:user_id => user.first)
      urls.each_with_index do |url,i|
        print "#{i.to_s.rjust(2, '0')}:".magenta
        print " #{url.shorturl}".yellow
        print " -> #{url.longurl}\n"
      end
    end
    nil
  end

  def self.get_popular
    tags = ['News', 'Sports', 'Lifestyle', 'Travel', 'Other']
    tags.each_with_index do |t, i|
      print "#{i.to_s.rjust(2, '0')}:".magenta
      print " #{t}\n"
    end
    print "Choose a tag to see popular links > "
    tag = tags[gets.chomp.to_i]

    urls = Url.where(:tag => tag)
    urls.map! do |url|
      [url.shorturl, Visit.where(:url_id => url).count]
    end

    urls.sort! { |a, b| b[1] <=> a[1] }

    urls.each_with_index do |url, i|
      print "#{i.to_s.rjust(2, '0')}:".magenta
      print " #{url[0]}".yellow
      print " -> #{url[1]}\n"
    end
    nil
  end
end
