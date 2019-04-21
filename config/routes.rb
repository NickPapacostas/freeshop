Rails.application.routes.draw do
  get 'volunteers/sign_up', to: 'volunteers#no_signups'

  devise_for :volunteers, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :volunteers do
  	get 'dashboard', to: 'dashboards#show'
  end

  resources :checkouts
  resources :appointments do
    collection do
      get 'by_day', to: 'appointments#by_day'
      get 'by_datetime', to: 'appointments#by_datetime'
      get 'by_month', to: 'appointments#by_month'
    end
  end

  namespace :metrics do
    get 'dashboard', to: 'dashboards#show'
    get 'dashboard/items', to: 'dashboards#items'
    get 'dashboard/top_for_day', to: 'dashboards#top_for_day'
    get 'dashboard/appointments', to: 'dashboards#appointments'
  end

  resources :memberships
  resources :members

	devise_scope :volunteer do
	  # add after sign in path
	  #  https://stackoverflow.com/questions/19855866/how-to-set-devise-sign-in-page-as-root-page-in-rails
	  root :to => 'devise/sessions#new'
	end
end

