require 'gosu'
require 'rubygems'
require './gym_functions.rb'

module Genre
    POP, CLASSIC, JAZZ, ROCK = *1..4
end
  
  GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

  class Album
	attr_accessor :title, :artist, :artwork, :tracks
	def initialize (title, artist, artwork, tracks)
		@title = title
		@artist = artist
		@artwork = artwork
		@tracks = tracks
	end
end

class Track
	attr_accessor :name, :location, :dim
	def initialize(name, location, dim)
		@name = name
		@location = location
		@dim = dim
	end
end

# Read a single track
def read_track(a_file, idx)
    track_name = a_file.gets.chomp
    track_location = a_file.gets.chomp
    # --- Dimension of the track's title ---
    leftX = X_LOCATION
    topY = 50 * idx + 30
    rightX = leftX + @track_font.text_width(track_name)
    bottomY = topY + @track_font.height()
    dim = Dimension.new(leftX, topY, rightX, bottomY)
    # --- Create a track object ---
    track = Track.new(track_name, track_location, dim)
    return track
end

# Read all tracks of an album
def read_tracks(a_file)
    count = a_file.gets.chomp.to_i
    tracks = Array.new()
    # --- Read each track and add it into the arry ---
    i = 0
    while i < count
        track = read_track(a_file, i)
        tracks << track
        i += 1
    end
    # --- Return the tracks array ---
    return tracks
end

# Read a single album
def read_album(a_file, idx)
    title = a_file.gets.chomp
    artist = a_file.gets.chomp
    # --- Dimension of an album's artwork ---
    if idx % 2 == 0
        leftX = 30
    else
        leftX = 250
    end
    topY = 190 * (idx / 2) + 30 + 20 * (idx/2)
    artwork = ArtWork.new(a_file.gets.chomp, leftX, topY)
    # -------------------------------------
    tracks = read_tracks(a_file)
    album = Album.new(title, artist, artwork, tracks)
    return album
end

# Read all albums
def read_albums()
    a_file = File.new("ruby9.3.list.txt", "r")
    count = a_file.gets.chomp.to_i
    albums = Array.new()

    i = 0
    while i < count
        album = read_album(a_file, i)
        albums << album
        i += 1
      end

    a_file.close()
    return albums
end

def read_playlist()
    a_file = File.new("playlists.txt", "r")
    count = a_file.gets.chomp.to_i
    albums = Array.new()

    i = 0
    while i < count
        album = read_album(a_file, i)
        albums << album
        i += 1
      end

    a_file.close()
    return albums
end

def write_albums(file_name, album_list)
	album_file = File.new file_name, 'w'
	num_album = album_list.length
	album_file.puts num_album
	album_list.each do |album|
		album_file.puts album.title
		album_file.puts album.artist
        album_file.puts album.artwork.file
		album_file.puts album.tracks.length
		album.tracks.each do |track|
			album_file.puts track.name
			album_file.puts track.location
		end
	end
	album_file.close
end
