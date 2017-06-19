class CategoryQuestionsController < ApplicationController
  after_action :update_elasticsearch_question

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

  private

  def update_elasticsearch_question
    # need to trigger index update
    update_elasticsearch_document Question.find(params[:question_id])
  end
end
