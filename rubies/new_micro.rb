# To use

# ruby rubies/new_micro.rb some-title-with-hyphens
# now a proper file name with enough boilerplate will be created

current_date = Time.now.to_s.split(' ')[0]

title = ARGV[0]
post_title = title.split('-').join(' ').capitalize
post_title_name = title.downcase

default = "---
layout: post
title:  '#{post_title}'
---

# #{post_title}

Content
"

file = "_posts/#{current_date}-#{post_title_name}.md"

File.write(file, default)
