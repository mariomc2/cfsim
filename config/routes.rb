Rails.application.routes.draw do
  

	scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
		resources :projections do
			collection do
				post :calculate
			end
		end
		root 'projections#index'
	end
  

  #get 'projection/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
