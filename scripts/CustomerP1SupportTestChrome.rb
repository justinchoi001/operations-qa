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
browser = Watir::Browser.new :chrome

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
browser.goto("https://www-uat.liferay.com/group/customer/support/-/support/ticket")

# wait for page load
Watir::Wait.until { browser.text.include? 'Please append ".broken" to your email address to login. (e.g. test@liferay.com.broken)' }

# access login elements by element name
browser.text_field(:name, "_58_login").set("gbyrne@calcas.com.broken")
browser.text_field(:name, "_58_password").set("test")
browser.button(:value, "Sign In").click

# wait for page load
Watir::Wait.until { browser.div(:text => "My Open Tickets").exists? }
puts "Assert that the user can log in successfully: PASS"

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
browser.span(:text => "+").fire_event :click
puts "Assert that the New Ticket button works: PASS"

# select california casualty as account
puts "\n"
Watir::Wait.until { browser.select_list(:name => "_2_WAR_osbportlet_accountEntryId").exists? }
browser.select_list(:name => "_2_WAR_osbportlet_accountEntryId").select_value("8153767")
puts "Assert that California Casualty is selected: PASS"

# click on portal production
puts "\n"
Watir::Wait.until { browser.element(:text => "Portal Production").visible? }
browser.element(:text => "Portal Production").click
puts "Assert that Portal Production is selected: PASS"

# click on continue without adding
puts "\n"
Watir::Wait.until { browser.button(:text => "Continue Without Adding", :index => 0).visible? }
browser.button(:text => "Continue Without Adding", :index => 0).click
puts "Assert that Continue Without Adding is selected: PASS"

# click on confirm
puts "\n"
Watir::Wait.until { browser.button(:text => "Confirm").visible? }
browser.button(:text => "Confirm").click
puts "Assert that Confirm is selected: PASS"

# select document library component
puts "\n"
Watir::Wait.until { browser.select_list(:name => "_2_WAR_osbportlet_component").visible? }
browser.select_list(:name => "_2_WAR_osbportlet_component").select_value("26004")
puts "Assert that the Document Library compontent is selected: PASS"

# fill out ticket details
puts "\n"
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
puts "Assert that the ticket details are completed: PASS"

# upload portal-ext
puts "\n"
unless File.exists? portalExt
	puts "Assert that the local portal-ext file exists: FAIL"
	browser.close
	puts "\n"
	abort("File: " + portalExt + "does not exist; aborted testing")
end
puts "Assert that the local portal-ext file exists: PASS"
puts "\n"
browser.file_field(:name => "_2_WAR_osbportlet_portal-ext").set portalExt
puts "Assert that the local portal-ext file is uploaded: PASS"

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
browser.file_field(:name => "_2_WAR_osbportlet_patch-level").set patchInfo
puts "Assert that the local patch-info file is uploaded: PASS"

# submit ticket
browser.button(:value => "Submit").fire_event :click

# check if ticket was successfully created
Watir::Wait.until { browser.element(:text => "Your request completed successfully.").exists? }
puts "\n"
if browser.text.include? "Your request completed successfully."
	puts "Assert that the ticket is successfully submitted: PASS"
else
	puts "Assert that the ticket was successfully submitted: FAIL"
end

# check if ticket status is incident reported
puts "\n"
if browser.element(:id => "_2_WAR_osbportlet_statusDisplay").text.eql? "INCIDENT REPORTED"
	puts "Assert that the ticket status is Incident Reported: PASS"
else
	puts "Assert that the ticket status is Incident Reported: FAIL"
end

# check if ticket resolution is n/a
puts "\n"
if browser.element(:id => "_2_WAR_osbportlet_resolutionLabel").text.eql? "N/A"
	puts "Assert that the ticket resolution is N/A: PASS"
else
	puts "Assert that the ticket resolution is N/A: FAIL"
end

# add comment
puts "\n"
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
puts "Assert that a comment with preformatted text is added: PASS"

# add another comment and save as draft
puts "\n"
Watir::Wait.until { browser.link(:text => "Add Comment").exists? }
browser.scroll.to browser.link(:text => "Add Comment")
browser.link(:text => "Add Comment").click
browser.textarea(:name, "_2_WAR_osbportlet_addCommentBody0").set("This is a draft")
browser.button(:value => "Save as Draft").click
puts "Assert that another comment is added and saved as a draft: PASS"

# edit the last comment and add attachment
puts "\n"
Watir::Wait.until { browser.span(:text => "Edit").exists? }
browser.link(:text => "Edit").click
unless File.exists? pictureAttachment
	puts "Assert that the local attachment file exists: PASS"
	browser.close
	puts "\n"
	abort("Invalid selection; aborted testing")
end
puts "Assert that the local image file exists: PASS"
puts "\n"
browser.file_field.set pictureAttachment
browser.scroll.to browser.button(:value => "Publish")
browser.button(:value => "Publish").click
puts "Assert that the local image file is uploaded and the last comment is published: PASS"

# close ticket
puts "\n"
browser.scroll.to browser.image(:title => "Preview")
browser.button(:value => "Close Ticket").click
browser.windows.last.use do
	browser.select_list(:name => "_2_WAR_osbportlet_resolution").select_value("32001")
	browser.textarea(:name, "_2_WAR_osbportlet_addCommentBody").set("This is a duplicate")
	browser.button(:value => "Close Ticket").click
end
Watir::Wait.until { browser.element(:text => "Your request completed successfully.").exists? }
if browser.text.include? "Your request completed successfully."
	puts "Assert that the ticket was successfully closed: PASS"
else
	puts "Assert that the ticket was successfully closed: FAIL"
end

# assert that the status is closed
puts "\n"
if browser.element(:id => "_2_WAR_osbportlet_statusDisplay").text.eql? "CLOSED"
	puts "Assert that the ticket status is Closed: PASS"
else
	puts "Assert that the ticket status is Closed: FAIL"
end

# assert that the resolution is duplicate
puts "\n"
if browser.element(:id => "_2_WAR_osbportlet_resolutionLabel").text.eql? "DUPLICATE"
	puts "Assert that the ticket resolution is Duplicate: PASS"
else
	puts "Assert that the ticket resolution is Duplicate: FAIL"
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
browser.scroll.to browser.image(:title => "Preview")
browser.button(:value => "Reopen").click
if browser.alert.exists?
	puts "Assert that a confirmation window is displayed when trying to reopen the ticket: PASS"
else
	puts "Assert that a confirmation window is displayed when trying to reopen the ticket: FAIL"
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
if browser.element(:id => "_2_WAR_osbportlet_statusDisplay").text.eql? "REOPENED"
	puts "Assert that the status is Reopened: PASS"
else
	puts "Assert that the status is Reopened: FAIL"
end

# assert that the resolution is N/A
puts "\n"
if browser.element(:id => "_2_WAR_osbportlet_resolutionLabel").text.eql? "N/A"
	puts "Assert that the resolution is N/A: PASS"
else
	puts "Assert that the resolution is N/A: FAIL"
end

# click for permalink
puts "\n"
permalink = browser.element(:id => "_2_WAR_osbportlet_ticketPermalink").value
puts "Permalink: " + permalink

# end message
puts "\n"
finishTime = Time.now
totalTime = finishTime - startTime
puts "TEST SUCCESSFUL"
puts "Total Time: " + totalTime.round.to_s + " seconds"

# ask user to end and close test
puts "Press ENTER to end and close the Customer P1 Support Automated Test"
STDOUT.flush
endTest = gets.chomp
if beginTest == ""
	browser.close
end
