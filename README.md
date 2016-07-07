
```
░█▀▀█ █▀▀ █▀▀ █▀▀ ▀▀█▀▀ ░▀░ █▀▀ █░░█
▒█▄▄█ ▀▀█ ▀▀█ █▀▀ ░▒█░░ ▀█▀ █▀▀ █▄▄█
▒█░▒█ ▀▀▀ ▀▀▀ ▀▀▀ ░▒█░░ ▀▀▀ ▀░░ ▄▄▄█
```

[![Gem Version](https://badge.fury.io/rb/assetify.svg)](http://badge.fury.io/rb/assetify)
[![Code Climate](https://codeclimate.com/github/nofxx/assetify.svg)](https://codeclimate.com/github/nofxx/assetify)
[![Coverage Status](https://coveralls.io/repos/nofxx/assetify/badge.svg?branch=master)](https://coveralls.io/r/nofxx/assetify?branch=master)
[![Dependency Status](https://gemnasium.com/nofxx/assetify.svg)](https://gemnasium.com/nofxx/assetify)
[![Build Status](https://travis-ci.org/nofxx/assetify.svg?branch=master)](https://travis-ci.org/nofxx/assetify)


Assetify
========

Downloads/updates assets. Any framework*.

* But if you're using sprockets/rails pipeline there's more sugar.


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

Like a `Gemfile`, but with fewer chars. Only one actually.


Behold the `a`
--------------

    a  "tipsy", "http://...tipsy.js"
    a  "tipsy", "http://...tipsy.css"
    a  "video", "http://...video.mpeg"


There's also an alias `asset` for `a`, if you enjoy typing:


    asset "tipsy", "http://...tipsy.js"



You can choose the filetype (or extension) before too:

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

This downloads and 'cherry picks' the files.
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


Sprockets
=========

Or The Rails 3.1+ Asset Pipeline.

Wouldn`t it be nice to bundle all those little dependencies and tiny
stylesheets to avoid extra includes, but, change the source on every
update...PITA. No worries:

CSS will be converted to sass, scss or erb (defaults), your choice.
And every path corrected to use the pipeline.

Jquery Mobile example:

    pkg :mobile, "http://code.jquery.com....zip", shallow: true do
      js  "mobile", "mobile.js"
      css "mobile", "mobile.css", :as => :sass
      dir "images/*"
    end

You just need:

    //= require 'mobile'

On application.css and application.js.

Images will be in 'vendor/assets/mobile/*', and the paths inside
mobile.css corrected to 'image-url(mobile/*)', or <%%> if I`ve had
choose erb.

This means you can have any third party library in the format
you like, always up-to-date. Easy to copy and customize parts
of the code.


foo2bar
-------

You can convert your assets to coffescript, sass or scss:

     js "fulib", "http....", :as => :coffee
     css "1140", "http....", :as => :sass
     css "1140", "http....", :as => :scss

Note: You do need aditional stuff for this.
Gem 'sass' and/or node`s 'js2coffee' (install via npm).


minimagick
----------

Preprocess images is also possible:


    png "logo", "http....", :as => :jpg, :quality => 75


Note: Need to install 'imagemagick' and 'minimagick' gem for this.

Versions
--------

Assetify first tries to recognizes the file as text or binary.
If the file is human readable, try a (X.X.Xxx?) pattern match
that if found it`s used. Otherwise go for md5sum.


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
