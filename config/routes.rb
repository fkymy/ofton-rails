Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users
  notify_to :users,
    with_devise: :users,
    controller: 'users/notifications_with_devise'

  devise_for :admins,
    controllers: {
      sessions: 'admin/sessions'
    },
    path: 'admin',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout'
    }

  # static pages
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'policy' => 'static_pages#policy'
  get 'rule' => 'static_pages#rule'
  get 'terms' => 'static_pages#terms'

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  resources :posts, except: [:edit, :update, :delete], concerns: :paginatable do
    resources :comments, only: [:create]
  end

  resources :users, only: [:show]

  namespace :admin do
    root 'dashboard#index'

    resources :admins, only: [:index]
    resources :posts, only: [:index, :show]
  end
end
