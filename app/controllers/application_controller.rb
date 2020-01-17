class ApplicationController < Sinatra::Base

	configure do
		set :public_folder, "public"
		set :views, "app/views"
		enable :sessions
		set :session_secret, "secret"
	end

	get '/' do
		binding.pry
		erb :index
	end

	get "/register" do
		erb :register
	end
	
	post "/register" do
		if User.find_by(username: params[:username]) || User.find_by_slug(params[:username])
			redirect "/register"
		elsif !params.values.any? { |value| value.blank? }
			user = User.create(params)
			session[:user_id] = user.id
			redirect "/users/#{user.slug}"
		end
	end

	get "/login" do
		erb :login
	end

	post "/login" do
		user = User.find_by(username: params[:username])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect "/users/#{user.slug}"
		end
		redirect "/login"
	end

	get "/logout" do
		session.clear
		redirect '/'
	end

	helpers do
		
		def current_user
			@current_user ||= User.find_by_id(session[:user_id])
		end

		def logged_in?
			!!current_user
		end

	end
	
end
