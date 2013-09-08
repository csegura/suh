Suh::Application.routes.draw do

  #match '/me', :to => redirect("#{::AppConfig.main_web}/me")

  constraints(SubDomain) do
    root :to => "dashboard#index"

    resource :dashboard, :path => "", :only => [:index], :controller => "dashboard" do
      get :unread_count
      get :read_all
      get :calendar
      get :calendar_data
    end

    #resource :ajax, :only => [], :controller => "ajax" do
    #  get :unread_count
    #end
    match 'ajax/accesses_in_company/:id' => 'ajax#accesses_in_company'
    match 'ajax/unread_count' => 'ajax#unread_count'

    resources :issues do
      get :close, :on => :member
      get :reopen, :on => :member
      resources :comments, :only => [:create]
      resources :timetracks, :only => [:create]
    end

    resources :documents do
      get :download, :on => :member
      resources :comments, :only => [:create]
    end

    resources :comments, :only=> [:show,:destroy]
    resources :timetracks, :only=> [:index, :show,:destroy] do
      get :confirm, :on => :member
    end

    resources :activities, :only => [] do
      get :read, :unread
    end

    resources :writeboards do
      get "version/:id" => :version, :as => :version
    end


    resource :admin, :controller => :admin, :only => :show do
      scope :module => "admin" do
        resources :categories, :only => [:index, :create, :destroy] do
          post :sort, :on => :collection
          post :rename, :on => :collection
        end
        resources :companies, :except => [:index] do
          resources :accesses, :except => [:index] do
            get :activation
            get :resend_invitation
          end
        end
      end
    end

    #namespace :admin do
    #  resources :accesses
    #  resources :companies
    #end
  end

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
  # just remember to delete public/_index.html.
  root :to => 'home#index'
  get "sample" => 'home#sample'
  get "sample2" => 'home#sample2'
  get "sample3" => 'home#sample3'
  get "full" => 'home#full'

  #resources :companies
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'


  scope "login", :module => "login" do
    get "out" => "sessions#destroy", :as => "log_out"
    get "in" => "sessions#new", :as => "log_in"
    post "in" => "sessions#create", :as => "log_in"

    get "forgot" => "passwords#new", :as => "forgot"
    post "forgot" => "passwords#create", :as => "forgot"

    get "check/:id" => "passwords#edit", :as => "log_edit"
    put "check/:id" => "passwords#update", :as => "log_edit"
  end

  resource :me, :only => [:show, :edit, :update], :controller => :me do
    resource :account, :only => [:edit, :update], :controller => "me/account"
    resource :profile, :only => [:edit, :update], :controller => "me/profile"

    #resources :companies, :controller => "me/companies", :requirements => { :id => /[A-Z][a-z][0-9]+/ } do
    #  resources :accesses, :controller => "me/accesses"
    #end
    #resources :activities, :controller => "me/activities", :only => [:index]
  end

end
