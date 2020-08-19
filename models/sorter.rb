# The class that handles all sorting functions.
class Sorter

    # Compares two timestamps.
    # 
    # time1 - The first timestamp.
    # Time2 - The second timestamp.
    # 
    # Examples
    # 
    #  Sorter.timestamp_compare('2020-05-02 20:30:17 +0200', '2020-05-01 20:30:17 +0200')
    #   # => true
    # 
    #  Sorter.timestamp_compare('2020-05-01 20:30:17 +0200', '2020-05-02 20:30:17 +0200')
    #   # => false
    # 
    # Returns true or false.
    def self.timestamp_compare(time1, time2)
        time1.each_char.with_index do |time, index|
            if time > time2[index]
                return true
            elsif time < time2[index]
                return false
            end
        end
        return true
    end

    # Sorts a list by the timestamp from latest to oldest.
    # 
    # list - The list to be sorted.
    # temp - Duplicate of list.
    # out - The list to be returned.
    # latest_index - The index of the latest timestamp.
    # 
    # Returns the sorted list.
    def self.last_interaction(list)
        temp = list.dup
        out = Array.new(list.length) {nil}
        out.each_with_index do |_, index|
            latest_index = 0
            temp.each_with_index do |item, index2|
                if Sorter.timestamp_compare(item.last_interaction, temp[latest_index].last_interaction) == true
                    latest_index = index2
                end
            end
            out[index] = temp[latest_index].dup
            temp.delete_at(latest_index)
        end
        return out
    end

    # Sorts a list of users alphabetically.
    # 
    # list - The list of users to be sorted.
    # temp - Duplicate of list.
    # out - The list to be returned.
    # 
    # Returns the sorted list.
    def self.alphabetical(list)
        temp = list.dup
        out = Array.new(list.length) {nil}
        out.each_with_index do |_, pos|
            i = 0
            temp.each_with_index do |user, index|
                temp_list = [user.username.downcase, temp[i].username.downcase]
                if temp_list.sort[0] = user.username.downcase
                    i = index
                end
            end
            out[pos] = temp[i]
            temp.delete_at(i)
        end
        return out.reverse
    end

end