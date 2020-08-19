# The class that handles all database requests.
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

    # Adds the insert operation to the request.
    # 
    # table - Which table to insert into.
    # columns - The columns to insert into.
    # values - The values to insert.
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

    # Adds the select operation to the request.
    # 
    # table - The table from which we want the data.
    # columns - The columns we want data from.
    def get(table, columns)
        @query += "SELECT "
        columns.each do |column|
            @query += column + ','
        end
        @query[@query.length-1] = ''
        @query += " FROM #{table} "
        return self
    end

    # Adds the delete operation to the request.
    # 
    # table - The table to delete from.
    def del(table)
        @query += "DELETE FROM #{table} "
        return self
    end

    # Adds the update operation to the request.
    # 
    # table - Which table to update.
    # columns - The columns to update.
    # values - The values to replace with.
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

    # Adds a open bracket to the request.
    def open_
        @query += '( '
        return self
    end

    # Adds close bracket to the request.
    def close_
        @query += ') '
        return self
    end

    # Adds where to the request.
    def where
        @query += 'WHERE '
        return self
    end

    # Adds a condition to the request.
    # 
    # column - The column in question.
    # value - The value to be matched with the column.
    def if(column, value)
        @query += "#{column} = ? "
        @values << value
        return self
    end

    # Adds an and to the request.
    def and
        @query += 'AND '
        return self
    end

    # Adds an or to the request.
    def or
        @query += 'OR '
        return self
    end

    # Adds a not to the request.
    def not
        @query += 'NOT '
        return self
    end

    # Adds an order by to the request.
    # 
    # column - The column to order by.
    def order(column)
        @query += "ORDER BY #{column} "
        return self
    end

    # Adds a cross join to the request.
    # 
    # table - The table to join.
    def join(table)
        @query += "CROSS JOIN #{table} "
        return self
    end

    # Adds a union to the request.
    def union
        @query += 'UNION '
        return self
    end   

    # Sends the requests.
    # 
    # Returns the result of the request.
    def send
        db.execute(@query, @values)
    end

end