Rails.application.routes.draw do
  resources :teams do
    resources :events
    resources :projects
  end

  resources :members

  scope '/projects/:project_id' do
    resources :todos
  end

  root to: 'home#index'
  
end
