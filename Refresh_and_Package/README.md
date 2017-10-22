Refresh_and_Package
===




The most annoying thing thing for me when I make missions is that when I make one change to my framework or mission templates, I have to distribute those changes into every mission folder and recompile them one by one so that all of the missions are up to date using the same version of my framework or template.  I really needed to cut down time on this updating process, so I wrote these shell scripts to take care of it for me!



![Demonstration using Cygwin](http://i.imgur.com/Wm8s0Sh.png)

These bash shell scripts will:
===

* "Refresh":  copy everything from your "master" framework/template folder into each of your mission folders

* "Package":  pack each of your mission folders into a PBO file so that you can easily copy-paste into your server's mission folder (I personally use a symlinked folder reference on Dropbox)



Important Note!
===

You'll have to go into the .sh files and replace my folder paths with your own.  I've tried to clearly label them at the top of the file for you.




I hope this helps somebody out there
