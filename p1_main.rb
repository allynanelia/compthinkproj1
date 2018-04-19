module BinPacking

load "p1.rb"
load "p1_utility.rb"

puts "p1 ..."
# ----- get user input for data file ------
print "Enter box dimension (no of rows)    :"
box_no_of_rows = gets.to_i
print "Enter box dimension (no of columns) :"
box_no_of_col  = gets.to_i
print "Enter CSV file in data folder (e.g. data1.csv) :"
data_file_name = gets.chomp

# ----- prepare data ------

# read from data_file_name and store in test_cases
# each line in the CSV will be stored as an array in test_cases
test_cases = []
read_file("data/"+data_file_name).each{ |line|
  array = line.split(",").map(&:strip).map(&:to_i)

  array = array.each_slice(2).to_a
  test_cases << array
}
# at this point, test_cases is a 3D array which looks like this:
# [[[4, 8]], [[10, 8], [3, 2]]]
# test_cases[0] is [[4, 8]]          <-- 1st test case. 1 item
# test_cases[1] is [[10, 8], [3, 2]] <-- 2nd test case. 2 items

original_test_cases = Marshal.load(Marshal.dump(test_cases))  # make a clone

# ----- run test cases ------
answers = []
start_time = Time.now
for i in 0...test_cases.length
  puts "\nRunning test case #{i}..."
  answers[i] = box(box_no_of_rows, box_no_of_col, test_cases[i])
end
time_taken = Time.now - start_time
puts "Execution time #{'%.02f' % time_taken} seconds." # display time lapsed to 2 decimal places
puts

# ----- run test cases and show results ------
failed_test_cases = []
quality_total = 0
puts "-------------------------------------"

for i in 0...original_test_cases.length # for every test case
  puts "Test case ID: #{i} with box dimensions #{box_no_of_rows} x #{box_no_of_col}"
  puts "Your method returned: #{answers[i].inspect}"

  # checking code
  result = item_dimensions_correct?(box_no_of_rows, box_no_of_col, original_test_cases[i], answers[i])
  if result == true
    result = no_overlapping_items?(box_no_of_rows, box_no_of_col, answers[i])
  end

  # print result
  if result == true
    puts "RESULTS: passed. Quality (no. of items in box): #{answers[i].length} out of #{original_test_cases[i].length} items given"
  else
    puts "RESULTS: **** FAILED ****"
    puts "Error message: #{result}"
    failed_test_cases << i
  end

  quality = answers[i].length
  quality_total += quality
  puts "-------------------------------------"
end

# ----- print test case summary ------
puts "TEST SUMMARY:"
puts "No. of test cases: #{test_cases.length}. Read from \"#{data_file_name}\". Using box dimensions #{box_no_of_rows} rows by #{box_no_of_col} columns"
puts "Execution time #{'%.02f' % time_taken} seconds." # display time lapsed
if failed_test_cases.length == 0
  avg_quality = quality_total.to_f / test_cases.length
  puts "OVERALL RESULT: All test cases passed!!"
  puts "Average quality score for test cases : #{'%.02f' % avg_quality} (the higher the better)"
else
  puts "OVERALL RESULT: The following test cases failed: #{failed_test_cases.inspect}. You need to check your solution"
end
end
