require_relative "input_functions.rb"

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']
$albums = nil

class Album
	attr_accessor :title, :artist, :genre, :tracks
	def initialize (title, artist, genre, tracks)
		@title = title
		@artist = artist
		@genre = genre
		@tracks = tracks
	end

  def printf
    genre_txt = $genre_names[@genre.to_i]
    puts "Title: #{@title}, Artist: #{@artist}, Genre: #{genre_txt}"
    # print_tracks
  end
end

class Track
	attr_accessor :name, :location
	def initialize (name, location)
		@name = name
		@location = location
	end
end

def read_track(a_file)
    # complete this function
        # you need to create a Track here.
      name=a_file.gets
      location=a_file.gets
      track=Track.new(name,location)
      return track
        # fill in the missing code
end

def read_tracks(a_file)
    count=a_file.gets.to_i
    tracks=[]
    count.times do
        track=read_track(a_file)
        tracks<<track
    end
    return tracks
end


def read_album(music_file)
	album_artist = music_file.gets.chomp
	album_title = music_file.gets.chomp
  album_year = music_file.gets.chomp
	album_genre = music_file.gets.chomp
	tracks = read_tracks(music_file)
	album = Album.new(album_title, album_artist, album_genre, tracks)
	return album
end

def read_albums(music_file)
  file = File.new(music_file, "r")
  count = file.gets.to_i
  albums=[]
  count.times do
    album = read_album(file)
    albums<< album
  end
  file.close
  $albums = albums
  puts "#{count} albums loaded. Press enter to continue.";gets
end

def read_track(music_file)
	name = music_file.gets.chomp
	location = music_file.gets.chomp
	track = Track.new(name, location)
	return track
end

def print_albums
  i = 1
  $albums.each do |album|
    print "#{i}: "
    album.printf
    i += 1
  end
end

def main
    sylvain= false
    while sylvain == false
    puts "Main Menu:
1 Read in Albums
2 Display Albums
3 Select an Album to play
4 Exit the application
Please enter your choice:"

  select = gets.chomp
  puts
  case select
  when "1"
    select_file_to_read
  when "2"
    display_albums
  when "3"
    play_album
  when "4"    
    sylvain= true
  end
end until sylvain== true
end

def select_file_to_read
  puts "Enter a file path to an Album:"
  file_name = gets.chomp

  if File.exist?(file_name)
    read_albums(file_name)
  else
    puts "No such file or directory '" + file_name + "'"
    select_file_to_read
  end
end

def display_albums
  puts "Display Album Menu:
1 Display all Albums
2 Display Albums by Genre
3 Back to Main Menu
Please enter your choice:"
album = gets.chomp
puts
  case album
  when "1"
    display_all
    display_albums
  when "2"
    display_by_genres 
    display_albums  
  end
end

def display_all
  print_albums
end

def display_by_genres
 puts "Enter number:
 1. Pop
 2. Classic
 3. Jazz
 4. Rock "
  select=gets.chomp
    puts
  $albums.each do |album|
    if album.genre == select
    album.printf
    puts
    end
  end
end

def play_album
  display_all
  puts "Enter album number:"
  
  #display tracks
  album_select =gets.chomp.to_i - 1
  y=0
  $albums[album_select].tracks.each do 
    puts " #{y+1} Track name: #{$albums[album_select].tracks[y].name}"
    y +=1
  end

  #select track to play
  album = $albums[album_select]
  track_select = gets.chomp.to_i - 1
  puts "Playing track: #{album.tracks[track_select].name} from #{album.title}"
  music
end

def music
  puts "♪"
      sleep(0.1)
  
      puts " ♫"
      sleep(0.2)
  
      puts "   ♪"
      sleep(0.3)
  
      puts "    ♫"
      sleep(0.4)
  
      puts "     ♪"
      sleep(0.5)
  
      puts "    ♪"
      sleep(0.4)
  
      puts "  ♪"
      sleep(0.3)
  
      puts "♪"
      sleep(0.2)
      end

main