# frozen_string_literal: true

require 'rubygems'
require 'gosu'

def debug msg; unless ARGV.empty?; puts msg; end; end

module ZOrder
	BACKGROUND, MIDDLE, TOP = *0..2
end

MAP_WIDTH = 200
MAP_HEIGHT = 200
CELL_DIM = 20

class Cell
	# have a pointer to the neighbouring cells
	attr_accessor :x, :y, :north, :south, :east, :west, :vacant, :visited, :on_path, :next

	def initialize(x, y)
		# Setting the position
		@x, @y = x, y
		# Set the pointers to nil
		@north = nil
		@south = nil
		@east = nil
		@west = nil
		# record whether this cell is vacant
		# default is not vacant i.e is a wall.
		@vacant = false
		# this stops cycles - set when you travel through a cell
		@visited = false
		@on_path = false
		# this element on the path
		# using linked list instead of
		# array of path
		@next = nil
	end

	def inspect
		puts "Cell { x: #{@x}, y: #{@y} }"
	end
end

# Left click on cells to create a maze with at least one path moving from
# left to right.	The right click on a cell for the program to find a path
# through the maze. When a path is found it will be displayed in red.
class GameWindow < Gosu::Window

	# initialize creates a window with a width an a height
	# and a caption. It also sets up any variables to be used.
	def initialize caption
		super MAP_WIDTH, MAP_HEIGHT, false
		self.caption = caption
		@path = nil
		@end = nil
		@found = nil

		@x_cell_count = MAP_WIDTH / CELL_DIM
		@y_cell_count = MAP_HEIGHT / CELL_DIM

		@columns = Array.new @x_cell_count

		@x_cell_count.times do |i|
			@columns[i] = Array.new @
			@y_cell_count.times do |j|
				@columns[i][j] = Cell.new i, j
				unless i.zero?
					@columns[i][j].west = @columns[i - 1][j]
					@columns[i - 1][j].east = @columns[i][j]
				end
				unless j.zero?
					@columns[i][j].north = @columns[i][j - 1]
					@columns[i][j - 1].south = @columns[i][j]
				end
			end
		end

		unless ARGV.empty?
			@x_cell_count.times do |i|
				@y_cell_count.times do |j|
					cur_cell = @columns[i][j]
					print "Cell x: #{i}, y: #{j} "
					print "north:#{cur_cell.north.nil? ? 0 : 1} "
					print "south:#{cur_cell.south.nil? ? 0 : 1} "
					print "east:#{cur_cell.east.nil? ? 0 : 1} "
					print "west:#{cur_cell.west.nil? ? 0 : 1}\n"
				end
				print "----------- End Of Column ----------\n"
			end
		end
	end

	# This is called by Gosu to see if should show the cursor (or mouse)
	def needs_cursor?; true; end

	# Returns the cell that were clicked on
	# set position to 0 if mouse is outside of the window
	def mouse_over_cell(mouse_x, mouse_y)
		x = mouse_x <= CELL_DIM ? 0 : (mouse_x / CELL_DIM).to_i
		y = mouse_y <= CELL_DIM ? 0 : (mouse_y / CELL_DIM).to_i

		@columns[x][y]
	end
	
	# start a recursive search for paths from the selected cell
	# It searches till it hits the East 'wall' then stops
	# It does not necessarily find the shortest path
	# Using DFS -> Faster since we don't need dijkstra for shortest path
	def search(cell)
		return cell if @found 
		return nil if !cell.vacant || cell.visited
		if cell.x == ((MAP_WIDTH / CELL_DIM) - 1)
			debug "End of one path x: #{cell.x} y: #{cell.y}"
			@found = true
			@end = cell
			return cell
		end

		cell.visited = true
		debug "Searching. In cell x: #{cell.x} y: #{cell.y}"

		unless cell.west.nil?
			cell.next = cell.west
			debug "Added x: #{cell.x} y: #{cell.y}"
			search cell.west
		end
		return cell if @found
		unless cell.south.nil?
			cell.next = cell.south
			debug "Added x: #{cell.x} y: #{cell.y}"
			search cell.south
		end
		return cell if @found
		unless cell.east.nil?
			cell.next = cell.east
			debug "Added x: #{cell.x} y: #{cell.y}"
			search cell.east
		end
		return cell if @found
		unless cell.north.nil?
			cell.next = cell.north
			debug "Added x: #{cell.x} y: #{cell.y}"
			search cell.north
		end
		return cell if @found

		debug "Dead end x: #{cell.x} y: #{cell.y}"
		nil
	end

	# Reacts to button press
	# left button marks a cell vacant
	# Right button starts a path search from the clicked cell
	def button_down(id)
		case id
		when Gosu::MsLeft
			cell = mouse_over_cell mouse_x, mouse_y
			debug "Cell clicked on is x: #{cell.x} y: #{cell.y}"
			@columns[cell.x][cell.y].vacant = true
		when Gosu::MsRight
			# Reset visited and on_path
			@x_cell_count.times do |i|
				@y_cell_count.times do |j| 
					@columns[i][j].on_path = false 
					@columns[i][j].visited = false 
				end
			end
			cell = mouse_over_cell mouse_x, mouse_y
			puts cell.x, cell.y
			@path = search cell
		end
	end

	# This will walk along the path setting the on_path for each cell
	# to true. Then draw checks this and displays them a red colour.
	def walk(path)
		while !path.nil?
			path.on_path = true
			path = path.next
		end
	end

	# Put any work you want done in update
	# This is a procedure i.e the return value is 'undefined'
	def update
		return if @path.nil?

		debug "Displaying path\n#{@path.inspect}"
		walk(@path)
		@path = nil
		@found = nil
	end

	# Draw (or Redraw) the window
	# This is procedure i.e the return value is 'undefined'
	def draw
		@x_cell_count.times do |i|
			@y_cell_count.times do |j|
				color = Gosu::Color::GREEN
				if @columns[i][j].on_path
					color = Gosu::Color::RED
				elsif @columns[i][j].vacant
					color = Gosu::Color::YELLOW
				end
				Gosu.draw_rect i * CELL_DIM, j * CELL_DIM, CELL_DIM, CELL_DIM, color, ZOrder::TOP, mode = :default
			end
		end
	end
end

window = GameWindow.new 'Map Creation'
window.show
