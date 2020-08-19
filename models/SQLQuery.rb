class SQLQuery

    def initialize
        @query = ''
        @values = []
    end

    def db
        return @db if @db
        @db = SQLite3::Database.new 'db/db.db'
        @db.results_as_hash = true
        return @db
    end

    def add(table, columns, values)
        @query += "INSERT INTO #{table} ("
        columns.each do |column|
            @query += "#{column},"
        end
        @query[@query.length-1] = ''
        @query += ') VALUES(' + '?,' * columns.length
        @query[@query.length-1] = ''
        @query += ') '
        values.each do |values|
            @values << values
        end
        return self
    end

    def get(table, columns)
        @query += "SELECT "
        columns.each do |column|
            @query += column + ','
        end
        @query[@query.length-1] = ''
        @query += " FROM #{table} "
        return self
    end

    def del(table)
        @query += "DELETE FROM #{table} "
        return self
    end

    def update(table, columns, values)
        @query += "UPDATE #{table} SET"
        columns.each do |column|
            @query += " #{column} = ?,"
        end
        @query[@query.length-1] = ' '
        values.each do |values|
            @values << values
        end
        return self
    end

    def open_
        @query += '( '
        return self
    end

    def close_
        @query += ') '
        return self
    end

    def where
        @query += 'WHERE '
        return self
    end

    def if(column, value)
        @query += "#{column} = ? "
        @values << value
        return self
    end

    def and
        @query += 'AND '
        return self
    end

    def or
        @query += 'OR '
        return self
    end

    def not
        @query += 'NOT '
        return self
    end

    def order(column)
        @query += "ORDER BY #{column} "
        return self
    end

    def join(table)
        @query += "CROSS JOIN #{table} "
        return self
    end

    def union
        @query += 'UNION '
        return self
    end   

    def send
        db.execute(@query, @values)
    end

end