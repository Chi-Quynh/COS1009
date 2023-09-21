class Rank < Gosu::Window
    
    def initialize
	    super SCREEN_W, SCREEN_H
	    self.caption = "Gym Tracker"
        @data = []
        @users = []
        sql
        @db.execute("SELECT users_name FROM gym_users ORDER BY users_id ASC LIMIT 3") do |row|
            @users << row
        end

        @users_data=Array.new(@users.size){[]}

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
    
    end
        
#each do |m| but
#m did not work because it was a local variable, it did not save
    def users_ranked
        n=0
        @your_rank= DataManager.get_selection

        @wow = @users_data.clone
        @wow.each do 
          next if @wow[n].empty? # Skip empty arrays
      
          total_miles = 0
          total_weight = 0
          user_name = nil
          user_id = nil
            
          @wow[n].each do |data|
            next if !data.is_a?(Array) # Skip non-array elements
            user_id ||= data[5].to_i
            total_miles += data[1].to_i
            total_weight += data[2].to_i
            user_name ||= data[6].to_s

          end


          @wow[n]=[]
          @wow[n].push(user_id,total_miles,total_weight,user_name)  
          n +=1
        end

        @leader_board=merge_sort_2d(@wow).reverse
        @leader_board.each_with_index  do |m, index|
        Gosu.draw_rect 300 , 300+140*index, SCREEN_W-600, 100, LIGHT_BLUE, ZOrder::BACKGROUND
        SMALL_FONT.draw_text("#{index+1} "+" "*30+"#{m[3]}"+" "*20+"Miles: #{m[1]}m"+" "*20+"Weight#{m[2]}kg", 350, 330+140*index, ZOrder::UI, 1.5, 1.5, FONT_COLOR)

        end 



        # SMALL_FONT.draw_text("#{@users_data} ", 350, 450, ZOrder::UI, 1.5, 1.5, FONT_COLOR)
    end
      
    def draw_total        
        miles =[]
        weight=[]
        
        i=0
        time = @data.size
        time.times do 
          miles << @data[i][1].clone.to_i
          weight<< @data[i][2].clone.to_i
          
          i+=1
        end

        # REG_FONT.draw_text("#{@data}", 850, 80, ZOrder::UI, 1.2, 1.2, FONT_COLOR)
        REG_FONT.draw_text("Total miles: #{miles.sum} miles          Total weight: #{weight.sum}kg", 750, 200, ZOrder::UI, 1.2, 1.2, FONT_COLOR)
    end

    def screen
        USER.draw_rot(300,50,10,0,0,0,img_size(USER.width,200), img_size(USER.height,200), Gosu::Color::WHITE)
        # BOLD_FONT.draw_text("Your rank: ", 550, 100, ZOrder::UI, 1.5, 1.5, FONT_COLOR)
        # BOLD_FONT.draw_text("#{@users_data}", 300, 400, ZOrder::UI, 1.5, 1.5, FONT_COLOR)

    end

    # def draw_rankings

    
    def draw
        draw_rect(0, 0, SCREEN_W, SCREEN_H, MENU_COLOR, ZOrder::BACKGROUND, mode = :default)
        menu
        screen
        draw_total
        users_ranked


    end

    def area_clicked
        if mouse_x > 20 && mouse_x < 110
            if mouse_y.between?(20,140)
                return 1
            elsif mouse_y > 160 && mouse_y < 280
              return 2
            elsif mouse_y.between?(SCREEN_H-90,SCREEN_H-90+50)
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
                close
                Home.new.show
            when 2
                close
                Chart.new.show
            when 3
                DataManager.delete_selection
                DataManager.delete_data
                close
                Users.new.show
            end
        end
    end

end
