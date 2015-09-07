Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :issues, except: [:new, :edit] do
        resources :comments, only: [:index]
      end

      resources :comments, except: [:new, :edit, :index]
    end
  end
end
