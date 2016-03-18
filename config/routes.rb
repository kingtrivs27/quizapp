Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".


  match '/v1/register_user' => 'api/v1/users#register', :via => 'post'
  match '/v1/get_user' => 'api/v1/users#get_user', :via => 'post'

  match '/v1/get_subjects' => 'api/v1/subjects#get_subjects', :via => 'post'
  # doing this for now till v2 is really needed
  match '/v2/get_subjects' => 'api/v1/subjects#get_subjects_v2', :via => 'post'

  match '/v1/update_device_info' => 'api/v1/users#update_device_info', :via => 'post'

  match '/v1/notification_test' => 'api/v1/notifications#test_notify', :via => 'post'

  match '/v1/quiz_request' => 'api/v1/quizes#quiz_request', :via => 'post'

  match '/v1/submit_answer' => 'api/v1/quizes#submit_answer', :via => 'post'

  match '/v2/about_us' => 'home#about_us', :via => 'get'

  match '/v2/drawer' => 'api/v1/navigations#drawer_menu', :via => 'post'

  match '/v1/upload_from_file/:course_file' => 'api/v1/subjects#import_questions_from_csv', :via => 'get'

  match '/v1/get_game_profile' => 'api/v1/users#get_game_profile', :via => 'post'

  # match '/v1/get_user_info_by_email' => 'api/v1/users#get_info_by_email', :via => 'post'


  # You can have the root of your site routed with "root"
  root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
