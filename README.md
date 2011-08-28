SocialConnections
=================

Enables

* Social connections between people and things: list of friends, things you like, stuff you recommend.
* Activities on those things which are recorded for later processing
* Digest mechanism to digest those activities, e.g. for daily digest emails.

This gem is work in progress and my playground, and currently my playground, don't use it!


Setup
-----

Install as a gem

	gem install social_connections

or reference in your Gemfile

	gem 'social_connections'

and run

	bundle install


Next, you need to add the migration by using the install generator of the gem:

	rails g social_connections:install

which adds the required migration(s). Doing a migration
will generate the required tables:

	rake db:migrate

Now, every model that is supposed to act as a connectable thing (so that friends can connect
other friend or users can like books, or similar), add to all those models

	acts_as_connectable :verbs => [ :likes, :recommends, :comments ]

where the verbs specify what you want to allow those connectables to do to other connectables.
See the example below, that may make it clearer.

Example
-------

Users can like books, and they can comment on books.

Enable model User to be connected to other users and things (books, in this example):

	acts_as_connectable :verbs => [ :likes, :comments ]

Given a user `u` and a book `b`, you can now say

	u.likes(b)

and

	u.comments(b, :comment => 'awesome book!')

. This creates activities for the user and the book. Activities are _only_ created for
those connected to the subject and/or object of the activity--in the example, user `u`
is the subject and book `b` is the object. A user `v` can connect to user `u` by saying

	v.connect_to(u)

. If this is issued before invoking `likes` and `comments` as above, user `v` 
receives 2 activities.

These activities can be queried:

	b.likes_by_count

Gives the number of users (or other 'connectables') that liked this book. Same for

	b.comments_by_count

. For more examples, see the spec files.


Controllers for Activities
--------------------------

Assuming that `current_user` gives you the currently logged in user, a controller
responding to a 'like' button could look as follows:

	  class CurrentUserLikesController < ApplicationController
	    def likes_book
	      @book = Book.find(params[:id])
	      current_user.likes(@book) unless current_user.likes?(@book)
	    end
	  end

A route in config/routes.rb might then look as follows:

	match '/current_user_likes_book/:id' => 'current_user_likes#likes_book', :as => :current_user_likes_book

The view (e.g. `app/views/books/show.html.erb`) may then contain the following 'like' button:

	<%= link_to('I like this', current_user_likes_book_path(@book) %>


How to run the Tests (in the gem itself, not in your Rails app)
--------------------

Run test in ./test:

	rake

Run specs in ./spec:

	rspec spec

Copyright (c) 2011 Chris Oloff, released under the MIT license
