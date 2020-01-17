class PostController < ApplicationController

	get "/posts/new" do
		if !logged_in?
			flash[:notice] = "you must be logged in"
			redirect "/login"
		end
		erb :"/posts/new"
	end

	post "/posts/new" do
		params[:code_snippet].gsub!("\n", "<br>")
		params[:code_snippet].gsub!("\s", "&nbsp;")
		post = Post.new(params)
		post.user = current_user
		post.save
		redirect "/users/#{current_user.slug}"
	end

	get "/posts/:id/edit" do
		@post = Post.find(params[:id])
		@post.code_snippet.gsub!("<br>", "\n")
		unless @post.user == current_user
			if logged_in?
				flash[:notice] = "post #{params[:id]} does not belong to this account"
			else
				flash[:notice] = "you must be logged in"
			end
			redirect "/login"
		end
		erb :"/posts/edit"
	end

	patch "/posts/:id/edit" do
		params[:post][:code_snippet].gsub!("\n", "<br>")
		params[:post][:code_snippet].gsub!("\s", "&nbsp;")
		post = Post.find(params[:id])
		if logged_in? && post.user == current_user
			post.update(params[:post])
			redirect "/users/#{current_user.slug}"
		end
		flash[:notice] == "post #{params[:id]} does not belong to this account"
		redirect "/login"
	end

	delete "/posts/:id/edit" do
		post = Post.find(params[:id])
		if logged_in? && post.user == current_user
			post.delete
			redirect "/users/#{current_user.slug}"
		end
		flash[:notice] == "post #{params[:id]} does not belong to this account"
		redirect "/login"
	end

end
