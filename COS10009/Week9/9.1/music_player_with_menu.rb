require_relative "input_functions.rb"

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']
$albums = nil
#Album
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

  def print_tracks
    i = 1
    @tracks.each do |track|
      print "#{i} "
      track.printf
      i += 1
    end
  end

  def edit_title
    puts "Enter a new title for the Album:"
    @title = gets.chomp
  end

  def edit_genre
    i = 1
    while i < $genre_names.length
      puts "#{i} #{$genre_names[i]}"
      i += 1
    end
    puts "Enter number of genre:"
    @genre = gets.chomp.to_i
  end
end
#


#Track
class Track
	attr_accessor :name, :location
	def initialize (name, location)
		@name = name
		@location = location
	end

  def printf
    puts "Track name: #{@name}"
    # puts "Track file location: #{@location}"
  end
end
#

def read_albums(music_file)
  music_file = File.new(music_file, "r")
  no_of_albums = music_file.gets.chomp.to_i
  albums = Array.new
  no_of_albums.times do
    album = read_album(music_file)
    albums << album
  end
	music_file.close
  $albums = albums
  puts "#{no_of_albums} albums loaded. Press enter to continue.";gets;menu
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

def read_tracks(music_file)
	no_of_tracks = music_file.gets.chomp.to_i
	tracks = Array.new
	no_of_tracks.times do
  	track = read_track(music_file)
  	tracks << track
	end
	return tracks
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

def display_all_albums
  print_albums
  puts
  select_display_option
end

def display_albums_by_genre
  i = 1
  while i < $genre_names.length
    puts "#{i}. #{$genre_names[i]}"
    i += 1
  end

  puts "Pick a genre"
  select = gets.chomp
  puts
  
  $albums.each do |album|
    if album.genre == select
      album.printf
    end
  end
  puts
  select_display_option
end

def menu
  puts "Main Menu:
1 Read in Albums
2 Display Albums
3 Select an Album to play
4 Update an existing Album
5 Exit the application
Please enter your choice:"

  select = gets.chomp
  puts
  case select
  when "1"
    select_file_to_read
  when "2"
    select_display_option
  when "3"
    select_album_to_play
  when "4"
    select_album_to_update
  end
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

def select_display_option
  puts "Display Album Menu:
1 Display all Albums
2 Display Albums by Genre
3 Back to Main Menu
Please enter your choice:"

  select = gets.chomp
  puts
  case select
  when "1"
    display_all_albums
  when "2"
    display_albums_by_genre
  when "3"
    menu
  end
end

def select_album_to_play
  print_albums

  puts "Enter Album number:"
  selected_album = gets.chomp.to_i - 1
  album = $albums[selected_album]
  puts
  album.print_tracks

  puts "Select a Track to play:"
  selected_track = gets.chomp.to_i - 1
  track = album.tracks[selected_track]
  puts
  puts "Playing track #{track.name} from album #{album.title}"
  puts
  menu
end

def select_album_to_update
  print_albums
  puts "Enter the Album to edit:"
  selected_album = gets.chomp.to_i - 1
  album = $albums[selected_album]
  
  puts
  puts "What to edit?
1 Title
2 Genre
Enter selection:"
  edited_part = gets.chomp.to_i
  puts

  case edited_part
  when 1
    album.edit_title
    album.printf
    puts "Press enter to continue"
    gets
    puts
  when 2
    album.edit_genre
    album.printf
    puts "Press enter to continue"
    gets
    puts
  end
  menu
end

menu
