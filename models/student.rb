class Student

    attr_accessor :id, :name, :image, :group_id

    def initialize()
        @id = nil
        @name = nil
        @image = nil
        @group_id = nil
    end

    def add()
        SQLQuery.new.add('students', ['name', 'image', 'group_id'], [@name, @image, @group_id]).send
    end

    def self.get(id)
        student = Student.new()
        properties = SQLQuery.new.get('students', ['*']).where.if('id', id).send.first
        student.id = properties['id']
        student.name = properties['name']
        student.image = properties['image']
        student.group_id = properties['group_id']
        return student
    end

    def self.image(id)
        SQLQuery.new.get('students', ['image']).where.if('id', id).send.first['image']
    end

    def self.name(id)
        SQLQuery.new.get('students', ['name']).where.if('id', id).send.first['name']
    end

    def self.temp_id()
        SQLQuery.new.get('students', ['id']).where.if('image', 'temp').send.first['id']
    end

    def self.temp_image(image)
        SQLQuery.new.update('students', ['image'], [image]).where.if('image', 'temp').send
    end

    def self.delete(id)
        FileUtils.rm("public" + Student.image(id))
        SQLQuery.new.del('students').where.if('id', id).send
    end

end