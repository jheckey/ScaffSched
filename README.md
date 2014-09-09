
# Scaffold Scheduling Script Collection

As a reference to my Master's thesis, the scripts developed and used to generate
the algorithm schedules are given here. These script comprise the majority of
the scheduling computation and scripted regression tools to generate all of the
schedules described in my thesis, except for compilation. The algorithms are not
included here, but are available in the ScaffCC repository.  This collection of
scripts is released for informational purposes. No effort is made to ensure a
working environment, but one can be constructed from it.

## Requirements

* A UNIX-like platform (developed and predominantly run on Ubuntu 13.12, but Mac
and Cygwin should both work)
* Perl
* Bash
* Scaffold Compiler (https://github.com/ajavadi/ScaffCC)

## Running

Most of the scheduling should be able to be run by updating \$\{SCAFFOLD\}
environment variable to point to the ScaffCC repository directory and running
'flat\_script.sh'. This should be in a separate directory to ease file
management, since several hundred files may be created.

    % mkdir Boolean_Formula
    % cd Boolean_Formula
    % cp ${SCAFFOLD}/Algorithm/Boolean_Formula/*.scaffold .
    % ../flat_script.sh *.scaffold

The best way to get a feel for what is happening is to read over the scripts
'flat\_script.sh' and 'script.sh' and to follow their execution.
