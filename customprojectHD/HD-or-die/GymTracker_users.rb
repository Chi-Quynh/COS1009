require 'rubygems'
require 'gosu'
require './gym_functions.rb'
require 'sqlite3'
require './GymTracker_chart.rb'
require './GymTracker_rank.rb'

#permanent menu
RECT=Gosu::Image.new("./Asset/Rectangle.png")
        
HOME= Gosu::Image.new("./Asset/home.png")
TROPHY= Gosu::Image.new("./Asset/trophy.png")
GROWTHCHART= Gosu::Image.new("./Asset/growth-chart.png")
USER=Gosu::Image.new("./Asset/user.png")
LOGOUT =Gosu::Image.new("./Asset/logout.png")

MENU= [HOME,GROWTHCHART,TROPHY]

def img_size(image_size, new_size)
  decrease = new_size.fdiv(image_size)
  return decrease
end

def menu
  i = 0
  MENU.each do |m|
  RECT.draw_rot(30,20+i,10,0,0,0,img_size(m.width,80), img_size(m.height,120), LIGHT_BLUE)
  m.draw_rot(60,45+i,10,0,0,0,img_size(m.width,50), img_size(m.height,50), Gosu::Color::WHITE)
  i+=140
  end
  LOGOUT.draw_rot(50,SCREEN_H-90,10,0,0,0,img_size(LOGOUT.width,50), img_size(LOGOUT.height,50), Gosu::Color::WHITE)
end
#end

BACKGROUND_COLOR = Gosu::Color.new 0xFFBED8E4
MENU_COLOR = Gosu::Color::WHITE
FONT_COLOR = Gosu::Color.new 0xFF023047
SCREEN_W =  1920 
SCREEN_H = 1000
OUTLINE_COLOR = Gosu::Color.new 0xFFB9B9B9
BOX_COLOR = Gosu::Color::WHITE
LIGHT_BLUE=Gosu::Color.new 0xFFCFDAE6
BLUE = Gosu::Color.new 0xFF75B8E6

# $data = Array.new


BOX_X= 360
BOX_Y= 200
PADDING = 5

#font order
BOLD_FONT = Gosu::Font.new(50, name: "./Asset/segoe-ui-4-cufonfonts/Segoe UI Bold.ttf")
REG_FONT = Gosu::Font.new(30, name: "./Asset/segoe-ui-4-cufonfonts/Segoe UI.ttf")
SMALL_FONT = Gosu::Font.new(25, name: "./Asset/segoe-ui-4-cufonfonts/Segoe UI.ttf")


module ZOrder
    BACKGROUND, PLAYER, UI = *0..2
end

def sql
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
    @db.execute("SELECT data_id, miles, weight, time, users_id FROM gym_data WHERE users_id = ?", DataManager.get_selection) do |row|
      @data << row
    end

    # @users_data=Array.new(3){[]}

    # @users_data.each_with_index do |m, index|
    #     query = <<-SQL
    #   SELECT *
    #   FROM gym_data
    #   INNER JOIN gym_users ON gym_data.users_id = gym_users.users_id
    #   WHERE gym_data.users_id = #{index+1} ;
    # SQL
    
    #         @db.execute(query) do |row|
    #             @users_data[index] << row
    #         end
    #   end
  rescue SQLite3::Exception => e
    puts e
    # Handle the exception gracefully
  ensure
    # If the whole application is going to exit and you don't
    # need the database at all any more, ensure db is closed.
    # Otherwise database closing might be handled elsewhere.
    #   @db.close if @db
  end
end
  



LOGO = Gosu::Image.new("./Asset/Gym Tracker.png")
LIGHT_GRAY = Gosu::Color.new 0xFFe6e6e6


class Users < Gosu::Window
    
    def initialize
	    super SCREEN_W, SCREEN_H
	    self.caption = "Gym Tracker"
        @users=[]
        @data=[]
        sql
        @db.execute("SELECT users_name FROM gym_users ORDER BY users_id ASC LIMIT 3") do |row|
            @users << row
        end
        
    end

    def screen
        i=0
        LOGO.draw_rot SCREEN_H/2 ,50,ZOrder::BACKGROUND,0,0,0,1.0, 1.0, Gosu::Color::WHITE
        
        @users.flatten.each do |name|
            REG_FONT.draw_text "#{name}", 455+i, 580, ZOrder::UI, 1.0, 1.0, FONT_COLOR
            draw_rect 350+i, 350, 300, 300,LIGHT_GRAY, ZOrder::BACKGROUND, mode = :default
            USER.draw_rot 430+i,400,ZOrder::BACKGROUND,0,0,0,img_size(USER.width,150), img_size(USER.height,150), Gosu::Color::WHITE
            i+=350
        end
    end

    # def draw_rankings

    
    def draw
        draw_rect(0, 0, SCREEN_W, SCREEN_H, MENU_COLOR, ZOrder::BACKGROUND, mode = :default)
        screen
    end

    def area_clicked
        if mouse_y.between?(350,650)
            if mouse_x.between?(350,650) 
                return 1
            elsif mouse_x.between?(700,1000) 
                return 2
            elsif mouse_x.between?(1050,1350)
                return 3
            end
        end
    end

    def needs_cursor?; true; end
    
	def button_down(id)
    
        case id
		when Gosu::MsLeft
            case area_clicked
                when 1
                    # $select = 1
                    DataManager.add_selection(1)
                    require './GymTracker.rb'
                    close
                    Home.new.show if __FILE__ == $0
                when 2
                    # $select = 2
                    DataManager.add_selection(2)
                    require './GymTracker.rb'
                    close
                    Home.new.show
                when 3
                    # $select = 3
                    DataManager.add_selection(3)
                    require './GymTracker.rb'
                    close
                    Home.new.show

            end
        end
    end
    
end


Users.new.show