SELECTED= Gosu::Color.new 0xFFeb4034

class Chart < Gosu::Window
    
    def initialize
	    super SCREEN_W, SCREEN_H
	    self.caption = "Gym Tracker"
        @data=[]
        @date=[]
        sql
        @circle=Gosu::Image.new("./Asset/circle.png")
        @sum_chart= true
        @miles_chart=false
        @weight_chart=false
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
        REG_FONT.draw_text("Total miles: #{miles.sum} miles          Total weight: #{weight.sum}kg", 850, 80, ZOrder::UI, 1.2, 1.2, FONT_COLOR)
    end
    
    def draw_chart
      draw_line 300, SCREEN_H-100, OUTLINE_COLOR, SCREEN_W - 100, SCREEN_H-100, OUTLINE_COLOR, ZOrder::UI
      draw_line 300, 300, OUTLINE_COLOR, 300, SCREEN_H-100, OUTLINE_COLOR, ZOrder::UI
      #transforming the time to sum for later comparision
      i=0
      @data.size.times do 
        days = @data[i][3].split("-").map(&:to_i)
        @date.push(days)
        i+=1
      end

      #   everyday = merge_sort_sum(@date)
      #   i=0
      #   @data.each do |m|
      #   REG_FONT.draw_text("@data: #{@data} date:#{everyday} ", 340, 50+i, ZOrder::UI, 1.0, 1.0, FONT_COLOR)
      #   i+=1
      #   end
     
      line = @data.size - 1
      i=0
      dot_y = SCREEN_H - 105
      line_y  = SCREEN_H - 100

      5.times do |n|
        REG_FONT.draw_text "#{i}", 275, SCREEN_H - 100 - 150*n, ZOrder::UI, 0.6, 0.6, FONT_COLOR
        # REG_FONT.draw_text "#{m[2]}", 380+i*100, SCREEN_H - 80, ZOrder::UI, 0.6, 0.6, OUTLINE_COLOR
        i+=25
        end
        
        @multiplier = 20
        n=0
        i=0
          if @miles_chart ==  true
            line.times do 
              y1 = @data[n][1].to_i * @multiplier
              y3 = @data[n+1][1].to_i * @multiplier
  
              draw_quad 302+i, line_y  - y1, LIGHT_BLUE, 302+i, line_y  - y1 + 5, LIGHT_BLUE, 402+i, line_y  - y3, LIGHT_BLUE, 402+i, line_y  - y3 + 5, LIGHT_BLUE
              @circle.draw_rot(300+i,dot_y - y1,ZOrder::BACKGROUND,0,0,0,img_size(@circle.width,15), img_size(@circle.height,15), BLUE)
              @circle.draw_rot(400+i,dot_y - y3,ZOrder::BACKGROUND,0,0,0,img_size(@circle.width,15), img_size(@circle.height,15), BLUE)
              REG_FONT.draw_text "#{@date[n][2]}-#{@date[n][1]}-#{@date[n][0]}", 280+i, SCREEN_H - 80, ZOrder::UI, 0.6, 0.6, OUTLINE_COLOR
              REG_FONT.draw_text "#{@date[n+1][2]}-#{@date[n+1][1]}-#{@date[n+1][0]}", 380+i, SCREEN_H - 80, ZOrder::UI, 0.6, 0.6, OUTLINE_COLOR
              i+=100
              n+=1
              end

            
          elsif @weight_chart == true

            line.times do 
              y1 = @data[n][2].to_i * @multiplier
              y3 = @data[n+1][2].to_i * @multiplier

              draw_quad 302+i, line_y  - y1, LIGHT_BLUE, 302+i, line_y  - y1 + 5, LIGHT_BLUE, 402+i, line_y  - y3, LIGHT_BLUE, 402+i, line_y  - y3 + 5, LIGHT_BLUE
              @circle.draw_rot(300+i,dot_y - y1,ZOrder::BACKGROUND,0,0,0,img_size(@circle.width,15), img_size(@circle.height,15), BLUE)
              @circle.draw_rot(400+i,dot_y - y3,ZOrder::BACKGROUND,0,0,0,img_size(@circle.width,15), img_size(@circle.height,15), BLUE)
              REG_FONT.draw_text "#{@date[n][2]}-#{@date[n][1]}-#{@date[n][0]}", 280+i, SCREEN_H - 80, ZOrder::UI, 0.6, 0.6, OUTLINE_COLOR
              REG_FONT.draw_text "#{@date[n+1][2]}-#{@date[n+1][1]}-#{@date[n+1][0]}", 380+i, SCREEN_H - 80, ZOrder::UI, 0.6, 0.6, OUTLINE_COLOR
              i+=100
              n+=1
              end
      
          elsif @sum_chart == true
            line.times do 
              y1 = @data[n][1].to_i * @multiplier
              y1 = y1 + @data[n][2].to_i * @multiplier
              y3 = @data[n+1][1].to_i * @multiplier
              y3 = y3 + @data[n+1][2].to_i * @multiplier
    
              draw_quad 302+i, line_y  - y1, LIGHT_BLUE, 302+i, line_y  - y1 + 5, LIGHT_BLUE, 402+i, line_y  - y3, LIGHT_BLUE, 402+i, line_y  - y3 + 5, LIGHT_BLUE
              @circle.draw_rot(300+i,dot_y - y1,ZOrder::BACKGROUND,0,0,0,img_size(@circle.width,15), img_size(@circle.height,15), BLUE)
              @circle.draw_rot(400+i,dot_y - y3,ZOrder::BACKGROUND,0,0,0,img_size(@circle.width,15), img_size(@circle.height,15), BLUE)
              REG_FONT.draw_text "#{@date[n][2]}-#{@date[n][1]}-#{@date[n][0]}", 280+i, SCREEN_H - 80, ZOrder::UI, 0.6, 0.6, OUTLINE_COLOR
              REG_FONT.draw_text "#{@date[n+1][2]}-#{@date[n+1][1]}-#{@date[n+1][0]}", 380+i, SCREEN_H - 80, ZOrder::UI, 0.6, 0.6, OUTLINE_COLOR
              i+=100
              n+=1
              end

          end


    end
 

    def screen
        draw_total
        BOLD_FONT.draw_text("Your progress ", 340, 50, ZOrder::UI, 1.5, 1.5, FONT_COLOR)
        #chart buttons
        buttons=["Total","By miles", "By weight"]
        
        i=0
        buttons.each do |m|
          draw_rect 400,200 , 200, 50, SELECTED, ZOrder::PLAYER if @sum_chart == true
          draw_rect 650,200 , 200, 50, SELECTED, ZOrder::PLAYER if @miles_chart == true
          draw_rect 900,200 , 200, 50, SELECTED, ZOrder::PLAYER if @weight_chart == true
          draw_rect 400+i,200 , 200, 50, BLUE, ZOrder::BACKGROUND
          REG_FONT.draw_text "#{m}", 450+i, 205, ZOrder::UI, 1.0, 1.0, BOX_COLOR
          i+=250
        end
        # draw_rect 400,200 , 200, 50, Gosu::Color::RED, ZOrder::BACKGROUND if @sum_chart == true
        
    end
    
    def draw
        draw_rect(0, 0, SCREEN_W, SCREEN_H, MENU_COLOR, ZOrder::BACKGROUND, mode = :default)
        
        menu
        draw_chart
        screen
    end

    def area_clicked
      # i = 200
      if mouse_y > 200 && mouse_y < 250
        if  mouse_x > 400  && mouse_x< 600
          return 0
        elsif mouse_x > 650  && mouse_x<850
          return 1
        elsif mouse_x > 900  && mouse_x<1100
          return 2
        end
      end

        if mouse_x.between?(20,110)
          if mouse_y.between?(SCREEN_H-90,SCREEN_H-90+50)
            return 3
          elsif mouse_y.between?(45,90)
            return 4
          elsif mouse_y.between?(300,420)
            return 5
      
          end
        end
    end
    #draw_rect x=400+i,200 , width=200, 50, BLUE, ZOrder::BACKGROUND
    #i+=250
      

    def needs_cursor?; true; end
    
    def button_down(id)
      
          case id
      when Gosu::MsLeft
        case  area_clicked
        when 0
          @miles_chart = false
          @weight_chart = false

          @sum_chart = true
        when 1
          @sum_chart = false
          @weight_chart = false

          @miles_chart = true
        when 2
          @sum_chart = false
          @miles_chart = false

          @weight_chart = true
        when 3
          DataManager.delete_selection
          DataManager.delete_data
          close
          Users.new.show
        when 4
          close
          Home.new.show
        when 5
          close
          Rank.new.show

        end
      end
    end

          

end


# Chart.new.show