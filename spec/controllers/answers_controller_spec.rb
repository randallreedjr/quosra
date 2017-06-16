require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  render_views

  let(:question) { FactoryGirl.create(:question) }
  let(:answer) { FactoryGirl.build(:answer) }
  let(:valid_attributes) {
    {
      question_id: question.id,
      content: answer.content
    }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AnswersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #show" do
    let(:answer) { FactoryGirl.create(:answer, question: question) }
    it 'displays the requested answer and question title' do
      get :show, params: {question_id: question.id, id: answer.to_param}, session: valid_session

      expect(response.body).to include(CGI.escapeHTML(question.title))
      expect(response.body).to include(CGI.escapeHTML(answer.content))
    end
  end

  describe "GET #new" do
    before :each do
      user = FactoryGirl.create(:user)
      sign_in user
    end

    it 'displays the form for a new answer' do
      get :new, params: { question_id: question.id }, session: valid_session

      expect(response.body).to match(/<form action="\/questions\/#{question.id}\/answers" accept-charset="UTF-8" method="post"/)
      expect(response.body).to include(CGI.escapeHTML(question.title))
    end
  end

  describe "GET #edit" do
    before :each do
      user = FactoryGirl.create(:user)
      sign_in user
    end

    it 'displays the form to edit an answer' do
      answer = FactoryGirl.create(:answer, question: question)
      get :edit, params: {id: answer.to_param, question_id: question.to_param}, session: valid_session

      expect(response.body).to match(/<form action="\/questions\/#{question.id}\/answers\/#{answer.id}" accept-charset="UTF-8" method="post"/)
      expect(response.body).to include(CGI.escapeHTML(question.title))
      expect(response.body).to include(CGI.escapeHTML(answer.content))
    end
  end

  describe "POST #create" do
    before :each do
      user = FactoryGirl.create(:user)
      sign_in user
    end

    context "with valid params" do
      it "creates a new Answer" do
        expect {
          post :create, params: {question_id: question.id, answer: valid_attributes}, session: valid_session
        }.to change(Answer, :count).by(1)
      end

      it "redirects to the question being answered" do
        post :create, params: {question_id: question.id, answer: valid_attributes}, session: valid_session

        expect(response).to redirect_to(question_path(question.id))
      end
    end

    xcontext "with invalid params" do
      it "assigns a newly created but unsaved answer as @answer" do
        post :create, params: {answer: invalid_attributes}, session: valid_session
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it "re-renders the 'new' template" do
        post :create, params: {answer: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    before :each do
      user = FactoryGirl.create(:user)
      sign_in user
    end

    context "with valid params" do
      let(:answer) { FactoryGirl.create(:answer) }
      let(:new_answer) { FactoryGirl.build(:answer) }
      let(:new_attributes) {
        {
          question_id: question.id,
          content: new_answer.content
        }
      }

      it "updates the requested answer" do
        put :update, params: {question_id: question.id, id: answer.to_param, answer: new_attributes}, session: valid_session
        answer.reload

        expect(answer.content).to eq(new_answer.content)
        expect(answer.question).to eq(question)
      end

      it "redirects to the answer" do
        put :update, params: {question_id: question.id, id: answer.to_param, answer: valid_attributes}, session: valid_session
        expect(response).to redirect_to(question_path(question.id))
      end
    end

    xcontext "with invalid params" do
      it "assigns the answer as @answer" do
        answer = Answer.create! valid_attributes
        put :update, params: {id: answer.to_param, answer: invalid_attributes}, session: valid_session
        expect(assigns(:answer)).to eq(answer)
      end

      it "re-renders the 'edit' template" do
        answer = Answer.create! valid_attributes
        put :update, params: {id: answer.to_param, answer: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      user = FactoryGirl.create(:user)
      sign_in user
    end

    let(:question) { FactoryGirl.create(:question) }
    let!(:answer) { FactoryGirl.create(:answer, question: question) }

    it "destroys the requested answer" do
      expect {
        delete :destroy, params: {question_id: question.to_param, id: answer.to_param}, session: valid_session
      }.to change(Answer, :count).by(-1)
    end

    it "redirects to the answers list" do
      delete :destroy, params: {question_id: question.to_param, id: answer.to_param}, session: valid_session
      expect(response).to redirect_to(question_url(question))
    end
  end
end
