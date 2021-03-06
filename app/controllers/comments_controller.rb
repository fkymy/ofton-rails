class CommentsController < ApplicationController
  # decorates_assigned :comment

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    @comment.user = current_user
    @comment.body = helpers.simple_nkf(comment_params[:body])

    if @comment.save
      ActivityNotification::Notification.notify(:users, @comment, notifier: @comment.user, group: @comment.post)

      Slack::CommentCreatedNotifier.notify(
        Slack::Template::CommentCreatedMessage.format(@comment)
      ) unless admin_signed_in?

      redirect_to post_path(@post)
    else
      redirect_to post_path(@post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :author, :body)
  end
end
