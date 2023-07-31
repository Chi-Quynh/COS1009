require 'rubygems'
require 'gosu'
require './input_functions.rb'
require './albums_function.rb'
# require './ruby9.3.music_player.rb'

BACKGROUND_COLOR = Gosu::Color.new 0xFF1a1a1a
SCREEN_W = 1600 
SCREEN_H = 800
ACTIONS_COLOR = Gosu::Color.new 0xFF00111f
FOREGROUND_COLOR = Gosu::Color.new 0xFF595959

UNINTERACTABLE_COLOR = Gosu::Color.new 0xFF858585
X_LOCATION = 500		# x-location to display track's name

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

# class Shape
# 	attr_reader :x, :y

# 	def initialize(x, y)
# 	  @x = x
# 	  @y = y
	 
# 	end
# 	def draw
# 	  # Implement your shape drawing logic here
# 	  # Example: Draw a rectangle at the specified position
# 	  Gosu::Font.new(20).draw_text("New playlist #{y}", 20 , 255+ x, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE) 
# 	  Gosu.draw_rect(0 , 240+ x, 200, 50, FOREGROUND_COLOR)
# 	end
# end

class ArtWork
	attr_accessor :bmp, :dim
	def initialize(file, leftX, topY)
		@bmp = Gosu::Image.new(file)
		@dim = Dimension.new(leftX, topY, leftX + @bmp.width(), topY + @bmp.height())
	end
end

class Dimension
	attr_accessor :leftX, :topY, :rightX, :bottomY
	def initialize(leftX, topY, rightX, bottomY)
		@leftX = leftX
		@topY = topY
		@rightX = rightX
		@bottomY = bottomY
	end
end


