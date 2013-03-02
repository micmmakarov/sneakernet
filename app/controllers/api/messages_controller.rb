class Api::MessagesController < ApplicationController

  def index
    @comments = Comment.all
    render json: @commetns.to_json(:include => [:from_user, :to_user])
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.image_id = params[:image_id]
    @comment.from_user_id = current_user.id
    @comment.save!
    render json: @comment.to_json(:include => [:from_user, :to_user])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.from_user_id = current_user
      if @comment.update_attributes(params[:comment])
        render json: @comment.to_json(:include => [:from_user, :to_user])
      else
        head :no_content
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if @comment.from_user_id = current_user
  end

  def show
    @comment = Comment.find(params[:id])
    render json: @comment.to_json(:include => [:from_user, :to_user])
  end
end