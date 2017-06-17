require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  render_views

  let(:question) { FactoryGirl.create(:question) }
  let(:answer) { FactoryGirl.build(:answer) }
  let(:valid_attributes) {
    {
      content: answer.content
    }
  }

  let(:invalid_attributes) {
    {
      content: ''
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AnswersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #show" do
    let(:answer) { FactoryGirl.create(:answer, question: question) }
    it 'displays the requested answer and question title' do
      get :show, params: {question_id: question.to_param, id: answer.to_param}, session: valid_session

      expect(response.body).to include(CGI.escapeHTML(question.title))
      expect(response.body).to include(CGI.escapeHTML(answer.content))
    end
  end

  describe "GET #new" do
    context 'when user is logged in' do
      let(:current_user) { FactoryGirl.create(:user) }
      before :each do
        sign_in current_user
      end

      it 'displays the form for a new answer' do
        get :new, params: { question_id: question.id }, session: valid_session

        expect(response.body).to match(/<form action="\/questions\/#{question.id}\/answers" accept-charset="UTF-8" method="post"/)
        expect(response.body).to include(CGI.escapeHTML(question.title))
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get :new, params: { question_id: question.id }, session: valid_session

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do

    context 'when user is logged in' do
      let(:current_user) { FactoryGirl.create(:user) }

      before :each do
        sign_in current_user
      end

      context 'when user created answer' do
        let(:answer) { FactoryGirl.create(:answer, question: question, user: current_user) }

        it 'displays the form to edit an answer' do
          get :edit, params: {id: answer.to_param, question_id: question.to_param}, session: valid_session

          expect(response.body).to match(/<form action="\/questions\/#{question.id}\/answers\/#{answer.id}" accept-charset="UTF-8" method="post"/)
          expect(response.body).to include(CGI.escapeHTML(question.title))
          expect(response.body).to include(CGI.escapeHTML(answer.content))
        end
      end

      context 'when user did not create answer' do
        let(:answer) { FactoryGirl.create(:answer, question: question) }

        it 'redirects to the answer' do
          get :edit, params: {id: answer.to_param, question_id: question.to_param}, session: valid_session

          expect(response).to redirect_to(question_answer_path(question, answer))
        end
      end
    end

    context 'when user is not logged in' do
      let(:answer) { FactoryGirl.create(:answer, question: question) }

      it 'redirects to login page' do
        get :edit, params: {id: answer.to_param, question_id: question.to_param}, session: valid_session

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context 'when user is logged in' do
      let(:current_user) { FactoryGirl.create(:user) }

      before :each do
        sign_in current_user
      end

      context "with valid params" do
        it "creates a new Answer" do
          expect {
            post :create, params: {question_id: question.to_param, answer: valid_attributes}, session: valid_session
          }.to change(Answer, :count).by(1)
        end

        it "redirects to the question being answered" do
          post :create, params: {question_id: question.to_param, answer: valid_attributes}, session: valid_session

          expect(response).to redirect_to(question_path(question.id))
        end
      end

      context "with invalid params" do
        it "does not create a new answer" do
          expect {
            post :create, params: {question_id: question.to_param, answer: invalid_attributes}, session: valid_session
          }.to_not change(Answer, :count)
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        post :create, params: {question_id: question.to_param, answer: valid_attributes}, session: valid_session

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PUT #update" do
    context 'when user is logged in' do
      let(:current_user) { FactoryGirl.create(:user) }

      before :each do
        sign_in current_user
      end


      context "with valid params" do
        let(:new_answer) { FactoryGirl.build(:answer) }
        let(:new_attributes) {
          {
            question_id: question.id,
            content: new_answer.content
          }
        }

        context 'when answer was created by current user' do
          let(:answer) { FactoryGirl.create(:answer, question: question, user: current_user) }

          it 'updates the answer' do
            put :update, params: {question_id: question.to_param, id: answer.to_param, answer: new_attributes}, session: valid_session
            answer.reload

            expect(answer.content).to eq(new_answer.content)
            expect(answer.question).to eq(question)
          end

          it 'redirects to the answer' do
            put :update, params: {question_id: question.to_param, id: answer.to_param, answer: valid_attributes}, session: valid_session

            expect(response).to redirect_to(question_path(question.id))
          end
        end

        context 'when answer was created by different user' do
          let(:answer) { FactoryGirl.create(:answer, question: question) }

          it 'does not update question description' do
            expect {
              put :update, params: {question_id: question.to_param, id: answer.to_param, answer: new_attributes}, session: valid_session
            }.to_not change(answer, :content)
          end

          it "redirects to the question" do
            put :update, params: {question_id: question.to_param, id: answer.to_param, answer: new_attributes}, session: valid_session

            expect(response).to redirect_to(question)
          end
        end
      end

      context "with invalid params" do
        let(:answer) { FactoryGirl.create(:answer, question: question, user: current_user) }

        it "does not update the question" do
          put :update, params: {question_id: question.to_param, id: answer.to_param, answer: invalid_attributes}, session: valid_session
          answer.reload

          expect(answer.content).to_not be_blank
        end
      end
    end

    context 'when user is not logged in' do
      let(:answer) { FactoryGirl.create(:answer) }
      let(:new_answer) { FactoryGirl.build(:answer) }
      let(:new_attributes) {
        {
          question_id: question.id,
          content: new_answer.content
        }
      }

      it 'redirects to login page' do
        put :update, params: {question_id: question.to_param, id: answer.to_param, answer: valid_attributes}, session: valid_session

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:question) { FactoryGirl.create(:question) }

    context 'when user is logged in' do
      let(:current_user) { FactoryGirl.create(:user) }

      before :each do
        sign_in current_user
      end

      context 'when user created answer' do
        let!(:answer) { FactoryGirl.create(:answer, question: question, user: current_user) }

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

      context 'when user did not create answer' do
        let!(:answer) { FactoryGirl.create(:answer, question: question) }

        it "does not destroy the requested answer" do
          expect {
            delete :destroy, params: {question_id: question.to_param, id: answer.to_param}, session: valid_session
          }.to_not change(Answer, :count)
        end

        it "redirects to the answers list" do
          delete :destroy, params: {question_id: question.to_param, id: answer.to_param}, session: valid_session
          expect(response).to redirect_to(question_url(question))
        end
      end
    end

    context 'when user is not logged in' do
      let!(:answer) { FactoryGirl.create(:answer, question: question) }

      it 'redirects to login page' do
        put :update, params: {question_id: question.to_param, id: answer.to_param, answer: valid_attributes}, session: valid_session

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
