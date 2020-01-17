require "rack-flash"

class ApplicationController < Sinatra::Base

	use Rack::Flash

	configure do
		set :public_folder, "public"
		set :views, "app/views"
		enable :sessions
		set :session_secret, "secret"
	end

	get '/' do
		erb :index
	end

	get "/register" do
		erb :register
	end
	
	post "/register" do
		if User.find_by(username: params[:username]) || User.find_by_slug(params[:username])
			flash[:notice] = "the username \"#{params[:username]}\" is unavailable"
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
		flash[:notice] = "invalid username and/or password"
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
