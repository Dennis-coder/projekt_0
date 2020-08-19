require 'sqlite3'
require 'bcrypt'
Dir.glob('models/*.rb') { |model| require_relative model }

class Seeder

    def self.seed!
        db = connect
        drop_tables(db)
        create_tables(db)
        populate_tables(db)
    end

    def self.connect
        SQLite3::Database.new "db/db.db"
    end

    def self.drop_tables(db)
        db.execute("DROP TABLE IF EXISTS users;")
        db.execute("DROP TABLE IF EXISTS students;")
    end

    def self.create_tables(db)
        db.execute <<-SQL
            CREATE TABLE "users" (
                "id" INTEGER PRIMARY KEY AUTOINCREMENT,
                "email" TEXT NOT NULL UNIQUE,
                "password_hash" TEXT NOT NULL,
                "name" INTEGER NOT NULL
            );
        SQL
        db.execute <<-SQL
            CREATE TABLE "students" (
                "id" INTEGER PRIMARY KEY AUTOINCREMENT,
                "name" TEXT NOT NULL,
                "image" BLOB NOT NULL,
                "user_id" INTEGER NOT NULL
            );
        SQL
    end

    def self.populate_tables(db)
        users = [
            {email: "1", password_hash: BCrypt::Password.create("1"), name: "Dennis"}
        ]

        users.each do |user|
            db.execute("INSERT INTO users (email, password_hash, name) VALUES(?,?,?)", user[:email], user[:password_hash], user[:name])
        end

        students = [
            {name: "Alexander", image: '/media/pfp2.jpg', user_id: 1},
            {name: "Henrik", image: '/media/pfp2.jpg', user_id: 1}
        ]

        students.each do |student|
            db.execute("INSERT INTO students (name, image, user_id) VALUES(?,?,?)", student[:name], student[:image], student[:user_id])
        end
    end

    Seeder.seed!
end