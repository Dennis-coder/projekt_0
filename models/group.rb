class Group

    attr_accessor :id, :user_id, :name

    def initialize()
        @id = nil
        @user_id = nil
        @name = nil
    end

    def add()
        SQLQuery.new.add('groups', ['user_id', 'name'], [@user_id, @name]).send
    end

    def students()
        ids = SQLQuery.new.get('students', ['id']).where.if('group_id', self.id).send
        students = []
        ids.each do |id| 
            students << Student.get(id['id'])
        end
        return students
    end

    def self.get(id)
        group = Group.new()
        properties = SQLQuery.new.get('groups', ['*']).where.if('id', id).send.first
        group.id = properties['id']
        group.user_id = properties['user_id']
        group.name = properties['name']
        return group
    end

    def self.id(user_id, name)
        SQLQuery.new.get('groups' ['id']).where.if('user_id', user_id).and.if('name', name).send.first['id']
    end

    def self.name(id)
        SQLQuery.new.get('groups', ['name']).where.if('id', id).send.first['name']
    end

    def self.delete(id)
        SQLQuery.new.del('groups').where.if('id', id).send
        SQLQuery.new.del('students').where.if('group_id', id).send
    end

end