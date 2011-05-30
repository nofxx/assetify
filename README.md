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


This will create a Jsfile if not found.


Jsfile
======

Just like a Gemfile, but you choose the filetype before:

    type "name", "url", <"version"> or <:options>

    js "jquery", "http://code.jquery.com/jquery-{VERSION}.min.js", "1.6"
    js "tipsy", "https://github.com/jaz303/tipsy/.../jquery.tipsy.js"

Now just run assetify to make sure everything is installed/up-to-date.


Groups
------

When using some compressor/minimizer (Jammit/Smurf...) namespaces come
in handy:

    group "forms" do
      js "validator", "link"
    end


This will install as "public/javascripts/forms/validator.js"


Pkgs
----

Big projects makes you download tons of files for some .min files and css.

    pkg "fancy", "http://to.tgz.or.zip" do
      js  "cool", "internal/js/cool"
      css "cool", "internal/css/cool"
    end

This downloads and 'cherry pick' the files.



Other
-----

Set a different location per file:


    js "other", "http://lib.../other.js", :to => "different/path"

Filename will be: ./different/path/other.js
This works for namespaces too, change "to" with "ns".



Options
-------

Change some default settings:

    newname  true || false
    jspath  "public/javascripts"
    csspath "public/stylesheets"
    imgpath "public/images"

If newname is set to true (default) the file will be renamed. Ex:

    js "validator", "http//.../jquery.validator.min.js"

Filename will be: "validator.js"




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

