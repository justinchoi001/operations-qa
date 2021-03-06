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
Watir::Wait.until { browser.div(:class => "fb-like fb_iframe_widget").present? }			# use this to wait for full page load
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
Watir::Wait.until { browser.div(:class => "fb-like fb_iframe_widget").present? }			# use this to wait for full page load
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
Watir::Wait.until { browser.div(:class => "fb-like fb_iframe_widget").present? }			# use this to wait for full page load
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

# click on the "+" symbol; want to click on "new ticket"
puts "\n"
browser.span(:text => "+").fire_event :click
puts "Assert that the New Ticket button works: PASS"

# select account
puts "\n"
Watir::Wait.until { browser.select_list(:name => "_2_WAR_osbportlet_accountEntryId").visible? }
browser.select_list(:name => "_2_WAR_osbportlet_accountEntryId").select_value("12948019")
puts "Assert that the Document Library compontent is selected: PASS"

# click on portal production
puts "\n"
Watir::Wait.until { browser.element(:text => "Portal Production").visible? }
browser.element(:text => "Portal Production").click
puts "Assert that Portal Production is selected: PASS"

# click on continue without adding
puts "\n"
Watir::Wait.until { browser.button(:text => "Continue Without Adding", :index => 2).visible? }
browser.button(:text => "Continue Without Adding", :index => 2).click
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
browser.text_field(:name, "_2_WAR_osbportlet_subject").set("CSE Basic Test")
browser.select_list(:name => "_2_WAR_osbportlet_systemStatus").select_value("1")
browser.textarea(:name, "_2_WAR_osbportlet_description").set("This is a CSE test")
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
puts "\n"
Watir::Wait.until { browser.element(:text => "Your request completed successfully.").exists? }
if browser.text.include? "Your request completed successfully."
	puts "Assert that the ticket is successfully submitted: PASS"
else
	puts "Assert that the ticket was successfully submitted: FAIL"
end

# check if public tab is displayed
puts "\n"
Watir::Wait.until { browser.link(:class => "aui-tab-label").exists? }
if browser.link(:class => "aui-tab-label", :index => 0).text.include? "Public"
	puts "Assert that the Public tab is displayed: PASS"
else
	puts "Assert that the Public tab is displayed: FAIL"
end

# check if workers tab is displayed
puts "\n"
Watir::Wait.until { browser.link(:class => "aui-tab-label").exists? }
if browser.link(:class => "aui-tab-label", :index => 1).text.include? "Workers"
	puts "Assert that the Workers tab is displayed: PASS"
else
	puts "Assert that the Workers tab is displayed: FAIL"
end

# check if liferay tab is displayed
puts "\n"
Watir::Wait.until { browser.link(:class => "aui-tab-label").exists? }
if browser.link(:class => "aui-tab-label", :index => 2).text.include? "Liferay"
	puts "Assert that the Liferay tab is displayed: PASS"
else
	puts "Assert that the Liferay tab is displayed: FAIL"
end

# check if history tab is displayed
puts "\n"
Watir::Wait.until { browser.link(:class => "aui-tab-label").exists? }
if browser.link(:class => "aui-tab-label", :index => 4).text.include? "History"
	puts "Assert that the History tab is displayed: PASS"
else
	puts "Assert that the History tab is displayed: FAIL"
end

# check if solutions tab is displayed
puts "\n"
Watir::Wait.until { browser.link(:class => "aui-tab-label").exists? }
if browser.link(:class => "aui-tab-label", :index => 5).text.include? "Solutions"
	puts "Assert that the Solutions tab is displayed: PASS"
else
	puts "Assert that the Solutions tab is displayed: FAIL"
end

# add the first comment
puts "\n"
Watir::Wait.until { browser.link(:text => "Add Comment").exists? }
browser.scroll.to browser.link(:text => "Add Comment")
browser.link(:text => "Add Comment").click
browser.textarea(:name, "_2_WAR_osbportlet_addCommentBody0").set("This is the first comment")
browser.button(:value => "Reply").click
browser.scroll.to :top
Watir::Wait.until { browser.element(:text => "Your request completed successfully.").exists? }
if browser.text.include? "Your request completed successfully."
	puts "Assert that the first comment was published successfully: PASS"
else
	puts "Assert that the first comment was published successfully: FAIL"
end

# # add the second comment
# puts "\n"
# browser.scroll.to browser.link(:text => "Add Comment")
# browser.link(:text => "Add Comment").click
# browser.textarea(:name, "_2_WAR_osbportlet_addCommentBody0").set("This is the second comment")
# browser.button(:value => "Save as Draft").click
# browser.scroll.to :top
# Watir::Wait.until { browser.element(:text => "Your request completed successfully.").exists? }
# if browser.text.include? "Your request completed successfully."
# 	puts "Assert that the first comment was published successfully: PASS"
# else
# 	puts "Assert that the first comment was published successfully: FAIL"
# end

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
