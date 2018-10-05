current_date = Time.now.to_s.split(' ')[0]

title = ARGV[0]

default = "---
layout: post
title:  #{title}
---

# Title

Content
"

file = "./../_posts/#{current_date}-#{title}.md"

File.write(file, default)
