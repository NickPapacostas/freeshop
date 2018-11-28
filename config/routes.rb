Rails.application.routes.draw do
  devise_for :volunteers
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

  namespace :admin do
    get 'dashboard', to: 'dashboards#show'
    get 'dashboard/by_day', to: 'dashboards#checkout_items_by_day'
    get 'dashboard/top_for_day', to: 'dashboards#top_for_day'
  end

  resources :memberships
  resources :members

	devise_scope :volunteer do
	  # add after sign in path
	  #  https://stackoverflow.com/questions/19855866/how-to-set-devise-sign-in-page-as-root-page-in-rails
	  root :to => 'devise/sessions#new'
	end
end

