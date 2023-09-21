require 'sqlite3'
@data_profile = Array.new(3){[]}
begin
    @db = SQLite3::Database.new "data_and_users.db"

    # Create gym_users table
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS gym_users (
        users_id INTEGER PRIMARY KEY,
        users_name TEXT NOT NULL
      );
    SQL

    # Insert data into gym_users table
    @db.execute <<-SQL
      INSERT INTO gym_users (users_name)
      VALUES
        ('Dang Chi'),
        ('Mackenyu'),
        ('Sylvain');
    SQL

    # Create gym_data table (parent table)
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS gym_data (
        data_id INTEGER PRIMARY KEY,
        miles INTEGER NOT NULL,
        weight INTEGER NOT NULL,
        time INTEGER NOT NULL,
        users_id INTEGER NOT NULL,
        FOREIGN KEY (users_id) REFERENCES gym_users (users_id)
      );
    SQL


    # Fetch data from gym_data table for a specific user (using $select variable)
    # @db.execute("SELECT data_id, miles, weight, time, users_id FROM gym_data WHERE users_id = ?", DataManager.get_selection) do |row|
    #   @data << row
    # end

    @users_data=Array.new(3){[]}

@users_data.each_with_index do |m, index|
    query = <<-SQL
  SELECT *
  FROM gym_data
  INNER JOIN gym_users ON gym_data.users_id = gym_users.users_id
  WHERE gym_data.users_id = #{index+1} ;
SQL

        @db.execute(query) do |row|
            @users_data[index] << row
        end
  end
  rescue SQLite3::Exception => e
    puts e
    # Handle the exception gracefully
  ensure
    # If the whole application is going to exit and you don't
    # need the database at all any more, ensure db is closed.
    # Otherwise database closing might be handled elsewhere.
    #   @db.close if @db
  
end

puts "#{@users_data}"
@users_data.each do |m|

miles = []
weight = []
name =[]
  m.each do |n|
    next if !n.is_a?(Array) # Skip non-array elements
    miles << n[1]
    weight << n[2]
    name << n[6]
  end
  m.replace([nil, miles.sum, weight.sum,name[0] ])
end
puts "#{@users_data}"


# # Ruby program to illustrate 'for'
# # loop using range as expression

# i = "Sudo Placements"

# # using for loop with the range
# for a in 1..5 do
	
# puts a

# end
# puts a