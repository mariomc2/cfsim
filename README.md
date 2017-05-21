# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

heroku run rake db:migrate --app cashflowprojections

 HEROKU -- this code below will help to not pass secret key on github and allows the app to be deployed on Heroku 
 Added to config/environments/production.rb
  config.secret_key_base = ENV["SECRET_KEY_BASE"]  
