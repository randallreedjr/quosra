Rails.application.routes.draw do
  root to: "questions#index"

  devise_for :users

  resources :questions do
    resources :answers, except: [:index]
  end

  resources :categories
  resources :category_questions, only: [:create, :destroy]
end
