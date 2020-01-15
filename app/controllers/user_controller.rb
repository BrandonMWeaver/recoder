class UserController < ApplicationController
	
	get "/users/:slug" do
		@user = User.find_by_slug(params[:slug])
		erb :"users/show"
	end

	get "/users/:slug/account" do
		if logged_in? && current_user.slug == params[:slug]
			erb :"users/edit"
		else
			redirect "/login"
		end
	end

	patch "/users/:slug/account" do
		unless User.find_by(username: params[:user][:username]) && current_user != User.find_by(username: params[:user][:username])
			current_user.update(params[:user])
		else
			redirect "users/#{current_user.slug}/account"
		end
		redirect "/users/#{current_user.slug}"
	end

end
