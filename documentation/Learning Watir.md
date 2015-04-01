##Table of Contents
* [Getting Started](#Getting Started)
* [Quick Tip](#Quick Tip)
* [Using IRB](#Using IRB)
* [Loading Libraries](#Loading Libraries)
* [Browser](#Browser)
* [Locating Elements](#Locating Elements)

##Getting Started
This article assumes that you've read through the "What is Watir" and "Installation and Setup" guides and that you are comfortable writing in Ruby. This guide will not to teach you how to program in Ruby, but will provide a basic tutorial of popular commands in Watir.

##Quick Tip
The best way to get to know Watir-webdriver is to delve into its [API](http://www.rubydoc.info/gems/watir-webdriver). There you can find every class and its capabilities. 

##Using IRB
Don't forget to use your best friend in Ruby: IRB. IRB stands for _interactive Ruby_ and it's a great tool to interactively execute Ruby commands/expressions from your terminal. To start it up, simply open a terminal or command prompt window and type:
``` html
irb
```
You can use IRB to test commands that you'll need for your scripts. For example, when you're trying to find a web element on a page, you can try doing so in IRB first. When you've successfully grabbed the web element you can copy the correct command you used to your test script for permanent usage. This way, you don't need to execute your whole script every time to see if something works or fails.

_*When you're testing in IRB, you can enable autocompletion by using:_
``` html
require "irb/completion"
```

##Loading Libraries
I won't get into the nitty-gritty of the "require" method in Ruby. To load the files we need, you can include these for all of your tests:
``` html
require "watir-webdriver"
require "watir-scroll"
```
Having these at the top of each of your scripts will allow you to run commands from the Watir-webdriver and Watir-scroll API. 

##Browser
If you've used selenium-webdriver before, then some of these commands might look familiar to you. To start a new driver session, here are some examples (using "browser" as the variable name):
``` html
browser = Watir::Browser.new :firefox
browser = Watir::Browser.new :chrome
browser = Watir::Browser.new :ie
```
Those commands will open a new driver session in Firefox, Chrome, and IE, respectively. A new driver session is a blank browser session- so you'll have to direct it to a URL to begin. 

To navigate to a URL:
``` html
browser.goto("http://www.liferay.com")
```
To refresh the current page in the browser:
``` html
browser.refresh
```
To close the browser:
``` html
browser.close
```
Remember to visit the Watir-webdriver API to learn more about the [Browser](http://www.rubydoc.info/gems/watir-webdriver/Watir/Browser) class.

##Locating Elements
Time to consider the age-old philosophical debate regarding locating elements on a page: CSS vs XPath. Maybe you've heard both sides and don't know enough to have an opinion, or maybe you're only comfortable with one strategy, or maybe you don't care. The good news is that with Watir, it doesn't matter; it's really easy to interchange the way we locate elements. To quote the famous Kevin Hart, "Do you, boo boo. _Do you_, boo boo!"

Let's look at an example with the _TextField_ class. Here are some different ways to locate a _TextField_ on a page:
``` html
browser.text_field(:class => "class")
browser.text_field(:css => "css")
browser.text_field(:id => "id")
browser.text_field(:index => "index")
browser.text_field(:name => "name")
browser.text_field(:text => "text")
browser.text_field(:title => "title")
browser.text_field(:value => "value")
browser.text_field(:xpath => "xpath")
```
This is a good opportunity to examine the benefits to using Watir-webdriver and not just bare-bones selenium-webdriver. Watir-webdriver can do all of these, but selenium-webdriver can't do _:text_, _:title_, and _:value_. These are really useful, especially _:text_ because that will just search the page for a _TextField_ with that text. Watir-webdriver makes it super easy to locate elements. For more information about how to locate specific elements, visit this [helpful wiki by GitHub user cheezy](https://github.com/cheezy/page-object/wiki/Elements).

As you can see, it's easy to locate and identify elements using Watir-webdriver- _if_ you know what you're looking for. But let's face it, it just wouldn't be UAT if it were easy to locate and manipulate elements on a web page. You can see the text or button, but you just can't seem to grab it in your script so you can click on it. Here are a few tips that you can read up on that might save you same time and effort in the long run.
``` html
browser.text.include? "foo"
```
You can use this in IRB to see if Watir-webdriver can find the string "foo" on the page. It's a fairly simple _find_ method and is similar to the _.exists?_ method you can run on web elements using Watir, and will return true or false.
``` html
browser.div(:id => "foo").inner_html
```
There are two things to note with this tip. If you haven't already looked at the [API](http://www.rubydoc.info/gems/watir-webdriver) or at [cheezy's guide to Watir elements](https://github.com/cheezy/page-object/wiki/Elements), you'll realize that you can locate elements on the page using _div_ or _span_ or even just the general _element_. Why is this important? Sometimes the button you want to click on isn't really a button- maybe it's just tricky javascript/css overlay to hide the true link or whatever underneath it. That means _browser.button_ won't work because Watir doesn't recognize it as a button, so you'll need to find the true element another way: using _div_ or _span_ or _element_. The second tip follows right up after that. For objects of the _Element_ class in Watir, you can use _.inner_html_ to grab the whole HTML code of the element. From here you can sleuth around the surrounding code or delve deeper to finally locate and grab the true element you need. Remember, the goal is to find a robust way of locating elements so that your scripts don't break due to element identifier volatility. 
