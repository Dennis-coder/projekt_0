Dir.glob('models/*.rb') { |model| require_relative model }

class Application < Sinatra::Base
    
    enable :sessions

	before do 
		if session['user_id'] != nil
			begin
				@user = User.get(session['user_id'])
			rescue
				session.delete('user_id')
				redirect '/'
			end
		end
	end

	before '/home/?' do
		if session['user_id'] == nil
			redirect '/'
		end
	end

	before '/home/*' do
		if session['user_id'] == nil
			redirect '/'
		end
	end

	get '/?' do
		if session['user_id'] != nil
			redirect '/home'
		end
        slim :index
    end

	get '/login/?' do
        slim :login
    end

	post '/login' do
		login_cooldown = 3
		if session['last_login'] == nil || (Time.now - session['last_login']) >= login_cooldown
			result = Validator.login(params)
			session['last_login'] = Time.now
			if result.is_a? Integer
				session['user_id'] = result
				redirect '/home'
			else
				session['login_error'] = result
			end
		else
			session['login_error'] = "You have to wait #{login_cooldown - (Time.now - session['last_login']).ceil} second(s) before trying again"
		end
		redirect '/login'
	end

	get '/register/?' do
		slim :register
	end

	post '/register' do
		result = Validator.register(params)
		if result == true
			user = User.new()
			user.name = params['name']
			user.email = params['email']
			user.password_hash = BCrypt::Password.create(params['plaintext'])
			user.add()

			session['user_id'] = User.id(user.username)
			redirect '/home'
		else
			session['register_error'] = result
			redirect '/register'
		end
	end

	get '/logout/?' do
		session.delete('user_id')
		redirect '/'
	end

	get '/home/?' do
		slim :home
	end

	get '/home/quiz/?' do
		slim :quiz, locals: {students: @user.students}
	end

end