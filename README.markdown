<h1>Installation</h1>
This application has been packaged as a [ruby gem](http://en.wikipedia.org/wiki/RubyGems#Gems): to install, simply type:
```ruby
gem install yorkcmarker
```
Then, to run the application, simply type
```ruby
yorkcmarker
```
at the command prompt.

<h2>Prerequisites</h2>

You will need a Ruby Interpreter installed. Ruby installers are available for Windows, Linux and Mac. Follow the instructions here: http://www.ruby-lang.org/en/downloads/ to install Ruby.

The gem has been developed and tested against _ruby 1.9.3p194_. It should work with earlier versions, but it's recommended you use the same version (at the time of writing it's the latest).

<h3>Ubuntu Distros</h3>
You need to have the libgtk2.0-dev package installed - you can do this using:
```bash
sudo apt-get install libgtk2.0-dev
```
Thanks to Yuan for catching this!

<h1>Usage</h1>
Simply fill in your name, and the student number, and then check the boxes the students have marks for. Multiple marks are awarded by checking multiple boxes for the appropriate statement.

Pressing the <b>Save</b> button will save the details of the _Part_ you are currently editing. Partial files are created in subdirectories (_part_1_ and _part_2_) of the output directory you select when asked. When both Parts have been completed for a student, full and summary marksheets are created in the output directory.

Each part can be marked individually - for example, you can mark Part 1, close the program, come back and mark Part 2 another time, and the program will then generate the completed marksheets.

<h2>Currently tested on:</h2>
<h4>Ruby versions</h4>
Check with: 
```ruby
ruby -v
```
* ruby 1.9.3p194
* ruby 1.9.2-p290
* ruby 1.8.7

<h4>Operating Systems:</h4>
* Linux Mint 12 (see [_libgtk2.0-dev_](https://github.com/freefallertam/york-c-marking-assistant/edit/master/README.markdown#ubuntu-distros) requirement above)
* Ubuntu (see [_libgtk2.0-dev_](https://github.com/freefallertam/york-c-marking-assistant/edit/master/README.markdown#ubuntu-distros) requirement above)
* Microsoft Windows XP
* Microsoft Window Vista

If you install and run the gem on any other setups, let me know and I'll add to the above list.

<h1>Questions, Issues, Bug Reports</h1>
Either raise issues directly via GitHub, or direct all questions, issues and bug reports to Mat Alan Gilbert: mag501@york.ac.uk

<h3>Developer notes - the current code..</h3>
This code has just been thrown together - it grew from a CLI script written to save marking time. It's not clean, and it's not pretty, but is stable as far as it's been tested, and does the job. It does need a lot of refactoring and tidying up (this is on the TODO list!)!

_more information for developers coming soon.._
