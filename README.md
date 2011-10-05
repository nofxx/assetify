Assetify
========

Downloads/updates assets. Any framework.


Install
-------

    gem install assetify


Use
---

On any project`s root:

    assetify


This will create a `Assetfile` if not found.


Assetfile
=========

Like a `Gemfile`, but you choose the filetype (or extension) before:

    type "name", "url", <"version"> or <:options>

    js "jquery", "http://code.jquery.com/jquery-{VERSION}.min.js", "1.6"
    js "tipsy",  "https://github.com/jaz303/tipsy/.../jquery.tipsy.js"

Stylesheets:

    css "tipsy", "https://github.com/jaz303/tipsy/.../jquery.tipsy.css"

Any file:

    mp3 "alert", "http://link/to/audio"


Now just run `assetify` to make sure everything is installed/up-to-date.


Groups
------

Use groups/namespaces to group related assets together:

    group "forms" do
      js "validator", url
      js "textmask",  url
    end


This will install as "vendor/assets/javascripts/forms/validator.js"

You can nest groups too:

    group "forms" do
      js "validator", url
      group "extra" do
        js "another", url
      end
    end


Pkgs
----

Big projects makes you download tons of files for some .min files and css.

    pkg "fancy", "http://to.tgz.or.zip" do
      js  "cool", "internal/js/cool.js"
      css "cool", "internal/css/cool.css"
    end

This downloads and 'cherry pick' the files.
Files will be written with the namespace "fancy":

    /javascripts/fancy/cool.js

You can pass :shallow => true to avoid the namespace:

    pkg "fancy", "http://to.tgz.or.zip", shallow: true do

Results in:

    /javascript/cool.js


Also, please check out the note about link inside pkgs below.



Dir
___

You can resource a full directory of files, too. Very useful when
dealing with pkgs:

    pkg "complexfw", "link" do
      js  "complex.min.js"
      dir "images/", to: "images/complexfw"
      # Another option, treat`em all as filetype:
      dir "src/", :as => :js
    end

All files inside images will be copied to "images/complexfw" and
all files in 'src' to 'javascripts' (or whatever else jspath is).


Note: Have in mind that the "link" inside dir/packages *is a regex*
that returns the *first match* inside the archive. Check out libarchive
or the pkg.rb source for more info.


Global 'a'
----------

If the link contains the file extension, say: 'fu.com/lib.js'
You can use just 'a' to specify each asset:


    a  "tipsy", "http://...tipsy.js"
    a  "tipsy", "http://...tipsy.css"
    a  "video", "http://...video.mpeg"


Versions
--------

Assetify first recognizes the file as text or binary.
If the file is human readable, try a X.X.Xxx pattern match
that if found, is used, otherwise use md5sum.


Other
-----

Set a different location per file:


    js "other", "http://lib.../other.js", to: "different/path"

Filename will be: ./different/path/other.js
This works for namespaces too, change "to" with "ns".



Options
-------

Change some default settings:

    newname      true || false
    javascripts  "public/javascripts"
    stylesheets  "public/stylesheets"
    images       "public/images"

If newname is set to true (default) the file will be renamed. Ex:

    js "validator", "http//.../jquery.validator.min.js"

Filename will be: "validator.js"



Rails
-----

Out of the box support for rails 3.1, defaults to 'vendor/assets'.
Rails 3.0< users should change the options as above.


Sprockets
=========

Or The Rails Asset Pipeline.

It'll be nice to bundle those little dependencies, but change the source
on every update...pita.

CSS will be converted to sass, scss or erb, your choice.
And every path corrected to use the pipeline.

Jquery Mobile example:

    pkg :mobile, "http://code.jquery.com....zip", shallow: true do
      js  "mobile", "min.js"
      css "mobile", "min.css", :as => :sass
      img "images/*", :to => "mobile"
    end


//= require 'lib'

On application.css.


Emacs
-----

Use ruby syntax for nice colors:

    (add-to-list 'auto-mode-alist '("Assetfile$" . ruby-mode))


Contributing
------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.


Copyright
---------

Copyright (c) 2011 Marcos Piccinini. See LICENSE.txt for
further details.

