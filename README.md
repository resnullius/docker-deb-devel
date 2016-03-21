docker-dev-devel
================

    docker pull resnullius/debian-devel:unstable
    docker pull resnullius/ubuntu-devel:xenial

WHAT IS THIS?
-------------
Initial image for doing debian development. Running this image you should be
able to build packages for Debians's different versions inside a docker container
and ship them for installation.

HOW DO I USE IT?
----------------
Good you ask! I made a very nice script in bash that will help you out and make
it as easy as editing files and launching a command in your terminal! It's
called [debian-build-pkg](https://github.com/resnullius/debian-build-pkg)
and will help you generating your keys, building your packages and even making
it easy to get a ready-to-publish repo with your packages signed.

I WANT TO CHANGE THE VERSIONS THAT BUILDS!
------------------------------------------
Then you will want to checkout `versions/base`, it's a simple file exporting
variables saying which debian-based images and tags will be build, as well as
which CPU architecture.

I WANT TO PUSH IT TO MY USER/MY REGISTRY
----------------------------------------
Just change on `versions/base` the `REGISTRY_BASE` variable, if it's your own
registry then put the `url.com/for/your/registry/and/path`.

THIS IS NOT THE SAME THING YOU BUILT FOR ALPINE!
------------------------------------------------
Yeah, people can write stuff in different ways each time, I like this better and
will change alpine's when I got the time.

AUTHOR AND LICENSE
------------------
© 2016, Jose-Luis Rivas `<me@ghostbar.co>`.

This software is licensed under the MIT terms, you can find a copy of the
license on the `LICENSE` file in this repository.
