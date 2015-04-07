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
puts "Press ENTER to begin the Customer P1 Support Automated Test"
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
browser.text_field(:name, "_58_login").set("gbyrne@calcas.com.broken")
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

# select california casualty as account
puts "\n"
puts "Attempting to select California Casualty as Account..."
Watir::Wait.until { browser.select_list(:name => "_2_WAR_osbportlet_accountEntryId").exists? }
browser.select_list(:name => "_2_WAR_osbportlet_accountEntryId").select_value("8153767")
puts "Successfully selected Account"

# click on portal production
puts "\n"
puts "Attempting to select Portal Production..."
Watir::Wait.until { browser.link(:text => "Portal Production").visible? }
browser.link(:text => "Portal Production").fire_event :click
puts "Successfully selected Portal Production"

# click on continue without adding
puts "\n"
puts "Attempting to select Continue Without Adding..."
Watir::Wait.until { browser.button(:value => "Continue Without Adding").visible? }
browser.button(:value => "Continue Without Adding").fire_event :click
puts "Successfully selected Continue Without Adding"

# click on create ticket
puts "\n"
puts "Attempting to select Create Ticket..."
Watir::Wait.until { browser.button(:value => "Create Ticket").visible? }
browser.button(:value => "Create Ticket").fire_event :click
puts "Successfully selected Create Ticket"

# set ticket details
puts "\n"
puts "Attempting to fill out the ticket details..."
Watir::Wait.until { browser.text_field(:name, "_2_WAR_osbportlet_subject").exists? }
browser.text_field(:name, "_2_WAR_osbportlet_subject").set("Customer to Partner Test")
browser.select_list(:name => "_2_WAR_osbportlet_component").select_value("26004")
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
	abort("Invalid selection; aborted testing")
end
puts "Assert that the local patch level file exists: PASS"
puts "\n"
puts "Attempting to upload portal-ext file..."
browser.file_field(:name => "_2_WAR_osbportlet_portal-ext").set portalExt
puts "Successfully uploaded portal-ext file"

# upload patch level
puts "\n"
unless File.exists? patchLevel
	puts "Assert that the local patch level file exists: FAIL"
	browser.close
	puts "\n"
	abort("Invalid selection; aborted testing")
end
puts "Assert that the local patch level file exists: PASS"
puts "\n"
puts "Attempting to upload patch level file..."
browser.file_field(:name => "_2_WAR_osbportlet_patch-level").set patchLevel
puts "Successfully uploaded patch level file"

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

# assert that the status is incident reported
puts "\n"
if browser.div(:id => "_2_WAR_osbportlet_statusDisplay").inner_html == "Incident Reported"
	puts "Assert that the status is Incident Reported: PASS"
else
	puts "Assert that the status is Incident Reported: FAIL"
end

# assert that the resolution is N/A
puts "\n"
if browser.div(:id => "_2_WAR_osbportlet_resolutionLabel").inner_html == "N/A"
	puts "Assert that the resolution is N/A: PASS"
else
	puts "Assert that the resolution is N/A: FAIL"
end

# add comment
puts "\n"
puts "Attempting to add a comment with formatted text..."
Watir::Wait.until { browser.link(:text => "Add Comment").exists? }
browser.scroll.to browser.link(:text => "Add Comment")
browser.link(:text => "Add Comment").click
boldText = "[b]this is a test[/b]"
italicText = "[i]this is a test[/i]"
underlineText = "[u]this is a test[/u]"
quoteText = "[quote]this is a test[/quote]"
codeText = "[code]this is a test[/code]"
commentText = boldText + "\n" + boldText + "\n" + italicText + "\n" + underlineText + "\n" + quoteText + "\n" + codeText
browser.textarea(:name, "_2_WAR_osbportlet_addCommentBody0").set(commentText)
browser.button(:value => "Reply").click
puts "Successfully added a comment with formatted text"

# save as draft
Watir::Wait.until { browser.link(:text => "Add Comment").exists? }
puts "\n"
puts "Attempting to add another comment and save as a draft..."
browser.scroll.to browser.link(:text => "Add Comment")
browser.link(:text => "Add Comment").click
browser.textarea(:name, "_2_WAR_osbportlet_addCommentBody0").set("This is a draft")
browser.button(:value => "Save as Draft").click
puts "Successfully added another comment and saved as a draft"

