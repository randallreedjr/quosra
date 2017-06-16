# Visit list of questions
# View question
# View answer
# Back to answers
# Back to questions

require 'rails_helper'

RSpec.describe 'Questions and Answers', type: :feature do
  context 'viewing list of questions' do
    describe 'creating a new question' do
      it 'displays the question on the questions page' do
        visit '/questions'
        click_link 'New Question'
        fill_in 'Title', with: 'Sample question'
        fill_in 'Description', with: 'Some optional description text'
        click_button 'Create Question'

        expect(page).to have_content 'Question was successfully created.'
        expect(page).to have_content 'Sample question'
        expect(page).to have_content 'Some optional description text'
      end
    end
  end

  context 'viewing a question' do
    let!(:question) { FactoryGirl.create(:question) }
    let!(:answer) { FactoryGirl.create(:answer, question: question) }

    it 'displays a list of answers' do
      visit '/questions'
      click_link 'Show'

      expect(page).to have_content question.title
      expect(page).to have_content question.description
      expect(page).to have_content answer.content
    end

    it 'displays Edit and Delete links' do
      visit '/questions'
      click_link 'Show'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end

    it 'links back to the questions page' do
      visit '/questions'
      click_link 'Show'
      click_link 'Back to all questions'

      expect(page).to have_content('Questions')
    end

    describe 'creating a new answer' do
      it 'displays the answer on the question page' do
        visit '/questions'
        click_link 'Show'
        click_link 'New Answer'
        fill_in 'Content', with: "Here's my answer to your q"
        click_button 'Create Answer'

        expect(page).to have_content question.title
        expect(page).to have_content question.description
        expect(page).to have_content answer.content
        expect(page).to have_content "Here's my answer to your q"
      end

      it 'goes back to question page on cancel' do
        visit '/questions'
        click_link 'Show'
        click_link 'New Answer'
        click_link 'Back'

        expect(page).to have_content question.description
      end
    end

    describe 'updating a question' do
      let(:new_question) { FactoryGirl.build(:question) }
      it 'displays the new question title and description' do
        visit '/questions'
        click_link 'Show'
        click_link 'Edit'
        fill_in 'Title', with: new_question.title
        fill_in 'Description', with: new_question.description
        click_button 'Update Question'

        expect(page).to have_content 'Question was successfully updated.'
        expect(page).to have_content new_question.title
        expect(page).to have_content new_question.description
      end
    end
  end

  context 'viewing an answer' do
    let!(:question) { FactoryGirl.create(:question) }
    let!(:answer) { FactoryGirl.create(:answer, question: question) }

    it 'displays an the question title and the answer' do
      visit '/questions'
      click_link 'Show'
      click_link 'View'

      expect(page).to have_content(question.title)
      expect(page).to_not have_content(question.description)
      expect(page).to have_content(answer.content)
    end

    it 'displays Edit and Delete links' do
      visit '/questions'
      click_link 'Show'
      click_link 'View'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end

    it 'links back to the answers page' do
      visit '/questions'
      click_link 'Show'
      click_link 'View'
      click_link 'Back to all answers'

      expect(page).to have_content('Answers')
    end

    describe 'updating an answer' do
      let(:new_answer) { FactoryGirl.build(:answer, question: question) }
      it 'displays the new question title and description' do
        visit '/questions'
        click_link 'Show'
        click_link 'View'
        click_link 'Edit'
        fill_in 'Content', with: new_answer.content
        click_button 'Update Answer'

        expect(page).to have_content 'Answer was successfully updated.'
        expect(page).to have_content 'Answers'
        expect(page).to have_content new_answer.content
      end
    end
  end

  describe 'deleting an answer' do
    let!(:question) { FactoryGirl.create(:question) }
    let!(:answer) { FactoryGirl.create(:answer, question: question) }

    it 'removes the answer from the question' do
      visit '/questions'
      click_link 'Show'
      click_link 'View'
      click_link 'Delete'

      expect(page).to have_content('Answers')
      expect(page).to_not have_content(answer.content)
    end
  end

  describe 'deleting an question' do
    let!(:question) { FactoryGirl.create(:question) }
    let!(:answer) { FactoryGirl.create(:answer, question: question) }

    it 'removes the answer from the question' do
      visit '/questions'
      click_link 'Show'
      click_link 'Delete'

      expect(page).to have_content('Questions')
      expect(page).to_not have_content(question.title)
    end
  end
end
