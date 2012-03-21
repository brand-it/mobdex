Mobdex::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  
  resources :domains, :only => [:index, :show] do
    member do 
       get "get_data"
    end
  end
  
  resources :admin_domains do
    member do
      get "update_domain"
    end
    collection do
      get "update_all"
    end
  end
  
  resources :mass_domains do
    member do
      get "error_message"
      get "add_domains"
    end
  end
  
  match "/domains/search/:search" => "domains#index", :as => "search_domains"

  resources :tags, :only => [:index, :show]

  resources :users do
    collection do
      get "request_activation"
      post "resend_activation"
    end
  end
  resources :user_sessions
  
  match "login" => "user_sessions#new", :as => "login"
  match 'logout', :to => 'user_sessions#destroy', :as => "logout"
  
  # Activation did not work or something and you need it sent again.
  
  # Acctivation Account url
  match "/activate/:perishable_token" => "users#activate", :as => "activate_user"
  
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  match "welcome" => "landing#welcome", :as => :welcome
  
  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'domains#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
