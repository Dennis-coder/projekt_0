require 'sqlite3'
require 'bcrypt'
Dir.glob('models/*.rb') { |model| require_relative model }

# Resets the database and adds some data.
class Seeder

    # Calls the different functions to reset the database.
    #
    # db  - The database.
    def self.seed!
        db = connect
        drop_tables(db)
        create_tables(db)
        populate_tables(db)
    end

    # Connects to the database.
    # 
    # Returns the database.
    def self.connect
        SQLite3::Database.new "db/db.db"
    end

    # Deletes the tables.
    #
    # db  - The database.
    def self.drop_tables(db)
        db.execute("DROP TABLE IF EXISTS users;")
        db.execute("DROP TABLE IF EXISTS students;")
    end

    # Creates the tables.
    #
    # db  - The database.
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

    # Adds data to some of the database tables
    #
    # db  - The database.
    def self.populate_tables(db)
        users = [
            {email: "hej@gmail.com", password_hash: BCrypt::Password.create("1"), name: "Dennis"}
        ]

        users.each do |user|
            db.execute("INSERT INTO users (email, password_hash, name) VALUES(?,?,?)", user[:email], user[:password_hash], user[:name])
        end

        students = [
            {name: "Alexander", image: , user_id: 1},
            {name: "Henrik", image: , user_id: 1}
        ]

        students.each do |student|
            db.execute("INSERT INTO messages (name, image, user_id) VALUES(?,?,?)", student[:name], student[:image], student[:user_id])
        end
    end

    Seeder.seed!
end