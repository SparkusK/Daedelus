# README

Since I was the only dev, I didn't bother updating the readme file. I'm only updating this now to show a bit of guidance and provide some commentary. Some of the defaults:

* Ruby version
  I used Ruby v2.4.1 and Rails 5.1.6 for this app.

* System dependencies
  It's hosted on Heroku and uses Postgres. I think that most of the dependencies should be listed in the gemfile, but I've also included webpacker and yarn in here so that might complicate things. Not sure!
  I can try spin up a new Heroku instance if you'd like to see the app in action.

* Database creation
  I had to jump through some hoops to get the PG database working locally - it worked seamlessly the first time, but I had to reinstall a different distro of Linux at some point and thus I had to reconfigure the app to work locally again, where I ran into some troubles. Specifically, the dev environment worked without issues, but the TEST environment was failing. Production was handled by Heroku so I didn't touch it. Eventually, though, it was fixed by something really easy. I believe I only had to `rails db:setup --ENVIRONMENT=TEST` or something along those lines.

* How to run the test suite
  Just navigate to the root folder and run rspec.

* Deployment instructions
  If it's that crucial, I'll setup a new Heroku instance for you to play around with.

# NOTES

* JavaScript
  The JavaScript stuff is a complete mess. I'm aware of this. There's duplication everywhere in that, for each page that has some custom JavaScript, it's literally repeated almost copy-paste style in an ajax-version of that page. I know this is bad and I wanted to move away from JQuery for this reason so that I could introduce some structure to the front-end code.

* Testing
  The codebase isn't fully covered in terms of tests. In fact, there aren't very many. In all honesty, I prioritized pushing new features and making the application work for their specifications, above learning the whole TDD process - eventually, though, I did get around to it, and I started a refactoring phase that I did via a TDD methodology. Essentially, I wrote the test first to make sure that everything works as intended, and then I changed the code to be better and re-ran the tests to make sure things were still working as intended after the changes.

* Still a WIP
  The app is still a work in progress, and there's a mountain of work to chip away still. I used Trello for project management and I've got so many cards on there to still complete that it feels overwhelming just looking at the thing. For example, refactoring the front-end to use a proper JS framework library; implementing a proper security and authorization model; moving over to AWS/Google so that I could roll out a new instance for each new Client that wants to use the app; and a whole bunch of front-end particular things that I wanted to implement to make the app look, feel and work better. Lots and lots of work.

# Some niceties
  There are some nice things in the codebase, though:

  * Since every index page was searchable, I extracted that functionality out into a Searchable concern, and I made each Model that used it override a couple of methods to specify how their particular search functionalities worked. Got this idea from Sandi Metz's book.

  * Also, I wanted to remain consistent with the visual design of things, so I eventually extracted out a particular set of view partials that handled drawing the Cards, but when I actually ran the tests it turned out that rendering nested partials in that way for a bunch of collections was extremely slow, so I reverted it back to not using the partials.

  * Every persisted model in the app can be deleted, but I've set things up so that when you delete a top-level record, the records that depend on that one also get deleted all the way down the dependency tree. In order to make this particularly clear to the users, though, I implemented a function that counts how many related records will be deleted if they delete the particular one. Turns out that I had a lot of repeated code here, so I built a little tree structure (found in models/utility/, the node.rb, removal_node.rb and tree.rb classes, along with models/concerns/removal_confirmation_builder.rb) that handled doing that automatically. At some point along the way, I read somewhere that it might be possible to use built-in associations with ActiveRecord to do that for me; but at that point I was already mostly done with the default implementation and I figured I'd keep it around in case I ever need to expand on the logic.

Yeah, I'm not sure what else to say here. Poke around, I'd be happy to answer any questions.
