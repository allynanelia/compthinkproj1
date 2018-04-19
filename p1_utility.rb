=begin

4 useful methods for checking your solution (layout):

(a) item_dimensions_correct?(box_no_of_rows, box_no_of_col, items, layout)
e.g.
    box_no_of_rows = 2 
    box_no_of_col = 5 
    items  = [[1, 1], [2, 1], [3, 5], [1, 3]]
    layout = [[0, 1, 3, 1, 3], [1, 0, 0, 0, 1], [3, 1, 0, 1, 2]]
    item_dimensions_correct?(box_no_of_rows, box_no_of_col, items, layout)
    
(b) no_overlapping_items?(box_no_of_rows, box_no_of_col, layout)
e.g.
    box_no_of_rows = 2 
    box_no_of_col = 5 
    layout = [[0, 1, 3, 1, 3], [1, 0, 0, 0, 1], [3, 1, 0, 1, 2]]
    no_overlapping_items?(box_no_of_rows, box_no_of_col, layout)

(c) print_layout_space_usage(box_no_of_rows, box_no_of_col, layout)
e.g. 
    box_no_of_rows = 2 
    box_no_of_col = 5  
    layout = [[0, 1, 3, 1, 3], [1, 0, 0, 0, 1], [3, 1, 0, 1, 2]] # (3 items: 0, 1 & 3) 
    print_layout_space(box_no_of_rows, box_no_of_col, layout)  
    
(d) print_layout(box_no_of_rows, box_no_of_col, layout)
e.g. 
    box_no_of_rows = 2 
    box_no_of_col = 5  
    layout = [[0, 1, 3, 1, 3], [1, 0, 0, 0, 1], [3, 1, 0, 1, 2]] # (3 items: 0, 1 & 3) 
    print_layout(box_no_of_rows, box_no_of_col, layout) 


=end


# --------------------------------------------------------------------
# checks if any item in your layout overlap. 
# returns true if there is no overlap between any items in layout
# returns an error message (string) if there is at least one cell occupied by two items.
# 
# box_no_of_rows: 5
# box_no_of_col : 2
# layout: [[0, 1, 3, 1, 3], [1, 0, 0, 0, 1], [3, 1, 0, 1, 2]]
def no_overlapping_items?(box_no_of_rows, box_no_of_col, layout)
  counter_array = get_counter_array(box_no_of_rows, box_no_of_col, layout)
     
  # check counter_array - should only contain 0s and 1s, otherwise there is an overlap
  if only_contains_0or1?(counter_array)
    return true
  else 
    return "Overlapping items detected in layout!"
  end
end

# checks if a (an array of any dimension) contains only 0s and 1s.
# returns true if so. false otherwise. 
def only_contains_0or1?(a)
  x = a.flatten
  x.each {|temp| return false if (temp!=0 and temp!=1)}
  return true
end

#
def get_counter_array(box_no_of_rows, box_no_of_col, layout)
  # create arrays
  temp_counter = Array.new(box_no_of_col, 0)
  counter_array = []    # 2D array of zeroes
  for i in 0...box_no_of_rows
    counter_array << temp_counter.clone
  end
  
  for i in 0...layout.length
    item_id = layout[i][0]
    item_r1 = layout[i][1]
    item_c1 = layout[i][2]
    item_r2 = layout[i][3]
    item_c2 = layout[i][4]
   
    # update counter_array
    for r in item_r1..item_r2
      for c in item_c1..item_c2
        counter_array[r][c] += 1
      end
    end
  end
  
  return counter_array
end

# --------------------------------------------------------------------
# check all item IDs against coordinates, and whether the items are within the box
# does not check for overlapping items.
# returns true if all items are of the within the box, and are of the correct dimensions
# returns error message (string) if there is an error
# 
# items:  [[1, 1], [2, 1], [3, 5], [1, 3]]
# layout: [[0, 1, 3, 1, 3], [1, 0, 0, 0, 1], [3, 1, 0, 1, 2]]
def item_dimensions_correct?(box_no_of_rows, box_no_of_col, items, layout)
  for i in 0...layout.length
    item_id = layout[i][0]
    item_r1 = layout[i][1]
    item_c1 = layout[i][2]
    item_r2 = layout[i][3]
    item_c2 = layout[i][4]
    
    item_w = items[item_id][0]
    item_l = items[item_id][1]
    
    if (item_r1 >= box_no_of_rows) or (item_r2 >= box_no_of_rows) or (item_c1 >= box_no_of_col) or (item_c2 >= box_no_of_col)
      return "Error: item #{item_id} --> jutting out of box"
    end
    
    result = size_match_coordinates?(item_r1, item_c1, item_r2, item_c2, item_w, item_l)
    if result.is_a?(String) # error
      return "Error: item #{item_id} --> #{result}"
    end
  end
  return true # no error
end




