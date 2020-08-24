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

			session['user_id'] = User.id(user.email)
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

	get '/home/practice/?' do
		slim :practice, locals: {groups: @user.groups}
	end

	get '/home/groups/?' do
		slim :groups, locals: {groups: @user.groups}
	end

	post '/home/groups' do
		group = Group.new
		group.name = params['name']
		group.user_id = @user.id
		group.add
		redirect "/home/groups"
	end

	get '/home/group/:group_id' do
		slim :group, locals: {group: Group.get(params['group_id'])}
	end

	post '/home/group/:group_id' do
		student = Student.new
		student.name = params['name']
		student.image = params['name']
		student.group_id = params['group_id']
		student.add
		redirect "/home/group/#{params['group_id']}"
	end

	get '/api/startquiz/:group_id' do
		student_ids = []
		students = Group.get(params['group_id']).students
		students.each do |student|
			student_ids << student.id
		end
		quiz = {'correct' => 0, 'amount' => students.length, 'student_ids' => student_ids}
		return quiz.to_json
	end

	get '/api/madeguess/:id/:answer' do
		session['quiz']['student_ids'].delete(params['id'])
		session['quiz']['correct'] += 1
		return session['quiz']
	end

	get '/api/getstudentimage/:id' do
		Student.image(params['id']).to_json
	end

	get '/api/getstudentname/:id' do
		Student.name(params['id']).to_json
	end

	get '/api/getgroupname/:id' do
		Group.name(params['id']).to_json
	end

	get '/api/deletegroup/:group_id' do
		Group.delete(params['group_id'])
	end

	get '/api/removestudent/:student_id' do
		Student.delete(params['student_id'])
	end

end