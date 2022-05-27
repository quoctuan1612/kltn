Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root "static_pages#home"
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  as :user do
    get "signin" => "devise/sessions#new"
    post "signin" => "devise/sessions#create"
    delete "signout" => "devise/sessions#destroy"
  end

  resources :users
  resources :attempts do
    member do
      get :show_detail
    end
    collection do
      get :check_any_pending
    end
  end
  
  namespace :admin do
    root "dashboard#index"
    resources :categories
    resources :questions
    resources :users
    resources :exams do
      collection do
        get :random_questions
      end
      member do
        get :attempts_in_exam
      end
    end
    resources :attempts do
      member do
        get :show_detail
      end
    end
  end
end
