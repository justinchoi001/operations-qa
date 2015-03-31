"Watir, _pronounced water_, is an open-source (BSD) family of Ruby libraries for automating web browsers. It allows you to write tests that are easy to read and maintain. It is simple and flexible."

"**Watir** stands for **W**eb **A**pplication **T**esting **i**n **R**uby..."

<h3>What Are We Using?</h3>
Watir actually has a whole host of tools that do a lot of different things. For our current purposes in Operations: QA, we'll be using **watir-webdriver** and **watir-scroll** for testing.  

<h3>What Is Watir-Webdriver?</h3>
Watir-webdriver uses a modernized version of the Watir API and is a wrapper around the Selenium 2.0 API (selenium-webdriver), and is written in Ruby. What does any of this mean? It means that we'll be using Ruby to write our tests, and it means that we can essentially think of ourselves as using Selenium 2.0 with some fancy Watir API calls to boost our efficiency and effectiveness. Watir-webdriver is also built from the HTML specification, so that means we should always be compatible with the current W3C specifications.

<h3>What Is Watir-Scroll?</h3>
Watir-scroll is a really great scrolling API built for Watir-webdriver. We'll need some scrolling API because one of Selenium's limitations is its inconsistent ability to find and manipulate web elements that are not in the browser's view. So even though the button or link or text exists and is visible and clickable, Selenium won't be able to do anything to it because it's not located on the screen. An easy solution for this issue is to scroll the desired web element into view using some scrolling API. It's relatively easy to scroll using Selenium's existing API, but Watir-scroll makes it even easier, so why not use it?

<h3>But Why Watir?</h3>
A few of our Operations: QA team members actually did some extensive research to find the best tool to help us automate tests for our Support Systems (e.g. LESA, Customer Portal, Patcher). All of our UAT tests were done manually, so it was important for us to find a robust software tool that could be used for all of our Support Systems (_eventually_). We strongly considered using POSHI, which is our in-house framework that Liferay QA uses, but it was too heavy, had too many dependencies, and was not built to test in multiple browsers. We wanted to stick with a solution that automated web browsers since that was all we needed and Watir was the best and most efficient choice for us.

_For more information about Watir, visit [their website](http://watir.com/)._
