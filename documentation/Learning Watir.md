##Table of Contents
* [Getting Started](#Getting Started)
* [Quick Tip](#Quick Tip)
* [Using IRB](#Using IRB)
* [Loading Libraries](#Loading Libraries)
* [Browser](#Browser)
* [](#)

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
Remember to visit the API to learn more about the [Browser](http://www.rubydoc.info/gems/watir-webdriver/Watir/Browser) class. 
