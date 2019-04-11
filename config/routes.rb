Rails.application.routes.draw do
# get 'sessions/new'
# get 'users/new'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create' #7.3.4 演習

#セッション管理
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  #UsersモデルへのRESTfulなアクションをまとめて追加
  resources :users

=begin
HTTP  Request|
Verb  | URL          |Action | 名前付きroot     | 用途 |
GET   | /users       |index  | users_path      | 一覧表示
GET   | /users/1     |show   | user_path(user) | 個別表示
GET   | /users/new   |new    | new_user_path   | 新規作成表示
POST  | /users       |create | users_path      | userを作成する
PATCH | /users/1     |update | user_path(user) | userを更新する
DELETE| /users/1     |destroy| user_path(user) | userを削除する
GET   | /users/1/edit|edit   | edit_user_path(user) |
                                          | 個別編集画面表示

Prefix      Verb     URI Pattern              Controller#Action
users       GET     /users(.:format)           users#index
            POST    /users(.:format)           users#create
new_user    GET     /users/new(.:format)       users#new
edit_user   GET     /users/:id/edit(.:format)  users#edit
user        GET     /users/:id(.:format)       users#show
            PATCH   /users/:id(.:format)       users#update
            PUT     /users/:id(.:format)       users#update
            DELETE  /users/:id(.:format)       users#destroy

=end


end
