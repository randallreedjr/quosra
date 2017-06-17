class CategoryQuestionsController < ApplicationController
  def create
    CategoryQuestion.create(
      category_id: params[:category_id],
      question_id: params[:question_id]
    )
  end

  def destroy
    CategoryQuestion.where(
      category_id: params[:category_id],
      question_id: params[:question_id]
    ).first&.destroy
  end
end