# e.g. size_match_coordinates?(0,2,2,3,2,3)
# returns true if OK
# returns error message (string) if not valid
def size_match_coordinates?(r1, c1, r2, c2, item_w, item_l)
  # check type
  if !r1.is_a?(Integer) or !c1.is_a?(Integer) or !r2.is_a?(Integer) or !c2.is_a?(Integer) or !item_w.is_a?(Integer) or !item_l.is_a?(Integer)
    return "Types of values passed in must be integers only"
  end
  
  # check validity of coordinates
  if r1>r2 or c1>c2
    return "r1 is bigger than r2, or c1 is bigger than c2. r1:#{r1}, r2:#{r2}, c1:#{c1}, c2:#{c2}"
  end
  
  # check fit
  item_longer_side = [item_w, item_l].max
  item_shorter_side = [item_w, item_l].min
  side1 = r2-r1+1
  side2 = c2-c1+1
  map_longer_side = [side1, side2].max
  map_shorter_side = [side1, side2].min
  
  if (map_longer_side == item_longer_side) and (map_shorter_side == item_shorter_side)
    return true
  else
    return "Item dimensions don't match coordinates. Item dimensions = #{item_longer_side} by #{item_shorter_side}. Rectangle dimensions = #{map_longer_side} by #{map_shorter_side}"
  end
end

# e.g. print_layout(2, 5, [[0, 1, 3, 1, 3], [1, 0, 0, 0, 1], [3, 1, 0, 1, 2]])  
# e.g. box_no_of_rows : 2  (width of box - number of rows)
#      box_no_of_col: 5  (length of box - number of columns)
#      layout: [[0, 1, 3, 1, 3], [1, 0, 0, 0, 1], [3, 1, 0, 1, 2]]  (3 items: 0, 1 & 3)
def print_layout(box_no_of_rows, box_no_of_col, layout)
  
  # create arrays
  temp_printout = Array.new(box_no_of_col, ".")
  printout_array = [] # 2d array of dots
  for i in 0...box_no_of_rows
    printout_array << temp_printout.clone
  end
  
  for i in 0...layout.length
    item_id = layout[i][0]
    item_r1 = layout[i][1]
    item_c1 = layout[i][2]
    item_r2 = layout[i][3]
    item_c2 = layout[i][4]
   
    # update printout_array
    for r in item_r1..item_r2
      for c in item_c1..item_c2
        printout_array[r][c] = item_id
      end
    end
  end
  
  # print array
  puts "printout (shows item ID):"
  print_array(printout_array) 
end

# e.g. print_layout_space(2, 5, [[0, 1, 3, 1, 3], [1, 0, 0, 0, 1], [3, 1, 0, 1, 2]])  
# e.g. box_no_of_rows : 2  (width of box - number of rows)
#      box_no_of_col: 5  (length of box - number of columns)
#      layout: [[0, 1, 3, 1, 3], [1, 0, 0, 0, 1], [3, 1, 0, 1, 2]]  (3 items: 0, 1 & 3)
def print_layout_space_usage(box_no_of_rows, box_no_of_col, layout)
  
  counter_array = get_counter_array(box_no_of_rows, box_no_of_col, layout)
     
  # print array
  print_array(counter_array)
end

# a is a 2D array
# e.g. if a is [[1, 2], [3, 4]]
# will print out:
#   1  2
#   3  4
def print_array(a)
  a.each{|x|
    x.each{|y| print_pad2 y}
    puts    
  }
  puts
end

def print_pad2(s)
  s = s.to_s
  if s.length == 1
    s = " " + s
  elsif s.length == 0
    s = "  "
  else 
    s = s[0...2]
  end
  
  print " " + s
end

# reads a CSV file and returns an array of strings - each line in the CSV file as one string
def read_file(file)
	lines = IO.readlines(file)
	if lines != nil
		for i in 0 .. lines.length-1
			lines[i] = lines[i].sub("\n","")
		end
		return lines[0..lines.length-1]
	end
	return nil
end


# retrieve only the item IDs from the answer, in sorted order
def get_itemID(answer)
  items_found = [] # the array items_found keeps track of items already placed into boxes.
  for i in 0...answer.length
    for j in 0...answer[i].length
      items_found << answer[i][j][0] # extract only item ID. answer[j][0] is item ID
    end
  end
  return items_found.sort
end

# returns true if error with items_found
def check_items(items_found, no_of_items)
  error = false
  if items_found.length != items_found.uniq.length # there are duplicated items in boxes
    puts "Error: There are duplicated items in your returned boxes. Each item should be packed into one box."
    error = true
  end
  if items_found.length != no_of_items
    puts "Error: The number of items in your returned boxes don't match the original number of items. All items must be packed into boxes."
    error = true
  end
  if items_found.last != (no_of_items - 1)
    puts "Error: The list of items in your returned boxes is incorrect"
    error = true
  end
  return error
end

# check the area and longer side of each item, to see if every item will fit into the standard box
# prints warning messages if any item is bigger in area or dimension than box - doesn't do anything else
def check_standard_box_size(box_no_of_rows, box_no_of_col, test_case)
  no_of_items = test_case.length
  standard_box_area = box_no_of_rows * box_no_of_col
  standard_box_longer_side = [box_no_of_rows, box_no_of_col].max
  
  for i in 0...no_of_items
    item_first_side  = test_case[i][0]
    item_second_side = test_case[i][1]
    item_longer_side = [item_first_side, item_second_side].max
    item_area = item_first_side * item_second_side
    
    if item_longer_side > standard_box_longer_side
      puts "*** WARNING ***: Item #{i} is longer than the standard box."
    end
    
    if item_area > standard_box_area
      puts "*** WARNING ***: Item #{i} has a bigger area than the standard box."
    end
  end
end