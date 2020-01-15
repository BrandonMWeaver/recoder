class PostController < ApplicationController

	get "/posts/new" do
		if !logged_in?
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
			redirect "/login"
		end
		erb :"/posts/edit"
	end

	patch "/posts/:id/edit" do
		params[:post][:code_snippet].gsub!("\n", "<br>")
		params[:post][:code_snippet].gsub!("\s", "&nbsp;")
		post = Post.find(params[:id])
		post.update(params[:post])
		redirect "/users/#{current_user.slug}"
	end

end
