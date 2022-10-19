Rails.application.routes.draw do
  get '/', to: 'mains#landing', as: 'landing'

  get '/register', to: 'users#new', as: 'register'
  get '/login', to: 'sessions#new', as: 'login'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get '/activate', to: 'users#activate', as: 'activate'
  put '/activate', to: 'users#activated', as: 'activated'
  put '/regerate', to: 'users#regenerate_code', as: 'regenerate_code'

  put '/courses/:course_id/enroll', to: 'courses#enroll', as: 'course_enroll'
  put '/courses/:course_id/posts/:post_id/award', to: 'posts#award', as: 'course_post_award'
  put '/courses/:course_id/posts/:post_id/comments/:comment_id/award', to: 'comments#award', as: 'course_post_comment_award'

  resources :sessions, only: [:create]
  resources :users, except: [:new]

  resources :courses do
    resources :posts do
      resources :comments
    end
  end

end
