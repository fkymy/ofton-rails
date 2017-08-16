class Admin::PostsController < ApplicationController

  def index
    @posts = Post.all.order_by_default.page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    @post.author = helpers.simple_nkf(post_params[:author])
    @post.body = helpers.simple_nkf(post_params[:body])

    if @post.save
      Slack::PostCreatedNotifier.notify(Slack::Template::PostCreatedMessage.format(@post))

      redirect_to @post
    else
      render 'new'
    end
  end

  private

  def post_params
    params.require(:post).permit(:author, :body)
  end
end