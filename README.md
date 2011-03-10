My Symfony2 toolbox
===================

I'll put here my personal set of tools built for my Symfony2 experiments.


sf2_completion.bash
-------------------

This is a Bash completion script for your Symfony2 projects. It will enable auto-complete in CLI for any "console" and "symfony" scripts. It should work for sf 1.x though it has not been tested.

Advantage: no need for any bundle in your project, it works out of the box, for any sf2 project.

Installation: copy script content to /etc/bash_completion, or put script file into /etc/bash_completion.d/ (depending on your system architecture).

Known bug: Ubuntu provides a patched version of PHP5-CLI that completely sucks and simply breaks any completion script as soon as it's called. For Ubuntu machines, the script needs to rely on PHP-CGI, so you'll have to "sudo apt-get install php-cgi" before using this script.

Your script is not called "console" nor "symfony" ? Just add yours in the last line of the completion script.


sf2_init_project.sh
-------------------

Create a directory for your project, chdir to this directory, and call the script. It will:

* Download Symfony 2 PR7 Standard Edition
* git init
* ask for git config if necessary
* add vendors
* commit

This script is not "configurable": working directory will be used for installation, and Symfony2 package version is in the script. Edit it for your own needs.



    
