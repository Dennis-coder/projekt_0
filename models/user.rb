# The class that handles all user functions.
class User

    attr_accessor :id, :email, :password_hash, :name
    
    def initialize()
        @id = nil
        @email = nil
        @password_hash = nil
        @name = nil
    end
    
    # Adds a user.
    def add()
        SQLQuery.new.add('users', ['email', 'password_hash', 'name'], [@email, @password_hash, @name]).send
    end

    # Gets a user.
    # 
    # id - The id of the user we want.
    # User - The class that handles all user functions.
    # 
    # Returns the user.
    def self.get(id)
        user = User.new()
        properties = SQLQuery.new.get('users', ['*']).where.if('id', id).send.first
        user.id = properties['id']
        user.email = properties['email']
        user.password_hash = properties['password_hash']
        user.name = properties['name']

        return user
    end

    # Gets the id from the username.
    # 
    # username - The user username.
    # 
    # Returns the id.
    def self.id(username)
        SQLQuery.new.get('users', ['id']).where.if('username', username).send.first['id']
    end

    # Changes password.
    # 
    # id - The id of the user.
    # password - The new password.
    def self.change_password(id, password)
        SQLQuery.new.update('users', ['password_hash'], [BCrypt::Password.create(password)]).where.if('id', id).send
    end

    # Deletes a user.
    # 
    # id - The id of the user to be deleted.
    def self.delete(id)
        SQLQuery.new.del('students').where.if('user_id', id).send
        SQLQuery.new.del('users').where.if('id', id).send
    end
    
end