Rails.application.routes.draw do
  resources :questionnaire, only: [:update, :show], controller: "questionnaire"
  resource :confirmations do
    collection do
      get "confirm_otp"
      post "validate_otp"
      get "confirm_email_for_otp"
      post "resend_otp"
    end
  end
  get "thankyou", controller: :dashboard, action: :thankyou
  get 'dashboard/advisors'
  get 'dashboard/answers'
  resources :meetings, path: 'meetings/:advisor_id', only: [:new, :create]

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  devise_scope :user do
    # Defines the root path route ("/")
    root to: "devise/sessions#new"
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # letter_opener_web
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
