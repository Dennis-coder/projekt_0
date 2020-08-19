Dir.glob('models/*.rb') { |model| require_relative model }

class Application < Sinatra::Base
    
    enable :sessions

    # Checks the connection to the database and gets a user
    #
	# DBTest  - The class for the test.
	# session['db_error'] - True or False depending on if there is an error with the connection to the database
	# session['user_id'] - Your user id if you are logged in.
	# @user - Your own user.
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

	# Checks if you are logged in.
    #
    # session['user_id'] - Your user id if you are logged in.
	before '/home/?' do
		if session['user_id'] == nil
			redirect '/'
		end
	end

	# Checks if you are logged in.
    #
    # session['user_id'] - Your user id if you are logged in.
	before '/home/*' do
		if session['user_id'] == nil
			redirect '/'
		end
	end

	# Checks if you are already logged in
    #
    # session['user_id'] - Your user id if you are logged in.
	get '/?' do
		if session['user_id'] != nil
			redirect '/home'
		end
        slim :index
    end

	# The login page.
	get '/login/?' do
        slim :login
    end

	# Validates you login information and logs you in if they are correct.
    #
	# login_cooldown - The time you have to wait between login attempts in seconds.
	# session['last_login'] - Stores the time of your last login attempt.
	# result - Gets either an error or the user id from the validator.
	# Validator - The class that controls the validation of the user's inputs.
	# params - the login information
	# session['login_error'] - An error message that is displayed on the login page.
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

	# The register page.
	get '/register/?' do
		slim :register
	end

	# Validates the register information.
    #
	# result - Gets either an error or True from the validation.
	# params - the register information.
	# user - the new user to be registered.
	# session['user_id'] - Your user id.
	# session['register_error'] - An error message that is displayed on the register page.
	post '/register' do
		result = Validator.register(params)
		if result == true
			user = User.new()
			user.username = params['username']
			user.password_hash = BCrypt::Password.create(params['plaintext'])
			user.add()

			session['user_id'] = User.id(user.username)
			redirect '/home'
		else
			session['register_error'] = result
			redirect '/register'
		end
	end

	# Logs you out from the website.
	# 
	# session['user_id'] - Your user id.
	get '/logout/?' do
		session.delete('user_id')
		redirect '/'
	end

	# The home page.
	# 
	# @user - Your own user.
	get '/home/?' do
		slim :home, locals: {friends: @user.friendslist, groups: @user.groups}
	end
	
	# The conversation with a friend.
	# 
	# Friend - The class that handles friends.
	# @user - Your own user.
	# params['username'] - The username of the friend.
	get '/home/friends/:username/?' do
		slim :conversation, locals: {friend: Friend.get(@user.id, User.id(params['username']))}
	end

	# Gets the user id for a user.
	# 
	# User - The class that handles all user functions.
	# params['username'] - The username of the user whose id we want.
	# 
	# Returns the id.
	get '/api/get/id/:username' do
		return User.id(params['username']).to_json
	end

	# Deletes a user.
	# 
	# params - Includes the user id of the account getting deleted.
	# @user - Your own user.
	# session['user_id'] - The user id of the account logged in.
	# User - The class that handles all user functions.
	get '/api/admin/delete_user/:id' do
		if params['id'].to_i == @user.id
			session.delete('user_id')
		end
		User.delete(params['id'])
	end

end