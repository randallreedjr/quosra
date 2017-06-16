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
    {
      title: '',
      description: question.description
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # QuestionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it 'displays a list of questions' do
      get :index, params: {}, session: valid_session

      expect(response.body).to include('Questions')
    end
  end

  describe "GET #show" do
    let(:question) { FactoryGirl.create(:question) }

    it 'displays the requested question' do
      get :show, params: {id: question.to_param}, session: valid_session

      expect(response.body).to include(CGI.escapeHTML(question.title))
      expect(response.body).to include(CGI.escapeHTML(question.description))
    end

    context 'when the question has no answers' do
      it 'displays a message encouraging the user to answer' do
        get :show, params: { id: question.to_param }, session: valid_session

        expect(response.body).to include('No one has answered this question yet. Be the first!')
      end
    end

    context 'when the question has answers' do
      let!(:answer_to_question) { FactoryGirl.create(:answer, question_id: question.id) }
      let!(:other_answer) { FactoryGirl.create(:answer) }

      it "displays a list of answers for the question" do
        get :show, params: { id: question.to_param }, session: valid_session

        expect(response.body).to include(CGI.escapeHTML(answer_to_question.content))
        expect(response.body).to_not include(CGI.escapeHTML(other_answer.content))
      end
    end
  end

  describe "GET #new" do
    context 'when user is logged in' do
      let(:current_user) { FactoryGirl.create(:user) }
      before :each do
        sign_in current_user
      end

      it 'displays the form for a new question' do
        get :new, params: {}, session: valid_session

        expect(response.body).to match(/<form action="\/questions" accept-charset="UTF-8" method="post"/)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get :new, params: {}, session: valid_session

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

      context 'when user created question' do
        let(:question) { FactoryGirl.create(:question, user: current_user) }
        it 'displays the form to edit a question' do
          get :edit, params: {id: question.to_param}, session: valid_session

          expect(response.body).to match(/<form action="\/questions\/#{question.id}" accept-charset="UTF-8" method="post"/)
          expect(response.body).to include(CGI.escapeHTML(question.title))
          expect(response.body).to include(CGI.escapeHTML(question.description))
        end
      end

      context 'when user did not create question' do
        let(:question) { FactoryGirl.create(:question) }
        it 'redirects to the question' do
          get :edit, params: {id: question.to_param}, session: valid_session

          expect(response).to redirect_to(question)
        end
      end
    end

    context 'when user is not logged in' do
      let(:question) { FactoryGirl.create(:question) }

      it 'redirects to login page' do
        get :edit, params: {id: question.to_param}, session: valid_session

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

      context "with invalid params" do
        it "does not create a new question" do
          expect {
            post :create, params: {question: invalid_attributes}, session: valid_session
          }.to_not change(Question, :count)
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        post :create, params: {question: valid_attributes}, session: valid_session
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
        let(:new_question) { FactoryGirl.build(:question) }
        let(:new_attributes) {
          {
            title: new_question.title,
            description: new_question.description
          }
        }

        context 'when question was created by current user' do
          let(:question) { FactoryGirl.create(:question, user: current_user) }

          it "updates the requested question" do
            put :update, params: {id: question.to_param, question: new_attributes}, session: valid_session
            question.reload
            expect(question.title).to eq(new_question.title)
            expect(question.description).to eq(new_question.description)
          end

          it "redirects to the question" do
            put :update, params: {id: question.to_param, question: valid_attributes}, session: valid_session
            expect(response).to redirect_to(question)
          end
        end

        context 'when question was created by different user' do
          let(:question) { FactoryGirl.create(:question) }

          it 'does not update question title' do
            expect {
              put :update, params: {id: question.to_param, question: new_attributes}, session: valid_session
            }.to_not change(question, :title)
          end

          it 'does not update question description' do
            expect {
              put :update, params: {id: question.to_param, question: new_attributes}, session: valid_session
            }.to_not change(question, :description)
          end

          it "redirects to the question" do
            put :update, params: {id: question.to_param, question: new_attributes}, session: valid_session

            expect(response).to redirect_to(question)
          end
        end
      end

      context "with invalid params" do
        let(:question) { FactoryGirl.create(:question, user: current_user) }

        it "does not update the question" do
          put :update, params: {id: question.to_param, question: invalid_attributes}, session: valid_session
          question.reload

          expect(question.title).to_not be_blank
        end
      end
    end

    context 'when user is not logged in' do
      let(:question) { FactoryGirl.create(:question) }
      let(:new_question) { FactoryGirl.build(:question) }
      let(:new_attributes) {
        {
          title: new_question.title,
          description: new_question.description
        }
      }

      it 'redirects to login page' do
        put :update, params: {id: question.to_param, question: new_attributes}, session: valid_session
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context 'when user is logged in' do
      let(:current_user) { FactoryGirl.create(:user) }
      before :each do
        sign_in current_user
      end

      context 'when user created question' do
        let!(:question) { FactoryGirl.create(:question, user: current_user) }

        it "deletes the question" do
          expect {
            delete :destroy, params: {id: question.to_param}, session: valid_session
          }.to change(Question, :count).by(-1)
        end

        it "redirects to the questions list" do
          delete :destroy, params: {id: question.to_param}, session: valid_session
          expect(response).to redirect_to(questions_url)
        end
      end

      context 'when user did not create question' do
        let!(:question) { FactoryGirl.create(:question) }

        it 'does not delete the question' do
          expect {
            delete :destroy, params: {id: question.to_param}, session: valid_session
          }.to_not change(Question, :count)
        end

        it 'redirects to login page' do
          delete :destroy, params: {id: question.to_param}, session: valid_session
          expect(response).to redirect_to(question)
        end
      end
    end

    context 'when user is not logged in' do
      let!(:question) { FactoryGirl.create(:question) }

      it 'does not delete the question' do
        expect {
          delete :destroy, params: {id: question.to_param}, session: valid_session
        }.to_not change(Question, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: {id: question.to_param}, session: valid_session
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
