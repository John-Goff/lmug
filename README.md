# lmug

*LFE HTTP Server Abstraction and Web Application Middleware
Infrastructure*

<img src="resources/images/mugring-small-grey-2.png" />


## Introduction

lmug is an LFE web applications library inspired by
[Clojure's Ring](https://github.com/ring-clojure/ring) (and thus,
indirectly, by
[Python's WSGI](http://legacy.python.org/dev/peps/pep-3333/)).

lmug allows web applications to be constructed of modular components
that can be shared among a variety of applications -- regardless of
which web server or web framework is used. This is possible by providing
a standard abstraction for two things:

* Erlang/LFE/BEAM HTTP servers, and
* functions that can sit between the HTTP request and the HTTP response.

The [SPEC](doc/SPEC.md) file, copied directly from the Clojure Ring
project, provides a complete description of the lmug interface.


### Why?

Using lmug as the basis for your web application has a number of
benefits:

* Write your application using LFE functions and records
* Run your application in a auto-reloading development server
* Take advantage of pre-written middleware
* More easily deploy your application in cloud environments like Amazon
  Elastic Beanstalk and Heroku
* Swap out the underlying HTTP server without changing any of your code

If all goes well, lmug will be the current de facto standard base from
which to write web applications in LFE. Higher level frameworks could
then use lmug as a common basis.

Even though lmug provides only a low-level interface, it is useful to
understand how it works even if you plan to use a higher-level interface.
Without a basic understanding of lmug, you cannot write middleware, and
you may find debugging your application more difficult.


## Installation

Just add it to your ``rebar.config`` deps:

```erlang

    {deps, [
        ...
        {lmug, ".*", {git, "git@github.com:lfex/lmug.git", "master"}}
      ]}.
```

And then do the usual:

```bash

    $ rebar get-deps
    $ rebar compile
```


## Usage

NOTE: the code in this section doesn't work yet! One of the first goals
is to get to this point :-)

NOTE: barista is a stand-alone demo HTTP server that is inlcuded with
lmug. It is an lmug wrapper around the OTP ``httpd`` server.

The usage examples below are done from the REPL:

```bash
$ make repl
```


### Hello World

```cl
> (slurp "src/lmug.lfe")
#(ok lmug)
> (defun handler (request)
    (make-response
      status 200
      headers '(#("content-type" "text/plain"))
      body "Hello World"))
handler
> (set `#(ok ,pid) (run #'handler/1))
#(ok <0.55.0>)
```

To check your new hanlder:

```bash
$ curl -D- -X GET http://localhost:1206/
HTTP/1.1 200 OK
Server: inets/5.10.2
Date: Thu, 28 Aug 2014 20:30:52 GMT
Content-Length: 11
Content-Type: text/plain

Hello World
```

If you want to run on a non-default port (or pass other options) or if you
are using with other projects, please use the adapter module directly. For
example:

```cl
(lmug-barista-adapter:run #'handler/1 '(#(port 8000)))
#(ok <0.54.0>)
```


## Details


### Handlers

lmug handlers are functions that define your web application. They take
one argument, a map representing a HTTP request, and return a map
representing the HTTP response. The handlers return a record that can
then be translated by the supporting HTTP server adatper code into the
appropriate form that will allow the configured HTTP server (e.g., YAWS,
Cowboy, OTP httpd, etc.) to return an HTTP response.


### Middleware

lmug middleware are higher-level functions that add additional
functionality to handlers. The first argument of a middleware function
should be a handler, and its return value should be a new handler
function.


## lmug?

What's with the name? Well, there was lfest ... the web app routing
party. What would be at an LFE routing party? Lots of mugs, I guess.
Full of tastey, hot LFE.

Also, a mug is topologically equivalent to a ring. An lmug even more so.

Besides, lhorse just sounds weird.
