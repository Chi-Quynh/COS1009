
module Day
	POP, CLASSIC, JAZZ, ROCK, COUNTRY_POP, HIP_HOP, COUNTRY = *1..7
end

module Month
    JANUARY, FEBRUARY, MARCH, APRIL, MAY, JUNE, JULY, AUGUST, SEPTEMBER, OCTOBER, NOVEMBER, DECEMBER = *1..12
end




module DataManager
  @selection=[]

  @shared_data = []

  def self.add_to_data(value)
    @shared_data << value
  end

  def self.get_data
    @shared_data
  end
  
  def self.delete_data
    @shared_data = []
  end

  def self.add_selection(value)
    @selection << value
  end

  def self.delete_selection
    @selection = []
  end

  def self.get_selection
    @selection[0]
  end
end

DAY = ['Sunday', 'Monday', 'Tuesday', ' Wednesday', 'Thursday','Friday','Saturday']
MONTH = [ 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

def merge_sort_2d(arr)
  num_elements = arr.length

  return arr if num_elements <= 1

  middle = num_elements / 2
  left_half = arr[0...middle]
  right_half = arr[middle..-1]

  sorted_left = merge_sort_2d(left_half)
  sorted_right = merge_sort_2d(right_half)

  merge(sorted_left, sorted_right)
end

def merge(left, right)
  sorted_arr = []
  left_index, right_index = 0, 0

  while left_index < left.length && right_index < right.length
    left_sum = left[left_index][1].to_i + left[left_index][2].to_i
    right_sum = right[right_index][1].to_i + right[right_index][2].to_i

    if left_sum <= right_sum
      sorted_arr << left[left_index]
      left_index += 1
    else
      sorted_arr << right[right_index]
      right_index += 1
    end
  end

  sorted_arr.concat(left[left_index..-1]) if left_index < left.length
  sorted_arr.concat(right[right_index..-1]) if right_index < right.length

  sorted_arr
end

def merge_sort_sum(arr)
  num_elements = arr.length

  return arr if num_elements <= 1

  middle = num_elements / 2
  left_half = arr[0...middle]
  right_half = arr[middle..-1]

  sorted_left = merge_sort_sum(left_half)
  sorted_right = merge_sort_sum(right_half)

  merge_sum(sorted_left, sorted_right)
end

def merge_sum(left, right)
  sorted_arr = []
  left_index, right_index = 0, 0

  while left_index < left.length && right_index < right.length
    left_sum = left[left_index].sum + left[left_index].sum
    right_sum = right[right_index].sum + right[right_index].sum

    if left_sum <= right_sum
      sorted_arr << left[left_index]
      left_index += 1
    else
      sorted_arr << right[right_index]
      right_index += 1
    end
  end

  sorted_arr.concat(left[left_index..-1]) if left_index < left.length
  sorted_arr.concat(right[right_index..-1]) if right_index < right.length

  sorted_arr
end

  def merge_sort_sum(arr)
    num_elements = arr.length
  
    return arr if num_elements <= 1
  
    middle = num_elements / 2
    left_half = arr[0...middle]
    right_half = arr[middle..-1]
  
    sorted_left = merge_sort_sum(left_half)
    sorted_right = merge_sort_sum(right_half)
  
    merge_sum(sorted_left, sorted_right)
  end
  
  def merge_sum(left, right)
    sorted_arr = []
    left_index, right_index = 0, 0
  
    while left_index < left.length && right_index < right.length
      left_sum = left[left_index].sum + left[left_index].sum
      right_sum = right[right_index].sum + right[right_index].sum
  
      if left_sum <= right_sum
        sorted_arr << left[left_index]
        left_index += 1
      else
        sorted_arr << right[right_index]
        right_index += 1
      end
    end
  
    sorted_arr.concat(left[left_index..-1]) if left_index < left.length
    sorted_arr.concat(right[right_index..-1]) if right_index < right.length
  
    sorted_arr
  end


