# load watir library
require "irb/completion"
require "watir-webdriver"
require "watir-scroll"

# constants
portalExt = "/Users/gcliferay/test.txt"
patchLevel = "/Users/gcliferay/patch.txt"
pictureAttachment = "/Users/gcliferay/test.png"
resultsTokenStart = "Showing "
resultsTokenEnd = " results."
ticketsTokenStart = "<div class=\"txt-h1 txt-b\"> "
ticketsTokenEnd = " </div>"

# ask user to select browser
puts "Which browser would you like to run this test on?"
puts "\t Press ENTER to use Chrome [Default]"
puts "\t ENTER 2 to use Firefox"
# puts "\t ENTER 3 to use Safari"
# puts "\t ENTER 4 to use IE"
STDOUT.flush
browserType = gets.chomp

# open new browser to log into UA
if browserType == "1" || browserType == ""
	puts "Selected: Chrome \n \n"
	puts "Attempting to open Chrome..."
	browser = Watir::Browser.new :chrome
	puts "Successfully opened Chrome"
elsif browserType == "2"
	puts "Selected: Firefox \n \n"
	puts "Attempting to open Firefox..."
	browser = Watir::Browser.new :firefox
	puts "Successfully opened Firefox"
# elsif browserType == "3"
# 	puts "Selected: Safari \n \n"
# 	puts "Attempting to open Safari..."
# 	browser = Watir::Browser.new :safari
# 	puts "Successfully opened Safari"
# elsif browserType == "4"
# 	puts "Selected: IE \n \n"
# 	puts "Attempting to open IE..."
# 	browser = Watir::Browser.new :ie
# 	puts "Successfully opened IE"
else
	puts "Invalid selection; using Chrome \n \n"
	puts "Attempting to open Chrome..."
	browser = Watir::Browser.new :chrome
	puts "Successfully opened Chrome"
end

# ask user to begin test
puts "\n"
puts "Press ENTER to begin the Customer Baseline Automated Test"
STDOUT.flush
beginTest = gets.chomp
unless beginTest == ""
	browser.close
	puts "\n"
	abort("Invalid selection; aborted testing")
end

# start time
startTime = Time.now

# go to LESA home page
puts "Attempting to navigate to LESA UAT..."
browser.goto("https://www-uat.liferay.com/group/customer/support/-/support/ticket")