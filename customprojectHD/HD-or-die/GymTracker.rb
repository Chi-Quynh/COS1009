

# 
class TextField < Gosu::TextInput
  FONT = Gosu::Font.new(20)
  WIDTH = 200
  LENGTH_LIMIT = 20
  CARET_COLOR     = Gosu::Color::BLACK
  attr_reader :x, :y

  def initialize(window, x, y)
    # It's important to call the inherited constructor.
    super()

    @window, @x, @y = window, x, y

    # Start with a self-explanatory text in each field.
    
  
  end

  # In this example, we use the filter method to prevent the user from entering a text that exceeds
  # the length limit. However, you can also use this to blacklist certain characters, etc.
  def filter new_text
    # allowed_length = [LENGTH_LIMIT - text.length, 0].max
    new_text.gsub(/[^0-9]/, '')
    
  end


  def draw(z)
    Gosu.draw_rect x - PADDING, y - PADDING, 104, 34,OUTLINE_COLOR, z
    Gosu.draw_rect x - PADDING + 2, y- PADDING + 2, 100, 30,BOX_COLOR, z
    # Gosu.draw_rect x, y, 200, 30, BACKGROUND_COLOR, ZOrder::BACKGROUND
    # Calculate the position of the caret and the selection start.
    pos_x = x + FONT.text_width(self.text[0...self.caret_pos])
    sel_x = x + FONT.text_width(self.text[0...self.selection_start])
    sel_w = pos_x - sel_x
    # Draw the caret if this is the currently selected field.
    if @window.text_input == self
      Gosu.draw_line pos_x, y, CARET_COLOR, pos_x, y + height, CARET_COLOR, z
    end
    # Finally, draw the text itself!
    
    FONT.draw_text filter(self.text), x, y, z, scale_x = 1, scale_y = 1, CARET_COLOR, mode = :default 
  end

  def height
    FONT.height
  end

  def save_to_data
    data = self.text.chomp.to_i.clone
    DataManager.add_to_data(data)
    self.text = ''
  end

  # Hit-test for selecting a text field with the mouse.
  def under_mouse?
    @window.mouse_x > x - PADDING and @window.mouse_x < x + WIDTH + PADDING and
      @window.mouse_y > y - PADDING and @window.mouse_y < y + height + PADDING
  end

  # Tries to move the caret to the position specifies by mouse_x
  def move_caret_to_mouse
    # Test character by character
    1.upto(self.text.length) do |i|
      if @window.mouse_x < x + FONT.text_width(text[0...i])
        self.caret_pos = self.selection_start = i - 1;
        return
      end
    end
    # Default case: user must have clicked the right edge
    self.caret_pos = self.selection_start = self.text.length
  end
end

