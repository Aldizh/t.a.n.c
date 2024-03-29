Tanc::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.
  get "member/signup"
  get "member/confirm_account"
  get "member/thanks"
  get "member/profile"
  get "member/account_setup"
  get "member/account_setup_member"
  get "member/account_setup_non_member"
  get "member/login"
  get "member/thanks_after_done"
  get "member/admin"
  get "member/reset_password"
  get "member/reset_email_sent"
  get "member/update_password"
  get "member/reset_success"
  get "member/member_payment"
  get "member/online_payment"
  get "member/check_cash_payment"
  get "member/admin/export" => 'member#export'
  get "member/destroy"
  get "member/edit_member_profile"
  get "member/admin_edit_member_profile"
  get "member/edit_non_member_profile"
  get "member/edit_success"
  get "member/show"
  get "member/edit"
  # Sample of regular route:
  # match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  # resources :products
  resources :member
  match ':controller/:action'

  # Sample resource route with options:
  # resources :products do
  # member do
  # get 'short'
  # post 'toggle'
  # end
  #
  # collection do
  # get 'sold'
  # end
  # end

  # Sample resource route with sub-resources:
  # resources :products do
  # resources :comments, :sales
  # resource :seller
  # end

  # Sample resource route with more complex sub-resources
  # resources :products do
  # resources :comments
  # resources :sales do
  # get 'recent', :on => :collection
  # end
  # end

  # Sample resource route within a namespace:
  # namespace :admin do
  # # Directs /admin/products/* to Admin::ProductsController
  # # (app/controllers/admin/products_controller.rb)
  # resources :products
  # end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
