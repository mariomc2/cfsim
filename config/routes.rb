Rails.application.routes.draw do
  
	#root :to => 'access#login'

	#scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

		root 'projections#inputs'
				
		get 'access/menu'
	  get 'access/login'
	  post 'access/attempt_login'
	  get 'access/logout'

	  # get 'projections/inputs'
	  # post 'projections/create'
	  # get 'projections/calculate'

	  resources :projections do
			collection do
				get :inputs
				get :calculate
			end
		end

	  resources :users, :except => [:show] do
			member do
				get :delete
			end
		end
	#end
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
