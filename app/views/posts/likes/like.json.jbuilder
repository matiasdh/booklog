json.post do
  json.id        @post.id
  json.likes     @post.likes_count
  json.liked     @post.liked_by?(current_user)
end
