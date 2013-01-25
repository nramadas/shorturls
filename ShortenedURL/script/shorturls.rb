def run
  while true
    puts "What do you want to do?"
    puts "(s)horten a url, (g)o to a shortened url, (v)iew stats, (q)uit"
    print "> "
    case gets.chomp[0]
    when 's'
      u = Visit.make_short_url
      Launchy::open(u.longurl)
    when 'g'
      v = Visit.make_a_visit
      Visit.print_comments(v.url.shorturl)
      Launchy::open(v.url.longurl)
    when 'v'
      print "(c)licks per url, (u)nique visitors per url,"
      print " (l)inks per user, links by (t)ag\n"
      print "> "
      case gets.chomp[0]
      when 'c'
        Visit.clicks
      when 'u'
        Visit.unique_visitors
      when 'l'
        Visit.get_links
      when 't'
        Visit.get_popular
      else
        # do nothing
      end
    when 'q'
      break
    else
      # do nothing
    end
  end
end

run