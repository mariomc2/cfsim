Rails.application.routes.draw do
  

	scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

		resources :users, :except => [:show] do
			member do
				get :delete
			end
		end
				
		get 'access/menu'
	  get 'access/login'
	  post 'access/attempt_login'
	  get 'access/logout'

	  get 'projections/inputs'
	  post 'projections/create'
	  get 'projections/calculate'

	  root 'projections#inputs'
	end
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
