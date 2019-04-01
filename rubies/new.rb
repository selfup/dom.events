# To use

# ruby rubies/new.rb some-title-with-hyphens
# now a proper file name with enough boilerplate will be created
# if the post is going to be long: pass the '-l' flag
# if the post is going to be short: pass the '-m' flag

current_date = Time.now.to_s.split(' ')[0]

title = ARGV[0]
post_title = title.split('-').join(' ').capitalize
main_header = "#{post_title}".freeze
post_title_name = title.downcase

case ARGV[1]
when '-m'
  post_title = "Micro: #{post_title_name}"
when '-l'
  post_title = "Long: #{post_title_name}"
else

end

default = "---
layout: post
title:  '#{post_title}'
---

# #{post_title_name}

Content
"

file = "_posts/#{current_date}-#{post_title_name}.md"

File.write(file, default)
