Rails.application.routes.draw do
  resources :teams do
    resources :events
  end
end