class Home < Gosu::Window

  def initialize
    super SCREEN_W, SCREEN_H
    self.caption = "Gym Tracker"
    #ObjectSpace.define_finalizer(self, self.class.method(:finalize))  # Works in both 1.9.3 and 1.8
      @text_fields = Array.new(2) { |index| TextField.new(self, BOX_X + index * 350, BOX_Y ) }
      @x = 0
      #sql
      @i = 0
      @data=[]
      sql
      
      #sort
      @sort_by=nil
      @sort_by_best=nil
      
      @shoes= Gosu::Image.new("./Asset/shoes.png")
      @weight= Gosu::Image.new("./Asset/weight.png")
      #status
      @trophy_status= Gosu::Image.new("./Asset/trophy_status.png")
      @run_status=Gosu::Image.new("./Asset/run_status.png")


  end

  # include Gosu::TextInput
  def draw_home
      #menu background
      draw_rect(0, 0, SCREEN_W, SCREEN_H, MENU_COLOR, ZOrder::BACKGROUND, mode = :default)

    
      #texts
      BOLD_FONT.draw_markup("Today is #{DAY[Time.now.wday.to_i]} #{Time.now.day} #{MONTH[Time.now.month.to_i-1]} 2023 ", 200, 50, ZOrder::UI, 1.0, 1.0, FONT_COLOR)
      REG_FONT.draw_text("Miles ran ", 250, 200, ZOrder::UI, 1.0, 1.0, FONT_COLOR)
      REG_FONT.draw_text("Weight lifted", 550, 200, ZOrder::UI, 1.0, 1.0, FONT_COLOR)
      @weight.draw_rot(500,195,10,0,0,0,img_size(@shoes.width,40), img_size(@shoes.height,40), Gosu::Color::WHITE)
      @shoes.draw_rot(200,190,10,0,0,0,img_size(@weight.width,40), img_size(@weight.height,40), Gosu::Color::WHITE)
      @text_fields.each { |tf| tf.draw(0) }

      draw_sort_by
      #menu
      time=@data.clone


      if @sort_by_best == nil && @sort_by == nil
        draw_history(time)
      end

      
     # miles ran and weight lifted
      if @sort_by 
  
        
        draw_history(time)
      elsif @sort_by == false
        draw_history(time.reverse)
      end

      sorted_array = merge_sort_2d(@data).clone
      if @sort_by_best
        # @sorted_by_sum_of_first_and_second_elements = merge_sort_2d(@data).reverse
        draw_sort_by_best(sorted_array)
      elsif @sort_by_best== false
        # @sorted_by_sum_of_first_and_second_elements = merge_sort_2d(@data)
        draw_sort_by_best(sorted_array.reverse)
      end
      #drawing the status of workout
      draw_status
  end
  
 

  def draw_history(time)
    w_inc = 0
      time.each do |m|
        window = SCREEN_H - 70
        box= 50+w_inc+@x
        number = 80+w_inc+@x

        #sylvain
        # if number <= 50
        #   @x =0
        # end
        Gosu.draw_rect SCREEN_W/2,box , 850, 80, LIGHT_BLUE, ZOrder::BACKGROUND if box>=20 && box <= window-30
        
        SMALL_FONT.draw_text("Miles ran      #{m[1]}", SCREEN_W/1.9, number, ZOrder::UI, 1.0, 1.0, FONT_COLOR) if number >= 50 && number <= window
        SMALL_FONT.draw_text("Weight lifted      #{m[2]} ",SCREEN_W/1.7+100, number, ZOrder::UI, 1.0, 1.0, FONT_COLOR) if number >= 50 && number <= window
        SMALL_FONT.draw_text("#{m[3]}", SCREEN_W/1.5+250, number, ZOrder::UI, 1.0, 1.0, FONT_COLOR) if number >= 50 && number <= window
        w_inc+=120
      end
    end

  def draw_sort_by_best(sort)
    w_inc = 0
    #  @sorted_by_sum_of_first_and_second_elements = merge_sort_2d(@data)
    sort.each do |m|
    window = SCREEN_H - 70
      box= 50+w_inc+@x
      Gosu.draw_rect SCREEN_W/2,box , 850, 80, LIGHT_BLUE, ZOrder::BACKGROUND if box>=20 && box <= window-30
      number = 80+w_inc+@x
      
      SMALL_FONT.draw_text("Miles ran      #{m[1]}", SCREEN_W/1.9, number, ZOrder::UI, 1.0, 1.0, FONT_COLOR) if number >= 50 && number <= window
      SMALL_FONT.draw_text("Weight lifted      #{m[2]} ",SCREEN_W/1.7+100, number, ZOrder::UI, 1.0, 1.0, FONT_COLOR) if number >= 50 && number <= window
      SMALL_FONT.draw_text("#{m[3]}", SCREEN_W/1.5+250, number, ZOrder::UI, 1.0, 1.0, FONT_COLOR) if number >= 50 && number <= window
      w_inc+=120

        
    
    end
  end

  def draw_sort_by
    i=0
    2.times do 
      draw_rect 200+i,330 , 250, 70, BLUE, ZOrder::BACKGROUND
      i+=300
    end
    if @sort_by 
      REG_FONT.draw_text("Sort by oldest", 250, 350, ZOrder::UI, 1.0, 1.0, BOX_COLOR)
    else 
        REG_FONT.draw_text("Sort by newest", 250, 350, ZOrder::UI, 1.0, 1.0, BOX_COLOR)
    end

    if @sort_by_best 
      REG_FONT.draw_text("Worst performance", 530, 350, ZOrder::UI, 1.0, 1.0, BOX_COLOR)

      else 
        REG_FONT.draw_text("Best peformance", 530, 350, ZOrder::UI, 1.0, 1.0, BOX_COLOR)

    end

    draw_rect 200,330 , 250, 70, SELECTED, ZOrder::PLAYER if @sort_by != nil
    draw_rect 500,330 , 250, 70, SELECTED, ZOrder::PLAYER if @sort_by_best != nil

  end

  def draw_status
    box_x=180
    box_y = 500
    
    miles =[]
    weight=[]

    i=0
    data = DataManager.get_data
    time = data.size/2
    time.times do 
      miles << data[i].to_i
      weight<< data[i+1].to_i
      i+=2
    end

    
    
    RECT.draw_rot(box_x,box_y, ZOrder::BACKGROUND,0,0,0,img_size(RECT.width,700), img_size(RECT.height,400), LIGHT_BLUE)
     if data.empty?
      @run_status.draw_rot(box_x+340,box_y+40,ZOrder::BACKGROUND,0,0,0,img_size(@run_status.width,320), img_size(@run_status.height,320), BOX_COLOR)
      REG_FONT.draw_text("No record yet",box_x+50,box_y+50, ZOrder::UI, 1.0, 1.0, FONT_COLOR)
      BOLD_FONT.draw_text("Let's get started!",box_x+50,box_y+300, ZOrder::UI, 1.0, 1.0, FONT_COLOR)
     else
      @trophy_status.draw_rot(box_x+350,box_y+60,ZOrder::BACKGROUND,0,0,0,img_size(@run_status.width,230), img_size(@run_status.height,230), BOX_COLOR)
      REG_FONT.draw_text("Today you did",box_x+50,box_y+50, ZOrder::UI, 1.0, 1.0, FONT_COLOR)
      BOLD_FONT.draw_text("#{miles.sum} miles \nand #{weight.sum} weight!",box_x+50,box_y+250, ZOrder::UI, 1.0, 1.0, FONT_COLOR)
    end
    

  end

    
  


