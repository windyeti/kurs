Rails.application.routes.draw do

  resources :payplans

  resources :homes, only: [:index] do
    get :manual, on: :collection
  end

  root to: "homes#index"

  resources :integrations, shallow: true do
    collection do
      get :install
      get :login
    end
    resources :review_integrations, shallow: true do
      resources :invoices, shallow: true, default: {invoiceable: "review_integrations"} do
        resources :payments do
          collection do
            post :result
            post :success
            post :fail
          end
        end
        get :print, on: :member
      end
      get :get_reviews, on: :collection
    end
  end

  resources :accounts, only: [:show]

  constraints SubdomainConstraint do

    get '/dashboard/index' , to: 'dashboard#index'
    get '/dashboard/users', to: 'dashboard#users'
    get '/dashboard/test_email', to: 'dashboard#test_email'
    delete '/dashboard/user_destroy', to: 'dashboard#user_destroy'

  end

  devise_for :users

end
