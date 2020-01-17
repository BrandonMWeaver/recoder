class UserController < ApplicationController
	
	get "/users/:slug" do
		@user = User.find_by_slug(params[:slug])
		erb :"users/show"
	end

	get "/users/:slug/account" do
		if logged_in? && current_user.slug == params[:slug]
			erb :"users/edit"
		else
			if logged_in?
				flash[:notice] = "you do not own this account"
			else
				flash[:notice] = "you must be logged in"
			end
			redirect "/login"
		end
	end

	patch "/users/:slug/account" do
		if logged_in? && current_user.slug == params[:slug]
			unless User.find_by(username: params[:user][:username]) && current_user != User.find_by(username: params[:user][:username])
				current_user.update(params[:user])
				redirect "/users/#{current_user.slug}"
			else
				flash[:notice] = "the username \"#{params[:user][:username]}\" is unavailable"
				redirect "users/#{current_user.slug}/account"
			end
		end
		flash[:notice] = "you do not own this account"
		redirect "/login"
	end

	delete "/users/:slug/account" do
		if logged_in? && current_user.slug == params[:slug]
			user = current_user
			user.posts.each do |post|
				post.delete
			end
			user.delete
		else
			if logged_in?
				flash[:notice] = "you do not own this account"
			else
				flash[:notice] = "you must be logged in"
			end
			redirect "/login"
		end
		redirect "/logout"
	end

end