def draw
  draw_home
  menu
end
   
def area_clicked
  #sort by buttons
if mouse_y > 330 && mouse_y < 400
  if mouse_x > 200 && mouse_x < 450
    return 0
  elsif mouse_x > 500 && mouse_x < 750
    return 1

  end

end


if mouse_x > 20 && mouse_x < 110
  
  if mouse_y > 160 && mouse_y < 280
    return 2
  elsif mouse_y.between?(SCREEN_H-90,SCREEN_H-90+50)
    return 3
  elsif mouse_y.between?(300,420)
    return 4
  end
end

end

  def needs_cursor?; true; end
  
def button_down(id)
  
      case id
  when Gosu::MsLeft
    # Mouse click: Select text field based on mouse position.
    self.text_input = @text_fields.find { |tf| tf.under_mouse? }
    # Also move caret to clicked position
    self.text_input.move_caret_to_mouse unless self.text_input.nil?
    case area_clicked
      #sort by buttons
    when 0
      @sort_by_best = nil
      if @sort_by == true
      @sort_by = false
      else
        @sort_by = true
      end
    when 1
      @sort_by = nil
      if @sort_by_best == true
        @sort_by_best = false
        else
          @sort_by_best = true
        end 
      when 2
        close
        Chart.new.show
      when 3
        DataManager.delete_selection
        DataManager.delete_data
        close
        Users.new.show
      when 4
        close
        Rank.new.show
          
    end
  when Gosu::KB_RETURN
    
          if self.text_input
            @text_fields[0].save_to_data
            @text_fields[1].save_to_data
            data = DataManager.get_data
            
            @db.execute("INSERT INTO gym_data (miles, weight, time, users_id)
            VALUES (?,?, ?,?)", [data[@i].to_i,data[@i+1].to_i, "#{Time.now}"], DataManager.get_selection) 
            
            @db.execute("SELECT * FROM gym_data ORDER BY data_id DESC LIMIT 1") do |row|
              @data << row
            end
          @i+=2
          else
            close
          end
          
        when Gosu::MS_WHEEL_UP
          @x +=20
        when Gosu::MS_WHEEL_DOWN
          
          @x -=20
        end
      
  end
 

end    



#DO NOT TOUCH ANYTHING


# Users.new.show