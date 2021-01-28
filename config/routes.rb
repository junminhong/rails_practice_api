Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :mask
      resources :todos
      resources :pharmacy_stores
      resources :pharmacy_masks
      resources :users
      resources :user_purchase_histories
    end
  end
end
