##Getting Started
This article assumes you've read through "What Is Watir." This guide will help you set up the necessary tools to start writing and running scripts using Watir.

##Installing Ruby
The first step is installing Ruby. The steps to install Ruby will depend on which OS you are running on your machine, but it should be fairly simple to look up the appropriate steps on the Internet.
###Linux
You should know what to do. Install Ruby via the Terminal using _apt-get_ or _yum_ or whatever command your package manager uses. To verify that Ruby has been installed properly, open up Terminal and type:
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
