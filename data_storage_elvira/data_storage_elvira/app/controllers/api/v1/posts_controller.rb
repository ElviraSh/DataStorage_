module Api
  module V1
    class PostsController < ApplicationController
    end
  end
end

def index
  @posts = Post.order('created_at DESC')
end

class PostsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  # ...
end

before_action :authenticate, only: [:create, :destroy]

# ...

private

# ...

def authenticate
  authenticate_or_request_with_http_token do |token, options|
    @user = User.find_by(token: token)
  end
end

def create
  @post = @user.posts.new(post_params)
  if @post.save
    render json: @post, status: :created
  else
    render json: @post.errors, status: :unprocessable_entity
  end
end

def destroy
  @post = @user.posts.find_by(params[:id])
  if @post
    @post.destroy
  else
    render json: {post: "not found"}, status: :not_found
  end
end

