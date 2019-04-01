set -e

# ./scripts/new.sh 'new-blog-post-title' <optional_flag>

ruby rubies/new.rb $1 $2 \
  && echo "new post boilerplate has been made in $(pwd)/_posts" 
