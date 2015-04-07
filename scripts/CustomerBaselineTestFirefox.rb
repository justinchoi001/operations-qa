# load watir library
require "irb/completion"
require "watir-webdriver"
require "watir-scroll"

# constants
portalExt = "../resources/test-portal-ext.txt"
patchInfo = "../resources/test-patch-info.txt"
pictureAttachment = "../resources/test-image.png"
resultsTokenStart = "Showing "
resultsTokenEnd = " results."
ticketsTokenStart = "<div class=\"txt-h1 txt-b\"> "
ticketsTokenEnd = " </div>"

# open new browser to log into UA
puts "Attempting to open Firefox..."
browser = Watir::Browser.new :firefox
puts "Successfully opened Firefox"

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
Watir::Wait.until { browser.element(:text => "Portal Production").visible? }
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

# fill out ticket details
puts "\n"
puts "Attempting to fill out the ticket details..."
browser.text_field(:name, "_2_WAR_osbportlet_subject").set("Customer Basic Test")
browser.select_list(:name => "_2_WAR_osbportlet_systemStatus").select_value("1")
browser.textarea(:name, "_2_WAR_osbportlet_description").set("This is a customer test")
browser.select_list(:name => "_2_WAR_osbportlet_envLFR").select_value("20080")
# wait
browser.select_list(:name => "_2_WAR_osbportlet_envAS").option(:value => "27046").wait_until_present
browser.select_list(:name => "_2_WAR_osbportlet_envAS").select_value("27046")
browser.select_list(:name => "_2_WAR_osbportlet_envDB").select_value("28019")
browser.select_list(:name => "_2_WAR_osbportlet_envOS").select_value("30029")
browser.select_list(:name => "_2_WAR_osbportlet_envJVM").select_value("29002")
browser.select_list(:name => "_2_WAR_osbportlet_envBrowser").select_value("37001")
puts "Successfully filled out the ticket details"

# upload portal-ext
puts "\n"
unless File.exists? portalExt
	puts "Assert that the local patch level file exists: FAIL"
	browser.close
	puts "\n"
	abort("File: " + portalExt + "does not exist; aborted testing")
end
puts "Assert that the local patch level file exists: PASS"
puts "\n"
puts "Attempting to upload portal-ext file..."
browser.file_field(:name => "_2_WAR_osbportlet_portal-ext").set portalExt
puts "Successfully uploaded portal-ext file"

# upload patch-info
puts "\n"
unless File.exists? patchInfo
	puts "Assert that the local patch-info file exists: FAIL"
	browser.close
	puts "\n"
	abort("File: " + patchInfo + "does not exist; aborted testing")
end
puts "Assert that the local patch-info file exists: PASS"
puts "\n"
puts "Attempting to upload patch-info file..."
browser.file_field(:name => "_2_WAR_osbportlet_patch-level").set patchInfo
puts "Successfully uploaded patch-info file"

# submit ticket
puts "\n"
puts "Attempting to submit ticket..."
browser.button(:value => "Submit").fire_event :click

# check if ticket was successfully created
Watir::Wait.until { browser.element(:text => "Your request completed successfully.").exists? }
puts "\n"
if browser.text.include? "Your request completed successfully."
	puts "Assert that the ticket was successfully submitted: PASS"
else
	puts "Assert that the ticket was successfully submitted: FAIL"
end

# end message
puts "\n"
finishTime = Time.now
totalTime = finishTime - startTime
puts "TEST SUCCESSFUL"
puts "Total Time: " + totalTime.round.to_s + " seconds"

# ask user to end and close test
puts "\n"
puts "Press ENTER to end and close the Customer Baseline Automated Test"
STDOUT.flush
endTest = gets.chomp
if beginTest == ""
	browser.close
end
