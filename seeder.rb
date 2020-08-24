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
        db.execute("DROP TABLE IF EXISTS groups;")
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
            CREATE TABLE "groups" (
                "id" INTEGER PRIMARY KEY AUTOINCREMENT,
                "name" TEXT NOT NULL,
                "user_id" INTEGER NOT NULL
            );
        SQL
        db.execute <<-SQL
            CREATE TABLE "students" (
                "id" INTEGER PRIMARY KEY AUTOINCREMENT,
                "name" TEXT NOT NULL,
                "image" BLOB NOT NULL,
                "group_id" INTEGER NOT NULL
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

        groups = [
            {name: "Grillkorv", user_id: 1},
            {name: "Bananpaj", user_id: 1}
        ]

        groups.each do |group|
            db.execute("INSERT INTO groups (name, user_id) VALUES(?,?)", group[:name], group[:user_id])
        end

        students = [
            {name: "Adrian", image: '/media/Adrian_Almetun_Smeds.jpg', group_id: 1},
            {name: "Alexander", image: '/media/Alexander_Kjellberg.jpeg', group_id: 1},
            {name: "Alexander", image: '/media/Alexander_Kjellberg1.jpeg', group_id: 1},
            {name: "Alexander", image: '/media/Alexander_Nylund_Gomes.jpeg', group_id: 1},
            {name: "Andre", image: '/media/Andre_Skvarc.jpeg', group_id: 1},
            {name: "David", image: '/media/David_Jensen.jpeg', group_id: 1},
            {name: "David", image: '/media/David_Sundqvist.jpeg', group_id: 1},
            {name: "Dennis", image: '/media/Dennis_Christensen.jpeg', group_id: 1},
            {name: "Filip", image: '/media/Filip_Liljenberg.jpeg', group_id: 1},
            {name: "Henrik", image: '/media/Henrik_Stahl.jpeg', group_id: 1},
            {name: "Rasmus", image: '/media/Rasmus_Brednert.jpg', group_id: 1},
            {name: "Sebastian", image: '/media/Sebastian_Utbult.jpg', group_id: 1},
            {name: "Hej", image: '/media/pfp.jpg', group_id: 2}
        ]

        students.each do |student|
            db.execute("INSERT INTO students (name, image, group_id) VALUES(?,?,?)", student[:name], student[:image], student[:group_id])
        end
    end

    Seeder.seed!
end