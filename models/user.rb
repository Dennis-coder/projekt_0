class User

    attr_accessor :id, :email, :password_hash, :name, :students
    
    def initialize()
        @id = nil
        @email = nil
        @password_hash = nil
        @name = nil
        @students = nil
    end
    
    def add()
        SQLQuery.new.add('users', ['email', 'password_hash', 'name'], [@email, @password_hash, @name]).send
    end

    def groups()
        ids = SQLQuery.new.get('groups', ['id']).where.if('user_id', self.id).send
        groups = []
        ids.each do |id| 
            groups << Group.get(id['id'])
        end
        return groups
    end

    def self.get(id)
        user = User.new()
        properties = SQLQuery.new.get('users', ['*']).where.if('id', id).send.first
        user.id = properties['id']
        user.email = properties['email']
        user.password_hash = properties['password_hash']
        user.name = properties['name']

        return user
    end

    def self.id(email)
        SQLQuery.new.get('users', ['id']).where.if('email', email).send.first['id']
    end

    def self.change_password(id, password)
        SQLQuery.new.update('users', ['password_hash'], [BCrypt::Password.create(password)]).where.if('id', id).send
    end

    def self.delete(id)
        SQLQuery.new.del('students').where.if('user_id', id).send
        SQLQuery.new.del('users').where.if('id', id).send
    end
    
end