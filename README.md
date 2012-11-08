
Gerrit hooks for Integrity
==========================

These hooks are done for notifying Integrity instance of new Gerrit change update.

At the moment only patchset-created has been implemented, but creating new hooks
is pretty easy; just copy the file and alter the arguments.

List of available hooks along with their params can be found from Gerrit’s manual:
http://gerrit-documentation.googlecode.com/svn/Documentation/2.5/config-hooks.html

Information of what Integrity is can be found from here:
http://integrity.github.com/

Usage
-----

This assumes that hooks resides in default location,
and that hooks dir hasn’t been already created

        cd [your git clone dir]
        git clone git@github.com:Smarre/gerrit-hooks.git
        cd [gerrit root dir]
        mkdir hooks
        cd hooks
        ln -s [git clone dir]/gerrit-hooks/[hook name].rb [hook-name]
        cd -
        sh bin/gerrit.sh restart

Contributions
-------------

If you create new hook, *please* contribute it back! :)
