class Validator

    def self.login(params)
        email = params['email']
        plaintext = params['plaintext']
        begin
            user_id = User.id(email)
		rescue
            return "Wrong email or password"
        end
        user = User.get(user_id)
        if BCrypt::Password.new(user.password_hash) == plaintext
			return user_id
		else
			return "Wrong email or password"
		end
    end

    def self.register(params)
        username = params['username']
        plaintext = params['plaintext']
        plaintext_confirm = params['plaintext_confirm']
        allowed_chars = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0"]
        username.downcase.each_char do |char|
            if allowed_chars.index(char) == nil
                return "No special characters, only a-z and 0-9 are allowed"
            end
        end
        plaintext.downcase.each_char do |char|
            if allowed_chars.index(char) == nil
                return "No special characters, only a-z and 0-9 are allowed"
            end
        end
        begin
            user_id = User.id(username)
        rescue
            if username.length < 1 || username.length > 16
                return "Username has to be between 1-16 characters"
            elsif plaintext.length < 5
                return "Password has to be 5 characters or more"
            elsif plaintext != plaintext_confirm
                return "Passwords are not the same"
            else
                return true
            end
        end
        return "A user with that name already exists"
    end

    def self.message(text)
        if text == nil
            return false
        else
            text.each_char do |char|
                if char != " "
                    return true
                end
            end

            return false
        end
    end
    def self.change_password(password_hash, params)
        if BCrypt::Password.new(password_hash) == params['current_password']
            if params['new_password'] != params['confirm_password']
                return 'The new passwords do not match'
            elsif params['current_password'] == params['new_password']
                return 'The new password cannot be the same as your current one'
            else
                return true
            end
        else
            return 'Wrong password'
        end
    end

    def self.report(user, params)
        if Validator.message(params['username']) == false || Validator.message(params['reason']) == false
            return "Please fill out every box"
        else
            if User.id(params['username']) == nil 
                return "That username does not exist"
            elsif params['username'] == user.username
                return "You cannot report yourself"
            end
        end
        return true
    end

end