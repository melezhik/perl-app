# SYNOPSIS

Installs Perl web application and dependencies, runs application as ubic service with Starman.

# INSTALL

    $ sparrow plg install perl-app

# USAGE

    $ sparrow plg run perl-app app_source_url={git-remote-repository-url}

# Plugin parameters:

## git_branch 

Git branch name, default value is `master`

## app_user 

Application user name, perl application will be run with this user privileges, default value is  `perl-app`

## app_dir 

Home directory for application source code and dependencies get installed by carton, default value is `/opt/perl-app/`


## app_source_url

Application source code remote git url, no default value, obligatory parameter


# Author

[Alexey Melezhik](mailto:melezhik@gmail.com)
