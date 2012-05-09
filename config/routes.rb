TimeEntryApp::Application.routes.draw do
  match '/home', to: 'home#index'
  match '/admin', to: 'static_pages#admin'
  match '/operating_report', to: 'operating_report#index'#, via: :get
  match '/change_team', to: 'users#change_team'

  root to: 'home#index'
  resources :sessions, only: [:new, :create, :destroy]

  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  resources :paid_time_entries

  resources :comments

  resources :time_entries

  resources :tasks

  resources :task_inventories

  resources :assignments

  resources :roles

  resources :teams

  resources :users

  #Routes for AJAX
  match '/users_for_team', to: 'operating_report#users_for_team'
  match '/is_task_direct', to: 'time_entries#is_task_direct'
  match '/is_end_date_disabled', to: 'assignments#is_end_date_disabled'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
