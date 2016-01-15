Rails.application.routes.draw do
  resources :teams do
    resources :events
    resources :projects
  end
end
