# The class that handles all validation
class Validator

    # Validation of login information.
    # 
    # params - The login information.
    # username - The username written.
    # plaintext - The password written.
    # user_id - The id of the user with that username.
    # user - The user with that username.
    # 
    # Examples
    # 
    #   Validator.login({'username' => 'Tester1', 'plaintext' => '1'})
    #   # => true
    # 
    #   Validator.login({'username' => 'Tester1', 'plaintext' => '2'})
    #   # => 'Wrong username or password'
    # 
    # Returns true or an error message.
    def self.login(params)
        username = params['username']
        plaintext = params['plaintext']
        begin
            user_id = User.id(username)
		rescue
            return "Wrong username or password"
        end
        user = User.get(user_id)
        if BCrypt::Password.new(user.password_hash) == plaintext
			return user_id
		else
			return "Wrong username or password"
		end
    end

    # Validation of registration information.
    # 
    # params - The registration information.
    # username - The username written.
    # plaintext - The password written.
    # plaintext_confirm - The password confirmation written.
    # allowed_chars - The characters allowed in username and password.
    # user_id - The id of the user with that username.
    # 
    # Examples
    # 
    #   Validator.register({'username' => 'Dennis', 'plaintext' => 'Dennis', 'plaintext_confirm' => 'Dennis'})
    #   # => true
    # 
    #   Validator.register({'username' => 'Dennis', 'plaintext' => 'Dennis', 'plaintext_confirm' => 'Dennis1'})
    #   # => 'Passwords are not the same'
    # 
    # Returns true or an error message.
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

    # Validates texts.
    # 
    # text - The text to be validated.
    # 
    # Examples
    # 
    #   Validator.message('Hej')
    #   # => true
    # 
    #   Validator.message('  ')
    #   # => false
    # 
    # Returns true or false.
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

    # Validates information for a password change.
    # 
    # password_hash - The current password hash.
    # params - The password change information.
    # 
    # Returns true or an error message.
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

    # Validates the information for a report.
    # 
    # user - Your own user.
    # params - Includes the report information
    # Validator - The class that handles all validation.
    # 
    # Returnstrue or an error message.
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