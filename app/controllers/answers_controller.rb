class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_question, only: [:new, :create, :update, :destroy]
  after_action :update_elasticsearch_question, only: [:create, :update, :destroy]

  # GET /answers/1
  # GET /answers/1.json
  def show
    @question = @answer.question
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
    @question = @answer.question
    if @answer.user != current_user
      redirect_to question_answer_path(@question, @answer), notice: 'Answer may only be edited by original author.'
    end
  end

  # POST /answers
  # POST /answers.json
  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        format.html { redirect_to @question, notice: 'Answer was successfully created.' }
        format.json { render :show, status: :created, location: @answer }
      else
        format.html { render :new }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    respond_to do |format|
      if @answer.user != current_user
        format.html { redirect_to question_url(@question), notice: 'Answer may only be updated by original author.' }
        format.json { render json: { error: 'Answer could not be updated.' }, status: :unprocessable_entity }
      elsif @answer.update(answer_params)
        format.html { redirect_to question_url(@question), notice: 'Answer was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer }
      else
        format.html { render :edit }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    if @answer.user != current_user
      respond_to do |format|
        format.html { redirect_to question_url(params[:question_id]), notice: 'Answer may only be deleted by original author.' }
        format.json { render json: { error: 'Question could not be deleted.' }, status: :unprocessable_entity }
      end
    else
      @answer.destroy
      respond_to do |format|
        format.html { redirect_to question_url(params[:question_id]), notice: 'Answer was successfully deleted.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.includes(:question).find(params[:id])
    end

    def set_question
      @question = Question.find(params[:question_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:content, :question_id)
    end

    def update_elasticsearch_question
      # need to trigger index update
      update_elasticsearch_document(@question)
    end
end
