# To use

# ruby rubies/new.rb some-title-with-hyphens
# now a proper file name with enough boilerplate will be created
# if the post is going to be long: pass the '-l' flag
# if the post is going to be short: pass the '-m' flag

current_date = Time.now.to_s.split(' ')[0]

title = ARGV[0].freeze
post_title = title.split('-').join(' ').capitalize
main_header = "#{post_title}".freeze

case ARGV[1]
when '-m'
  post_title = "Micro: #{post_title}"
when '-l'
  post_title = "Long: #{post_title}"
else

end

default = "---
layout: post
title:  '#{post_title}'
---

# #{main_header}

Content
"

file = "_posts/#{current_date}-#{title}.md"

File.write(file, default)
