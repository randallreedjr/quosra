class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /questions
  # GET /questions.json
  def index
    if params[:category_ids]
      # filter questions by categories
      @questions = Question.by_categories(params[:category_ids])
    else
      # no filters
      @questions = Question.all
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
    if @question.user != current_user
      redirect_to @question, notice: 'Question may only be edited by original author.'
    end
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    @question.user = current_user

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.user != current_user
        format.html { redirect_to @question, notice: 'Question may only be updated by original author.' }
        format.json { render json: { error: 'Question could not be updated.' }, status: :unprocessable_entity }
      elsif @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    if @question.user != current_user
      respond_to do |format|
        format.html { redirect_to @question, notice: 'Question may only be deleted by original author.' }
        format.json { render json: { error: 'Question could not be deleted.' }, status: :unprocessable_entity }
      end
    else
      @question.destroy
      respond_to do |format|
        format.html { redirect_to questions_url, notice: 'Question was successfully deleted.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.includes(:answers).find(params[:id])
      @answers = @question.answers
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :description)
    end
end
