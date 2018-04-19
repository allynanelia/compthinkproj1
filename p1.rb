# p1.rb

# Name: Tan Li Shi Alicia Nanelia
# Section: G3

# Takes in:
#   - no of rows of box
#   - no of columns of box
#   - 2D array of items' dimensions
#   e.g. box(2, 5, [[1, 1], [2, 1], [3, 5], [1, 3]])
# Returns:
#   - proposed layout of items in the box in this format: [[item ID, r1, c1, r2, c2], [item ID, r1, c1, r2, c2]...]
#   e.g. [[0, 1, 3, 1, 3], [1, 0, 0, 0, 1], [3, 1, 0, 1, 2]]
#   The order of the items in the returned array does not matter.
#
def box(_box_no_of_rows, _box_no_of_col, items)
    answer = []

    # sort the array of each item so that bigger number will be the first element(height)
    items.each do |i|
        #    if i[1] > i[0]
        #        i[0],i[1] = i[1], i[0]
        #    end
        i << 'false'
    end

    # store all items in a hash map with the item ID as key
    hashMapItems = {} # initialising my hashmap

    counter = 0
    for i in items
        hashMapItems.store(counter, i)
        counter += 1
    end

    # sort items in decending order based on area of item
    # v[0] = height
    # v[1] = width
    @sortedItemsHashMap = Hash[hashMapItems.sort_by { |_k, v| v[0] * v[1] }]

    # fit items into box

    @free_rectangles = []
    firstRectangle = {} # initialising my hashmap
    firstRectangle[:x] = 0
    firstRectangle[:y] = 0
    firstRectangle[:width] = _box_no_of_col
    firstRectangle[:height] = _box_no_of_rows
    @free_rectangles << firstRectangle # an array of hashmaps


        @sortedItemsHashMap.each do |k, v|

            if insert(k, v) # returns [height,width,isPacked,x,y,rx,ry]
                answer.push([k, @boxes.last[4], @boxes.last[3], @boxes.last[6], @boxes.last[5]])
            end

        end


    # always returns only 1 item (the 1st item) at upper-left corner of box
    # answer = [[0, 0, 0, item_rows-1, item_col-1]]

    answer
end

def insert(k, item)
    @boxes = []

    return false if item[2] == 'true'

    find_position_for_new_node!(item, @free_rectangles)
    return false unless item[2] == 'true'

    num_rectangles_to_process = @free_rectangles.size
    i = 0
    while i < num_rectangles_to_process
        if split_free_node(@free_rectangles[i], item)
            @free_rectangles.delete_at(i)
            num_rectangles_to_process -= 1
        else
            i += 1
        end
    end

    prune_free_list

    @boxes << item
    @sortedItemsHashMap.delete(k)

    true
      end

def calculate_score(free_rect, rect_width, rect_height) # free_rect is a hashmap
    # tetris method of storing items in the box, start at the bottom left
    top_side_y = free_rect[:y] + rect_height
    Score.new(top_side_y, free_rect[:x])

end



def find_position_for_new_node!(item, free_rectangles)
    # Stores the penalty score of the best rectangle placement - bigger=worse, smaller=better.
    best_score = Score.new #starts with score1=maxInt & score2=maxInt
    width = item[1]
    height = item[0]

    free_rectangles.each do |free_rect| # free_react is a hashmap
        # rotating to see which is the best position to place item
        try_place_rect_in(free_rect, item, width, height, best_score)
        try_place_rect_in(free_rect, item, height, width, best_score)
    end

    best_score
end

def try_place_rect_in(free_rect, item, rect_width, rect_height, best_score)
    if free_rect[:width] >= rect_width && free_rect[:height] >= rect_height #item can fit into the rectangle

            score = calculate_score(free_rect, rect_width, rect_height) #calculate score

        if score > best_score #if score is larger than best score use this

            item[1] = rect_width
            item[0] = rect_height
            item[3] = free_rect[:x]
            item[4] = free_rect[:y]
            item[5] = free_rect[:x] + rect_width - 1
            item[6] = free_rect[:y] + rect_height - 1
            item[2] = 'true'
            best_score.assign(score) # score becomes new best score
        end
    end
end

