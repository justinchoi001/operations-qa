##Getting Started
This article assumes you've read through "What Is Watir." This guide will help you set up the necessary tools to start writing and running scripts using Watir.

##Installing Ruby
The first step is installing Ruby. The steps to install Ruby will depend on which OS you are running on your machine, but it should be fairly simple to look up the appropriate steps on the Internet.
###Linux
Install Ruby via the Terminal using _apt-get_ or _yum_ or whatever command your package manager uses. To verify that Ruby has been installed properly, open up Terminal and type:
``` html
ruby -v
```
_*There are some instances when the terminal window you used to install/update software doesn't reflect any changes. If you've installed/updated Ruby but you're getting an error or the version isn't correct, open a new terminal window and try again._
###OSX
I suggest using [Homebrew](http://brew.sh/) to install and update software you need on your Mac. Once you have Homebrew installed, you can install Ruby by typing:
``` html
brew install ruby
```
To verify that Ruby has been installed properly, open up Terminal and type:
``` html
ruby -v
```
_*There are some instances when the terminal window you used to install/update software via Homebrew doesn't reflect any changes. If you've installed/updated Ruby but you're getting an error or the version isn't correct, open a new terminal window and try again._
###Windows
Head over to the [Ruby's Downloads page](http://rubyinstaller.org/downloads) to grab the latest version. Download the .exe file and install the program. To verify that Ruby has been installed properly, open up Commmand Prompt and type:
``` html
ruby -v
```
###Notes
At the time of writing this article, I am currently on
``` html
ruby 2.2.1p85 (2015-02-26 revision 49769) [x86_64-darwin14]
```

##Installing RubyGems
RubyGems is Ruby's package manager and it's used to install specific Ruby programs/libraries (called _gems_). Your installation of Ruby comes with RubyGems, so you can check your version to make sure it's installed properly. 
``` html
gem -v
```
To update RubyGems, you can type:
``` html
gem update --system
```
###Notes
At the time of writing this article, I am currently on
``` html
2.4.6
```

##Installing Watir-Webdriver and Watir-Scroll
Finally, it's time to install Watir-webdriver, which is actually a gem! To install this, type:
``` html
gem install watir-webdriver
```
The Watir-webdriver gem contains some other libraries, so don't be alarmed when you see it the install process listing other tools. We also need to install Watir-scroll, which is another useful gem to help us with our scripts. To install this, type:
``` html
gem install watir-scroll
```