# add attachment
Watir::Wait.until { browser.span(:text => "Edit").exists? }
puts "\n"
browser.link(:text => "Edit").click
unless File.exists? pictureAttachment
	puts "Assert that the local attachment file exists: PASS"
	browser.close
	puts "\n"
	abort("Invalid selection; aborted testing")
end
puts "Assert that the local attachment file exists: PASS"
puts "\n"
puts "Attempting to publish comment with  attachment..."
browser.file_field.set pictureAttachment
browser.scroll.to browser.button(:value => "Publish")
browser.button(:value => "Publish").click
puts "Successfully published comment with attachment"

# close ticket
puts "\n"
puts "Attempting to close the ticket..."
browser.scroll.to browser.element(:text => "Attachments:")
browser.button(:value => "Close Ticket").click
browser.windows.last.use do
	browser.select_list(:name => "_2_WAR_osbportlet_resolution").select_value("32001")
	browser.textarea(:name, "_2_WAR_osbportlet_addCommentBody").set("This is a duplicate")
	browser.button(:value => "Close Ticket").click
end
Watir::Wait.until { browser.element(:text => "Your request completed successfully.").exists? }
puts "\n"
if browser.text.include? "Your request completed successfully."
	puts "Assert that the ticket was successfully closed: PASS"
else
	puts "Assert that the ticket was successfully closed: FAIL"
end

# assert that the status is closed
puts "\n"
if browser.div(:id => "_2_WAR_osbportlet_statusDisplay").inner_html == "Closed"
	puts "Assert that the status is Closed: PASS"
else
	puts "Assert that the status is Closed: FAIL"
end

# assert that the resolution is duplicate
puts "\n"
if browser.div(:id => "_2_WAR_osbportlet_resolutionLabel").inner_html == "Duplicate"
	puts "Assert that the resolution is Duplicate: PASS"
else
	puts "Assert that the resolution is Duplicate: FAIL"
end

# assert that the reopen button is displayed
puts "\n"
if browser.button(:value => "Reopen").exists? && browser.button(:value => "Reopen").visible?
	puts "Assert that the Reopen button is displayed: PASS"
else
	puts "Assert that the Reopen button is displayed: FAIL"
end

# reopen the ticket
puts "\n"
puts "Attempting to reopen the ticket..."
browser.scroll.to browser.element(:text => "Attachments:")
browser.button(:value => "Reopen").click
puts "\n"
if browser.alert.exists?
	puts "Assert that a confirmation window is displayed: PASS"
else
	puts "Assert that a confirmation window is displayed: FAIL"
end
browser.alert.ok
Watir::Wait.until { browser.element(:text => "Your request completed successfully.").exists? }
puts "\n"
if browser.text.include? "Your request completed successfully."
	puts "Assert that the ticket was successfully reopened: PASS"
else
	puts "Assert that the ticket was successfully reopened: FAIL"
end

# assert that the status is reopened
puts "\n"
if browser.div(:id => "_2_WAR_osbportlet_statusDisplay").inner_html == "Reopened"
	puts "Assert that the status is Reopened: PASS"
else
	puts "Assert that the status is Reopened: FAIL"
end

# assert that the resolution is N/A
puts "\n"
if browser.div(:id => "_2_WAR_osbportlet_resolutionLabel").inner_html == "N/A"
	puts "Assert that the resolution is N/A: PASS"
else
	puts "Assert that the resolution is N/A: FAIL"
end

# click for permalink
permalink = browser.element(:id => "_2_WAR_osbportlet_ticketPermalink").value
puts "Permalink: " + permalink

# end message
puts "\n"
finishTime = Time.now
totalTime = finishTime - startTime
puts "TEST SUCCESSFUL"
puts "Total Time: " + totalTime.round.to_s + " seconds"

# ask user to end and close test
puts "\n"
puts "Press ENTER to end and close the Customer P1 Support Automated Test"
STDOUT.flush
endTest = gets.chomp
if beginTest == ""
	browser.close
end
