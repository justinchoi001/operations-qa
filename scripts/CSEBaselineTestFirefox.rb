# load watir library
require "irb/completion"
require "watir-webdriver"
require "watir-scroll"

# constants
repo = File.expand_path("..", File.dirname(__FILE__))
portalExt = repo + "/resources/test-portal-ext.txt"
patchInfo = repo + "/resources/test-patch-info.txt"
pictureAttachment = repo + "/resources/test-image.png"
resultsTokenStart = "Showing "
resultsTokenEnd = " result"
ticketsTokenStart = "<div class=\"txt-h1 txt-b\"> "
ticketsTokenEnd = " </div>"

# open new browser to log into UA
browser = Watir::Browser.new :firefox

# ask user to begin test
puts "\n"
puts "Press ENTER to begin the CSE Baseline Automated Test"
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
browser.goto("https://www-uat.liferay.com/group/customer/support/-/support/ticket")

# wait for page load
Watir::Wait.until { browser.text.include? 'Please append ".broken" to your email address to login. (e.g. test@liferay.com.broken)' }

# access login elements by element name
browser.text_field(:name, "_58_login").set("brian.suh@liferay.com.broken")
browser.text_field(:name, "_58_password").set("test")
browser.button(:value, "Sign In").click

# wait for page load
Watir::Wait.until { browser.div(:text => "My Open Tickets").exists? }
puts "Assert that the user can access LESA: PASS"

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
inProgress = browser.div(:text => "In Progress")
inProgress.fire_event :click
searchResultsHTML = browser.div(:class => "search-results").inner_html
searchResultsCount = searchResultsHTML[/#{resultsTokenStart}(.*?)#{resultsTokenEnd}/m, 1]
inProgressHTML = inProgress.parent.inner_html
inProgressCount = inProgressHTML[/#{ticketsTokenStart}(.*?)#{ticketsTokenEnd}/m, 1]
puts "\n"
if inProgressCount == searchResultsCount
	puts "Assert that the In Progress count [" + inProgressCount + "] matches number of search results [" + searchResultsCount + "]: PASS"
else
	puts "Assert that the In Progress count [" + inProgressCount + "] matches number of search results [" + searchResultsCount + "]: FAIL"
end

# end message
puts "\n"
finishTime = Time.now
totalTime = finishTime - startTime
puts "TEST SUCCESSFUL"
puts "Total Time: " + totalTime.round.to_s + " seconds"

# ask user to end and close test
puts "Press ENTER to end and close the CSE Baseline Automated Test"
STDOUT.flush
endTest = gets.chomp
if beginTest == ""
	browser.close
end
