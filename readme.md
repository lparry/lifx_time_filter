LIFX time filters
=================

[LIFX][lifx] has a neat API for controlling your lights.
[IFTT][ifttt] has some neat stuff for triggering actions based on your location.
Sadly you can't put time-based restrictions on these location based events.
This little sinatra server can be stuck between the two to make that possible.

Use Case
--------

You want your lights to switch on automatically when you get home, but only if
it's actually dark.

Usage
-----

* Get your LIFX token [here][lifx-tokens].
* Dump this on heroku. use `heroku config-set` to set `HTTP_AUTH_USER`,
`HTTP_AUTH_PASSWORD` and `LIFX_TOKEN`.
* Configure IFTTT to trigger based on location, and send a
`PUT` request via the maker API plugin to your app like `https://user:password@magic-unicorn-69.herokuapp.com/turn_on_lights_if_after/5PM`.

Time format
-----------

The last part of the url can be like `6PM` or `18:15` or probably a million
other formats that `ActiveSupport::TimeZone` can parse. But you'll probably just
break it if you try and do anything too complicated.


[lifx]: http://www.lifx.com
[ifttt]: http://ifttt.com
[lifx-tokens]: https://cloud.lifx.com/settings

