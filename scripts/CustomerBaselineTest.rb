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

# wait for page load
Watir::Wait.until { browser.text.include? 'Please append ".broken" to your email address to login. (e.g. test@liferay.com.broken)' }

# access login elements by element name
puts "Attempting to log into LESA UAT..."
browser.text_field(:name, "_58_login").set("margaret_wong@abacus.com.sg.broken")
browser.text_field(:name, "_58_password").set("test")
browser.button(:value, "Sign In").click

# wait for page load
Watir::Wait.until { browser.div(:text => "My Open Tickets").exists? }
puts "Successfully logged into LESA UAT"
puts "Successfully navigated to LESA UAT"

# check if my open tickets count and results match
myOpenTickets = browser.div(:text => "My Open Tickets")
myOpenTickets.fire_event :click
searchResultsHTML = browser.div(:class => "search-results").inner_html
searchResultsCount = searchResultsHTML[/#{resultsTokenStart}(.*?)#{resultsTokenEnd}/m, 1]
myOpenTicketsHTML = myOpenTickets.parent.inner_html
myOpenTicketsCount = myOpenTicketsHTML[/#{ticketsTokenStart}(.*?)#{ticketsTokenEnd}/m, 1]
puts "\n"
if myOpenTicketsCount == searchResultsCount
	puts "Assert that the My Open Tickets count [" + myOpenTicketsCount + "] matches number of search results [" + searchResultsCount + "]: PASS"
else
	puts "Assert that the My Open Tickets count [" + myOpenTicketsCount + "] matches number of search results [" + searchResultsCount + "]: FAIL"
end

# check if need response count and results match
needResponse = browser.div(:text => "Need Response")
needResponse.fire_event :click
searchResultsHTML = browser.div(:class => "search-results").inner_html
searchResultsCount = searchResultsHTML[/#{resultsTokenStart}(.*?)#{resultsTokenEnd}/m, 1]
needResponseHTML = needResponse.parent.inner_html
needResponseCount = needResponseHTML[/#{ticketsTokenStart}(.*?)#{ticketsTokenEnd}/m, 1]
puts "\n"
if needResponseCount == searchResultsCount
	puts "Assert that the Need Response count [" + needResponseCount + "] matches number of search results [" + searchResultsCount + "]: PASS"
else
	puts "Assert that the Need Response count [" + needResponseCount + "] matches number of search results [" + searchResultsCount + "]: FAIL"
end

# check if in progress count and results match
feedbackWaiting = browser.div(:text => "Feedback Waiting")
feedbackWaiting.fire_event :click
searchResultsHTML = browser.div(:class => "search-results").inner_html
searchResultsCount = searchResultsHTML[/#{resultsTokenStart}(.*?)#{resultsTokenEnd}/m, 1]
feedbackWaitingHTML = feedbackWaiting.parent.inner_html
feedbackWaitingCount = feedbackWaitingHTML[/#{ticketsTokenStart}(.*?)#{ticketsTokenEnd}/m, 1]
puts "\n"
if feedbackWaitingCount == searchResultsCount
	puts "Assert that the Feedback Waiting count [" + feedbackWaitingCount + "] matches number of search results [" + searchResultsCount + "]: PASS"
else
	puts "Assert that the Feedback Waiting count [" + feedbackWaitingCount + "] matches number of search results [" + searchResultsCount + "]: FAIL"
end

# click on the "+" symbol; want to click on "new ticket"
puts "\n"
puts "Creating a new ticket..."
browser.span(:text => "+").fire_event :click

# click on portal production
puts "\n"
puts "Attempting to select Portal Production..."
Watir::Wait.until { browser.link(:text => "Portal Production").visible? }
browser.element(:text => "Portal Production").click
puts "Successfully selected Portal Production"

# click on continue without adding
puts "\n"
puts "Attempting to select Continue Without Adding..."
Watir::Wait.until { browser.button(:text => "Continue Without Adding", :index => 1).visible? }
browser.button(:text => "Continue Without Adding", :index => 1).click
puts "Successfully selected Continue Without Adding"

# click on confirm
puts "\n"
puts "Attempting to select Confirm..."
Watir::Wait.until { browser.button(:text => "Confirm").visible? }
browser.button(:text => "Confirm").click
puts "Successfully selected Confirm"

# select document library component
puts "\n"
puts "Attempting to select Document Library component..."
browser.select_list(:name => "_2_WAR_osbportlet_component").select_value("26004")
puts "Successfully selected Document Library component"
