Rails.application.routes.draw do
  root to: 'api/v1/issues#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, except: [:new, :edit] do
        get :me, on: :collection
      end

      resources :issues, except: [:new, :edit] do
        member do
          patch :take
          put :take
        end

        resources :comments, only: [:index, :create]
      end

      resources :comments, except: [:new, :edit, :index, :create]
    end
  end
end