def split_free_node(free_node, used_node) # used_node is the item, free_node is a hashmap
    # Test with SAT if the rectangles even intersect.
    if used_node[3] >= free_node[:x] + free_node[:width] ||
       used_node[3] + used_node[1] <= free_node[:x] ||
       used_node[4] >= free_node[:y] + free_node[:height] ||
       used_node[4] + used_node[0] <= free_node[:y]
        return false
    end

    # Placing used_node into freeRect results in an L-shaped free area, which must be split into
    # two disjoint rectangles. This can be achieved with by splitting the L-shape using a single line.
    # We have two choices: horizontal or vertical.

    try_split_free_node_vertically(free_node, used_node)

    try_split_free_node_horizontally(free_node, used_node)

    true
end

def try_split_free_node_vertically(free_node, used_node) # used_node is the item, free_node is a hashmap
    if used_node[3] < free_node[:x] + free_node[:width] && used_node[3] + used_node[1] > free_node[:x]
        try_leave_free_space_at_top(free_node, used_node)
        try_leave_free_space_at_bottom(free_node, used_node)
    end
end

def try_leave_free_space_at_top(free_node, used_node) # used_node is the item, free_node is a hashmap
    if used_node[4] > free_node[:y] && used_node[4] < free_node[:y] + free_node[:height]
        new_node = free_node.clone
        new_node[:height] = used_node[4] - new_node[:y]

        @free_rectangles << new_node

    end
end

def try_leave_free_space_at_bottom(free_node, used_node)
    if used_node[4] + used_node[0] < free_node[:y] + free_node[:height]
        new_node = free_node.clone
        new_node[:y] = used_node[4] + used_node[0]
        new_node[:height] = free_node[:y] + free_node[:height] - (used_node[4] + used_node[0])

        @free_rectangles << new_node
    end
end

def try_split_free_node_horizontally(free_node, used_node)
    if used_node[4] < free_node[:y] + free_node[:height] && used_node[4] + used_node[0] > free_node[:y]
        try_leave_free_space_on_left(free_node, used_node)
        try_leave_free_space_on_right(free_node, used_node)
    end
end

def try_leave_free_space_on_left(free_node, used_node)
    if used_node[3] > free_node[:x] && used_node[3] < free_node[:x] + free_node[:width]
        new_node = free_node.clone
        new_node[:width] = used_node[3] - new_node[:x]

        @free_rectangles << new_node
    end
end

def try_leave_free_space_on_right(free_node, used_node)
    if used_node[3] + used_node[1] < free_node[:x] + free_node[:width]
        new_node = free_node.clone
        new_node[:x] = used_node[3] + used_node[1]

        new_node[:width] = free_node[:x] + free_node[:width] - (used_node[3] + used_node[1])

        @free_rectangles << new_node

    end
end

# Goes through the free rectangle list and removes any redundant entries.
def prune_free_list
    i = 0
    while i < @free_rectangles.size
        j = i + 1
        while j < @free_rectangles.size
            if is_contained_in?(@free_rectangles[i], @free_rectangles[j])
                @free_rectangles.delete_at(i)
                i -= 1
                break
            end
            if is_contained_in?(@free_rectangles[j], @free_rectangles[i])
                @free_rectangles.delete_at(j)
            else
                j += 1
            end
        end
        i += 1
    end
end

def is_contained_in?(rect_a, rect_b)
    rect_a[:x] >= rect_b[:x] && rect_a[:y] >= rect_b[:y] &&
        rect_a[:x] + rect_a[:width] <= rect_b[:x] + rect_b[:width] &&
        rect_a[:y] + rect_a[:height] <= rect_b[:y] + rect_b[:height]
    end

class Score
    include Comparable

    MAX_INT = (2**(0.size * 8 - 2) - 1)

    attr_reader :score_1, :score_2

    def self.new_blank
        new
    end

    def initialize(score_1 = nil, score_2 = nil)
        @score_1 = score_1 || MAX_INT
        @score_2 = score_2 || MAX_INT
    end

    def <=>(other)
        if score_1 > other.score_1 || (score_1 == other.score_1 && score_2 > other.score_2)
            -1
        elsif score_1 < other.score_1 || (score_1 == other.score_1 && score_2 < other.score_2)
            1
        else
            0
        end
    end

    def assign(other)
        @score_1 = other.score_1
        @score_2 = other.score_2
    end
end
