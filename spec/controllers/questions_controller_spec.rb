require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  render_views

  let(:question) { FactoryGirl.build(:question) }
  let(:valid_attributes) {
    {
      title: question.title,
      description: question.description
    }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # QuestionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it 'displays a list of questions' do
      question = Question.create! valid_attributes
      get :index, params: {}, session: valid_session

      expect(response.body).to include('Questions')
    end
  end

  describe "GET #show" do
    it 'displays the requested question' do
      question = Question.create! valid_attributes
      get :show, params: {id: question.to_param}, session: valid_session

      expect(response.body).to include(CGI.escapeHTML(question.title))
      expect(response.body).to include(CGI.escapeHTML(question.description))
    end
  end

  describe "GET #new" do
    it 'displays the form for a new question' do
      get :new, params: {}, session: valid_session

      expect(response.body).to match(/<form action="\/questions" accept-charset="UTF-8" method="post"/)
    end
  end

  describe "GET #edit" do
    it 'displays the form to edit a question' do
      question = Question.create! valid_attributes
      get :edit, params: {id: question.to_param}, session: valid_session

      expect(response.body).to match(/<form action="\/questions\/#{question.id}" accept-charset="UTF-8" method="post"/)
      expect(response.body).to include(CGI.escapeHTML(question.title))
      expect(response.body).to include(CGI.escapeHTML(question.description))
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Question" do
        expect {
          post :create, params: {question: valid_attributes}, session: valid_session
        }.to change(Question, :count).by(1)
      end

      it "redirects to the created question" do
        post :create, params: {question: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Question.last)
      end
    end

    xcontext "with invalid params" do
      xit "assigns a newly created but unsaved question as @question" do
        post :create, params: {question: invalid_attributes}, session: valid_session
        expect(assigns(:question)).to be_a_new(Question)
      end

      it "re-renders the 'new' template" do
        post :create, params: {question: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_question) { FactoryGirl.build(:question) }
      let(:new_attributes) {
        {
          title: new_question.title,
          description: new_question.description
        }
      }

      it "updates the requested question" do
        question = Question.create! valid_attributes
        put :update, params: {id: question.to_param, question: new_attributes}, session: valid_session
        question.reload
        expect(question.title).to eq(new_question.title)
        expect(question.description).to eq(new_question.description)
      end

      it "redirects to the question" do
        question = Question.create! valid_attributes
        put :update, params: {id: question.to_param, question: valid_attributes}, session: valid_session
        expect(response).to redirect_to(question)
      end
    end

    xcontext "with invalid params" do
      it "assigns the question as @question" do
        question = Question.create! valid_attributes
        put :update, params: {id: question.to_param, question: invalid_attributes}, session: valid_session
        expect(assigns(:question)).to eq(question)
      end

      it "re-renders the 'edit' template" do
        question = Question.create! valid_attributes
        put :update, params: {id: question.to_param, question: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested question" do
      question = Question.create! valid_attributes
      expect {
        delete :destroy, params: {id: question.to_param}, session: valid_session
      }.to change(Question, :count).by(-1)
    end

    it "redirects to the questions list" do
      question = Question.create! valid_attributes
      delete :destroy, params: {id: question.to_param}, session: valid_session
      expect(response).to redirect_to(questions_url)
    end
  end

end