class Home < Gosu::Window
	def initialize
	    super SCREEN_W, SCREEN_H
	    self.caption = "Home"
	    @track_font = Gosu::Font.new(20)
	    @albums = read_albums()

		# #times clicked
		# @times_clicked = 1
		# @times_created_playlist = 0
		# @shapes = []

        
		#playstation
		@playing = false
		@play_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/play.png")
		@rewind_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/fast_backward.png")
		@pause_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/pause.png")
		@forward_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/fast_forward.png")
		@shuffle_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/shuffle.png")

		@home_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/home.png")
		@plus_song_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/plus_song.png")
		
	end

	def img_size(image_size, new_size)
		decrease = new_size.fdiv(image_size)
		return decrease
	end
	  
	def draw_action_buttons
		@home_button.draw 20, 20 , z = ZOrder::UI, 0.5, 0.5, UNINTERACTABLE_COLOR
		@plus_song_button.draw SCREEN_W/2 -300, SCREEN_H - 70, z = ZOrder::UI, 0.5, 0.5
		
		@shuffle_button.draw SCREEN_W/2 + 300, SCREEN_H - 70, z = ZOrder::UI, 0.5, 0.5
		@rewind_button.draw SCREEN_W/2 - 40, SCREEN_H - 70, z = ZOrder::UI, 0.5, 0.5
		if @playing
		@play_button.draw SCREEN_W/2, SCREEN_H - 70, z = ZOrder::UI, 0.5, 0.5
		else
		@pause_button.draw SCREEN_W/2, SCREEN_H - 70, z = ZOrder::UI, 0.5, 0.5
		end
		@forward_button.draw SCREEN_W/2 + 40, SCREEN_H - 70, z = ZOrder::UI, 0.5, 0.5
	end

	def draw_controller_section
		# Action buttons' box
		draw_line 0, SCREEN_H - 90, FOREGROUND_COLOR, SCREEN_W, SCREEN_H - 90, FOREGROUND_COLOR 
        draw_line 200, 0, FOREGROUND_COLOR, 200, SCREEN_H-90, FOREGROUND_COLOR 
		draw_action_buttons
	end

    
	def draw_track_and_album_name(albums)
        i =  0
        y = 120
        albums.each do |album|
        img = @albums[i].artwork.bmp
		@album_title =  @albums[i].title.chomp 
		@album_name=  @albums[i].artist.chomp
        @track_font.draw_text(@album_title, 260 + img.width, y , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
		@track_font.draw_text(@album_name, 1000, y , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
        i += 1
        y += 160
        end
	end

		  # Draw albums' artworks
	def draw_albums(albums)
			  # img = load_image(element.path) # Safely Loads in image from file path
				# Uses img_size to convert size to 1.0 size scaling
				i= 50
			  #   img = album.artwork.bmp
				albums.each do |album|
	  
				  img = album.artwork.bmp
				  img.draw_rot(250,i,10,0,0,0,img_size(img.width,150), img_size(img.height,150), Gosu::Color::WHITE)
				  i += 160
				end  
	end

	def draw_background()
		draw_quad(0,0, BACKGROUND_COLOR, 0, SCREEN_H, BACKGROUND_COLOR, SCREEN_W, 0, BACKGROUND_COLOR, SCREEN_W, SCREEN_H, BACKGROUND_COLOR, z = ZOrder::BACKGROUND)
	end

	def draw_create
		@track_font.draw_text("General Album", 20, 150 , ZOrder::UI, 1.0, 1.0, FOREGROUND_COLOR)
		@track_font.draw_text("Playlist", 20, 200 , ZOrder::UI, 1.0, 1.0, FOREGROUND_COLOR)

	end

	# Draws the album images and the track list for the selected album
	def draw
		draw_background()
		draw_controller_section
        draw_track_and_album_name(@albums)
		draw_albums(@albums)
	
		draw_create
		# If an album is selected => display its tracks
	end

	def area_clicked(mouse_x,mouse_y)
		size = @albums[1].artwork.bmp.width
		if (mouse_x > 260  && mouse_x < 260 + size) then
			if (mouse_y > 50 && mouse_y< 50 + 160)
				return 0
			elsif (mouse_y > 50 + 160 && mouse_y< 50 + 320)
				return 1
			elsif (mouse_y > 50 + 320 && mouse_y< 50 + 480)
				return 2
			elsif (mouse_y > 50 + 480 && mouse_y< 50 + 640)
				return 3
		  end
	  	end

	
	end

    def needs_cursor?; true; end
    
	def button_down(id)
		case id
		when Gosu::MsLeft
            button = area_clicked(mouse_x,mouse_y)
      	case button
      	when 0
        $select = 0
        close
        MusicPlayerMain.new.show if __FILE__ == $0
		when 1
        $select = 1
        close
        MusicPlayerMain.new.show if __FILE__ == $0
		when 2
        $select = 2
        close
        MusicPlayerMain.new.show if __FILE__ == $0
		when 3
        $select = 3
        close
        MusicPlayerMain.new.show if __FILE__ == $0
		
		
		end
    	end
	end
end


require 'rubygems'
require 'gosu'
require './input_functions.rb'
require './albums_function.rb'



class MusicPlayerMain < Gosu::Window

	def initialize
	    super SCREEN_W, SCREEN_H
	    self.caption = "Music Player"
	    @album_font = Gosu::Font.new(25)
		@track_font = Gosu::Font.new(20)
	    @albums = read_albums()
		#times clicked to create playlist
	
	

		@playlist = []
		#reading playlist
		# @playlists = read_albums "./playlists.txt" 
		# @playlist_id = 0
		# @playlist = @playlists[@playlist_id]
		# @new_playlist = false

		#selection
		@album_id = $select
		@album = @albums[@album_id]

		@track_id = 0 
    	@location = @album.tracks[@track_id].location.chomp

	

		#song playing
		@song = Gosu::Song.new(@location)
		@song.play(false) 
		@song.volume = 0.5
		@turn_off = false

		#playstation
		@play_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/play.png")
		@rewind_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/fast_backward.png")
		@pause_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/pause.png")
		@forward_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/fast_forward.png")
		@shuffle_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/shuffle.png")
		@home_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/home.png")
		@next_album = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/right-arrow.png")
		@prev_album = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/left-arrow.png")

		@plus_song_button = Gosu::Image.new("D:/COS10009/Week9/9.3/9.3.album_covers/plus_song.png")
	end
	
def img_size(image_size, new_size)
  decrease = new_size.fdiv(image_size)
  return decrease
end

def draw_albums()
	# @album_image = ArtWork.new("D:/COS10009/Week9/9.3/9.3.album_covers/blue-lock.jpg", 150, 50)
	case @album_id
	when 0
	  	@album_image = ArtWork.new("D:/COS10009/Week9/9.3/9.3.album_covers/blue-lock.jpg", 150, 50)
	when 1
	 	@album_image = ArtWork.new("D:/COS10009/Week9/9.3/9.3.album_covers/fe3h-album.png", 150, 50)
	when 2
		@album_image = ArtWork.new("D:/COS10009/Week9/9.3/9.3.album_covers/g-idle.jpg", 150, 50)
	when 3
		@album_image = ArtWork.new("D:/COS10009/Week9/9.3/9.3.album_covers/le-sa.png", 150, 50)
	else
		@album_image = ArtWork.new("D:/COS10009/Week9/9.3/9.3.album_covers/sylvain.jpg", 150, 50)
	end
	@album_image.bmp.draw(220, 20, 2)
end


	

  def draw_track_and_album_name()
	size= @album_image.bmp.width
    album_name = @albums[@album_id].title.chomp + "\n"  + @albums[@album_id].artist.chomp
    @album_font.draw_text(album_name, 240+ size, 80, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    @i = 0 
    @stay_string = @track_id #to make sure not to change string when click at blank in button_down(id)
    while @i <= @album.tracks.length
      if @i == 0 
        @name = @album.tracks[@i].name.chomp rescue ""
        if @i == @track_id and @name != ""
          @name = @album.tracks[@track_id].name.upcase + "             Now playing"
		  @name_title= @album.tracks[@track_id].name
		  @track_font.draw_text(@name_title, SCREEN_W/2 - 40 + @name_title.length.to_i/2, SCREEN_H - 40 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
		  draw_quad(200,60 +size, FOREGROUND_COLOR, SCREEN_W, 60 +size, FOREGROUND_COLOR,200,120 +size , FOREGROUND_COLOR, SCREEN_W, 120 +size,FOREGROUND_COLOR, z = ZOrder::BACKGROUND)
		  
        end
		
        @track_font.draw_text(@name, 240, 80 +size , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      elsif @i == 1 
        @name = @album.tracks[@i].name.chomp rescue ""
        if @i == @track_id and @name != ""
          @name = @album.tracks[@track_id].name.upcase + "             	Now playing"
		  @name_title= @album.tracks[@track_id].name
		  @track_font.draw_text(@name_title,  SCREEN_W/2 - 40 + @name_title.length.to_i/2, SCREEN_H - 40 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
		  draw_quad(200,120 +size + 20, FOREGROUND_COLOR, SCREEN_W, 120 +size+ 20, FOREGROUND_COLOR,200,180 +size+ 20 , FOREGROUND_COLOR, SCREEN_W, 180 +size+ 20,FOREGROUND_COLOR, z = ZOrder::BACKGROUND)
        end
		
        @track_font.draw_text(@name, 240, 160 +size , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      elsif @i == 2 
        @name = @album.tracks[@i].name.chomp rescue ""
        if @i == @track_id and @name != ""
          @name = @album.tracks[@track_id].name.upcase + "             Now playing"
		  @name_title= @album.tracks[@track_id].name
		  @track_font.draw_text(@name_title,  SCREEN_W/2 - 40 + @name_title.length.to_i/2, SCREEN_H - 40 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
		  draw_quad(200,180 +size+ 40, FOREGROUND_COLOR, SCREEN_W, 180 +size+ 40, FOREGROUND_COLOR,200,240 +size+ 40 , FOREGROUND_COLOR, SCREEN_W, 240 +size+ 40,FOREGROUND_COLOR, z = ZOrder::BACKGROUND)
        end
		
        @track_font.draw_text(@name, 240, 240 +size , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      elsif @i == 3 
        @name = @album.tracks[@i].name.chomp rescue ""
        if @i == @track_id and @name != ""
          @name = @album.tracks[@track_id].name.upcase + "             Now playing"
		  @name_title= @album.tracks[@track_id].name
		  @track_font.draw_text(@name_title, SCREEN_W/2 - 40 + @name_title.length.to_i/2, SCREEN_H - 40 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
		  draw_quad(200,240 +size+ 60, FOREGROUND_COLOR, SCREEN_W, 240 +size+ 60, FOREGROUND_COLOR,200,300 +size+ 60 , FOREGROUND_COLOR, SCREEN_W, 300 +size+ 60,FOREGROUND_COLOR, z = ZOrder::BACKGROUND)
        end
        @track_font.draw_text(@name, 240, 320 +size , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      elsif @i == 4 
        @name = @album.tracks[@i].name.chomp rescue ""
        if @i == @track_id and @name != ""
			draw_quad(200,300 +size+ 80, FOREGROUND_COLOR, SCREEN_W, 300 +size+ 80, FOREGROUND_COLOR,200,360 +size+ 80 , FOREGROUND_COLOR, SCREEN_W, 360 +size+ 80,FOREGROUND_COLOR, z = ZOrder::BACKGROUND)
          @name = @album.tracks[@track_id].name.upcase + "             Now playing"
		  @name_title= @album.tracks[@track_id].name
		  @track_font.draw_text(@name_title, SCREEN_W/2 - 40 + @name_title.length.to_i/2, SCREEN_H - 40 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
        end
        @track_font.draw_text(@name, 240, 400 +size , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      end
    @i += 1
    end
  end

	def draw_action_buttons
		@plus_song_button.draw SCREEN_W/2 -300, SCREEN_H - 70, z = ZOrder::UI, 0.5, 0.5
		@next_album.draw SCREEN_W - 300,  40, z = ZOrder::UI, 0.5, 0.5
		@prev_album.draw SCREEN_W - 400,  40, z = ZOrder::UI, 0.5, 0.5
		@home_button.draw 20, 20 , z = ZOrder::UI, 0.5, 0.5

		@shuffle_button.draw SCREEN_W/2 + 300, SCREEN_H - 70, z = ZOrder::UI, 0.5, 0.5
		@rewind_button.draw SCREEN_W/2 - 40, SCREEN_H - 70, z = ZOrder::UI, 0.5, 0.5
		if @song.paused?
		@play_button.draw SCREEN_W/2, SCREEN_H - 70, z = ZOrder::UI, 0.5, 0.5
		else
		@pause_button.draw SCREEN_W/2, SCREEN_H - 70, z = ZOrder::UI, 0.5, 0.5
		end
		@forward_button.draw SCREEN_W/2 + 40, SCREEN_H - 70, z = ZOrder::UI, 0.5, 0.5
	end

	def shuffle
		prev_album_id = @album_id
		prev_track_id = @track_id
		
		@album_id = rand(0..3)
		@album = @albums[@album_id]
		@track_id = rand(0..@album.tracks.length-1)
		while prev_album_id == @album_id && prev_track_id == @track_id
		  @album_id = rand(3)
		  @album = @albums[@album_id]
		  @track_id = rand(0..@album.tracks.length-1)
		end
		
		@location = @album.tracks[@track_id].location.chomp
		@song = Gosu::Song.new(@location)
		@song.play(false) 
		@song.volume = 0.5
		@turn_off = false
	
	end

	# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR
	def draw_background()
		draw_quad(0,0, BACKGROUND_COLOR, 0, SCREEN_H, BACKGROUND_COLOR, SCREEN_W, 0, BACKGROUND_COLOR, SCREEN_W, SCREEN_H, BACKGROUND_COLOR, z = ZOrder::BACKGROUND)
	end

	def draw_controller_section
			# Action buttons' box
			draw_line 0, SCREEN_H - 90, FOREGROUND_COLOR, SCREEN_W, SCREEN_H - 90, FOREGROUND_COLOR 
			draw_line 200, 0, FOREGROUND_COLOR, 200, SCREEN_H-90, FOREGROUND_COLOR 
			draw_action_buttons
	end
	
	def draw_playlist_and_tracks
		i = 0
		@album_font.draw_text("New Playlist  "+"\n" +"Lily Patch", 240 + 200, 80, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
		size= @album_image.bmp.width
		while i <= @playlist.length-1
			if i == 0
				@name = @playlist[i].name.chomp rescue ""
				
				if i == @track_id and @name != ""
				@track_font.draw_text(@playlist[i].name, SCREEN_W/2 - 40 , SCREEN_H - 40 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
				draw_quad(200,60 +size, FOREGROUND_COLOR, SCREEN_W, 60 +size, FOREGROUND_COLOR,200,120 +size , FOREGROUND_COLOR, SCREEN_W, 120 +size,FOREGROUND_COLOR, z = ZOrder::BACKGROUND)
				@name = @playlist[i].name.upcase + "             Now playing"
				end
				@track_font.draw_text(@name, 240, 80 + size , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
			elsif i == 1
        		@name = @playlist[i].name.chomp rescue ""
				
				if i == @track_id and @name != ""
				@track_font.draw_text(@playlist[i].name, SCREEN_W/2 - 40 , SCREEN_H - 40 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
				draw_quad(200,120 +size + 20, FOREGROUND_COLOR, SCREEN_W, 120 +size+ 20, FOREGROUND_COLOR,200,180 +size+ 20 , FOREGROUND_COLOR, SCREEN_W, 180 +size+ 20,FOREGROUND_COLOR, z = ZOrder::BACKGROUND)
				@name = @playlist[i].name.upcase + "             Now playing"
				end
				@track_font.draw_text(@name, 240, 160 + size , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
			elsif i == 2
        		@name = @playlist[i].name.chomp rescue ""
				
				if i == @track_id and @name != ""
				@track_font.draw_text(@playlist[i].name, SCREEN_W/2 - 40 , SCREEN_H - 40 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
				draw_quad(200,180 +size+ 40, FOREGROUND_COLOR, SCREEN_W, 180 +size+ 40, FOREGROUND_COLOR,200,240 +size+ 40 , FOREGROUND_COLOR, SCREEN_W, 240 +size+ 40,FOREGROUND_COLOR, z = ZOrder::BACKGROUND)
				@name = @playlist[i].name.upcase + "             Now playing"
				end
				@track_font.draw_text(@name, 240, 240 + size , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
			elsif i == 3
        		@name = @playlist[i].name.chomp rescue ""
				
				if i == @track_id and @name != ""
				@track_font.draw_text(@playlist[i].name, SCREEN_W/2 - 40 , SCREEN_H - 40 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
				draw_quad(200,240 +size+ 60, FOREGROUND_COLOR, SCREEN_W, 240 +size+ 60, FOREGROUND_COLOR,200,300 +size+ 60 , FOREGROUND_COLOR, SCREEN_W, 300 +size+ 60,FOREGROUND_COLOR, z = ZOrder::BACKGROUND)
				@name = @playlist[i].name.upcase + "             Now playing"
				end
				@track_font.draw_text(@name, 240, 320 + size , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
			elsif i == 4
        		@name = @playlist[i].name.chomp rescue ""
				
				if i == @track_id and @name != ""
				@track_font.draw_text(@playlist[i].name, SCREEN_W/2 - 40 , SCREEN_H - 40 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
				draw_quad(200,300 +size+ 80, FOREGROUND_COLOR, SCREEN_W, 300 +size+ 80, FOREGROUND_COLOR,200,360 +size+ 80 , FOREGROUND_COLOR, SCREEN_W, 360 +size+ 80,FOREGROUND_COLOR, z = ZOrder::BACKGROUND)
				@name = @playlist[i].name.upcase + "             Now playing"
				end
				@track_font.draw_text(@name, 240, 400 + size , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
			end
			i += 1
		end

	end


	def draw_create
		@track_font.draw_text("General Album", 20, 150 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
		@track_font.draw_text("Playlist", 20, 200 , ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)

	end
	# Draws the album images and the track list for the selected album
	def draw
		draw_background()
		draw_controller_section
		draw_albums()
		if @new_playlist 
			draw_playlist_and_tracks
			draw_rect(0, 185, 200, 50, FOREGROUND_COLOR, z = 0, mode = :default)
			
		else
		draw_track_and_album_name()
		draw_rect(0, 135, 200, 50, FOREGROUND_COLOR, z = 0, mode = :default)
		end

		draw_create
		# If an album is selected => display its tracks
		
	end

	def auto_play()
		if Gosu::Song.current_song == nil
		  if @track_id < @album.tracks.length-1
			@track_id += 1
			@location = @album.tracks[@track_id].location.chomp
			@song = Gosu::Song.new(@location)
			@song.play(false)
		  else
			if @album_id < @albums.length-1
			  @album_id += 1
			else
			  @album_id = 0
			end
			@track_id = 0
			@album = @albums[@album_id]
			@location = @album.tracks[@track_id].location.chomp
			@song = Gosu::Song.new(@location)
			@song.play(false)
		  end
		end
	end
	
	def add_to_playlist
		#cloning
		@album_location = @album_id.clone
		@track_location = @track_id.clone
		track = @albums[@album_location].tracks[@track_id].clone
		@playlist << track
	

		# @current_song = Gosu::Song::current_song
		# @playlist << @current_song

		#WIP
		# @album = @albums[album_location]
		# @track_id = @album.tracks.length-1
		# 		  @location = @album.tracks[@track_id].location.chomp
		# 		  @song = Gosu::Song.new(@location)
		# 		  @song.play(false)

		
		
			# if @track_location > @playlist_tracks.length - 1
			# 		@track_id = @stay_string
			# else
			# 		@location = @album[@album_location].tracks[@track_location].location.chomp
			# 		@song = Gosu::Song.new(@location)
			# 		@song.play(false) 
			# end
			# 	  @turn_off = false

	end
	def area_clicked(mouse_x,mouse_y)
		# complete this code
		size= @album_image.bmp.width
	   if (mouse_y < SCREEN_H && mouse_y> SCREEN_H - 70) then #forward
		 	if (mouse_x < SCREEN_W/2 + 40 && mouse_x > SCREEN_W/2) then
			return 1
		 elsif (mouse_x > SCREEN_W/2 - 40 && mouse_x < SCREEN_W/2) #rewind
			return 2
		elsif (mouse_x > SCREEN_W/2 + 40 && mouse_x < SCREEN_W/2 + 80)
			return 3
		elsif (mouse_x > SCREEN_W/2 + 300 && mouse_x < SCREEN_W/2 + 380)
			return 9
		elsif mouse_x > SCREEN_W/2 -300 && mouse_x < SCREEN_W/2 -300 +48
			return 20
	   		end
		end

		if mouse_x > 200 && mouse_x< SCREEN_W then
			if mouse_y > 60 +size && mouse_y< 120 +size 
				return 4
			elsif mouse_y > 120 +size + 20 && mouse_y< 180 +size + 20
				return 5
			elsif mouse_y > 180 +size+ 40 && mouse_y< 240 +size+ 40
				return 6
			elsif mouse_y > 240 +size+ 60 && mouse_y< 300 +size+ 60
				return 7
			elsif mouse_y > 300 +size+ 80 && mouse_y< 120 +size+ 360 +size+ 80
				return 8
			end
		end

		if mouse_x > 20 && mouse_x< 68 then
			if mouse_y > 20 && mouse_y< 68 then
				return 10
			end
		end
		if mouse_y > 40 && mouse_y< 108 then
			if mouse_x > SCREEN_W - 300 && mouse_x< SCREEN_W - 236 then
				return 11
			elsif mouse_x > SCREEN_W - 400 && mouse_x< SCREEN_W - 336
				return 12
			end
		end

		if mouse_x > 0 && mouse_x < 200 then
		
			if mouse_y > 150 && mouse_y < 200
				return 13
			elsif mouse_y > 200 && mouse_y < 240
				return 14
			end
		end
	end


	def update
		if @turn_off == false
		  auto_play()
		end
	end

	def needs_cursor?; true; end


	def button_down(id)
		
		case id
	    when Gosu::MsLeft
			button = area_clicked(mouse_x,mouse_y)
			case button
				
			when 1 #pause song
					if @song.paused?
					  @song.play(true)
					  @turn_off = false
					else
					  @song.pause
					end
			when 2 #rewind
				
				if @track_id > 0 
				  @track_id -= 1
				  @location = @album.tracks[@track_id].location.chomp
				  @song = Gosu::Song.new(@location)
				  @song.play(false)
				else
					
				  if @album_id > 0
					@album_id -= 1
				  else
					@album_id = 3
				  end
				  @album = @albums[@album_id]
				  @track_id = @album.tracks.length-1
				  @location = @album.tracks[@track_id].location.chomp
				  @song = Gosu::Song.new(@location)
				  @song.play(false)
				end
				@turn_off = false
			when 3 #forward
				
				if @track_id < @album.tracks.length-1
				  @track_id += 1
				  @location = @album.tracks[@track_id].location.chomp
				  @song = Gosu::Song.new(@location)
				  @song.play(false)
				else
				  if @album_id < @albums.length-1
					@album_id += 1
				  else
					@album_id = 0
				  end
				  @track_id = 0
				  @album = @albums[@album_id]
				  @location = @album.tracks[@track_id].location.chomp
				  @song = Gosu::Song.new(@location)
				  @song.play(false)
				end
				@turn_off = false
			when 4
				
				@track_id = 0 
				if @new_playlist == true
					@location = @playlist[@track_id].location.chomp
					@song = Gosu::Song.new(@location)
					@song.play(false) 
				else
				if @track_id > @album.tracks.length-1 
				  @track_id = @stay_string
				else
				  @location = @album.tracks[@track_id].location.chomp
				  @song = Gosu::Song.new(@location)
				  @song.play(false) 
				end 
				end
				@turn_off = false
			  when 5
				
				@track_id = 1 
				if @new_playlist == true
					@location = @playlist[@track_id].location.chomp
					@song = Gosu::Song.new(@location)
					@song.play(false) 
				else
				if @track_id > @album.tracks.length-1 
				  @track_id = @stay_string
				else
				  @location = @album.tracks[@track_id].location.chomp
				  @song = Gosu::Song.new(@location)
				  @song.play(false) 
				end 
				end
				@turn_off = false
			  when 6
				
				@track_id = 2 
				if @new_playlist == true
					@location = @playlist[@track_id].location.chomp
					@song = Gosu::Song.new(@location)
					@song.play(false) 
				else
				if @track_id > @album.tracks.length-1 
				  @track_id = @stay_string
				else
				  @location = @album.tracks[@track_id].location.chomp
				  @song = Gosu::Song.new(@location)
				  @song.play(false) 
				end 
				end
				@turn_off = false
			  when 7
				
				@track_id = 3 
				if @new_playlist == true
					@location = @playlist[@track_id].location.chomp
					@song = Gosu::Song.new(@location)
					@song.play(false) 
				else
				if @track_id > @album.tracks.length-1 
				  @track_id = @stay_string
				else
				  @location = @album.tracks[@track_id].location.chomp
				  @song = Gosu::Song.new(@location)
				  @song.play(false) 
				end
				end
				@turn_off = false
			  when 8
				
				@track_id = 4 
				if @new_playlist == true
					@location = @playlist[@track_id].location.chomp
					@song = Gosu::Song.new(@location)
					@song.play(false) 
				else
				if @track_id > @album.tracks.length-1 
				  @track_id = @stay_string
				else
				  @location = @album.tracks[@track_id].location.chomp
				  @song = Gosu::Song.new(@location)
				  @song.play(false) 
				end
				end
				@turn_off = false 
			  when 9
				@new_playlist = false
				shuffle
			  when 10
				close
				@song.stop
        		@turn_off = true
        		Home.new.show if __FILE__ == $0
			
			  when 11
				@new_playlist = false
				
				  if @album_id < @albums.length-1
					@album_id += 1
				  else
					@album_id = 0
				  end
				  @album = @albums[@album_id]
				  @track_id = 0
				  @location = @album.tracks[@track_id].location.chomp
				  @song = Gosu::Song.new(@location)
				  @song.play(false)
				
				@turn_off = false

				when 12
					@new_playlist = false
					if @album_id >0
						@album_id -= 1
					  else
						@album_id = 3
					  end
					  @album = @albums[@album_id]
					  @track_id = 0
					  @location = @album.tracks[@track_id].location.chomp
					  @song = Gosu::Song.new(@location)
					  @song.play(false)
					
					@turn_off = false
			
				
					when 13
						@new_playlist = false
						@album_id = 0
						@album = @albums[@album_id]
				  		@track_id = 0
				  		@location = @album.tracks[@track_id].location.chomp
				  		@song = Gosu::Song.new(@location)
				  		@song.play(false)
					when 14
						
						@new_playlist = true
						@album_id = 4
						# if @playlist.empty?
						# @turn_off = false
						@song.pause
						# # if @track_location > @playlist_tracks.length - 1
						# # 	@track_id = @stay_string
						# # else
						# else
						# 	@location = @playlist[0].location.chomp
						# 	@song = Gosu::Song.new(@location)
						# 	@song.play(false) 
						# end
								
						# end
						  @turn_off = false
						
					# end
					when 20 #add  to playlist
						@new_playlist = false
						add_to_playlist

			end
		end
	end


end

      
Home.new.show