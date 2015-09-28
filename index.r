#!/usr/local/sbin/rebol -c
REBOL [ Title: "Index" ]
do %/home/andrew/www/web.r
print "Content-Type: text/html^/"
print {<!DOCTYPE html>}
print {<html>}
print headTag "Test Page"
print {<body>}
print h1Tag "Index"
print pTag "Hello, world!"
print pTag makeImage/alt {http://pics.mytrapster.com/wp-content/pikachoors/th_20150624230612.png} "Yvonne"
print pTag makeLink "Homepage" "http://andrewburton.biz/"
print {</body></html>}