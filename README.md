# Introducing Phoenix - ElixirConf US 2017 Training Application

Checkout out [NOTES.md](https://github.com/steven-cole-elliott/elixirconf-phoenix-workshop/blob/master/NOTES.md) for notes taken during this workshop.

## Course Description

Phoenix is an Elixir web framework for building scalable web services for the
modern web. In this training, we’ll take a guided tour of the framework, going
from the very basics, to building our own realtime application.

You’ll see the framework’s foundations, core components, and learn how to use
Phoenix to write powerful web services.

We’ll start by exploring the foundations of the framework in Elixir’s Plug
library, followed by the core components of Phoenix’s Router and Controller
layers.

Next, we’ll review the View layer and build an application together as we learn
each concept.

We’ll finish by using the PubSub layer to add realtime functionality to our
application.

Along the way, attendees will see how to apply advanced features like router
pipelines and plug middelware and receive tips on how to structure a Phoenix
application for real-world services.

## Prerequisites

This course is designed for people who have prior experience with other web
frameworks and want to learn how to get started with Phoenix.

I will not assume that you have any prior experience with Elixir in this course.
So if you are a beginner, have no fear. The course format encourages open-dialog
and learning by asking questions along the way.

In order to ensure that we get started in a timely manner. Please make sure to
get all the dependencies (outlined below) installed prior to the training.

Please take a look at this list and make sure to install anything necessary for
your system. Having dependencies installed in advance will allow us to hit the
ground running and cover the most material possible.

## Installing dependencies

### Elixir

Phoenix is written in Elixir, and our application code will also be written in
Elixir. We won't get far in a Phoenix app without it! The Elixir site maintains
a great [Installation Page](http://elixir-lang.org/install.html) to help.

We need Elixir 1.4 or higher for this course.

If we have just installed Elixir for the first time, we will need to install the
Hex package manager and Rebar as well. Hex is necessary to get a Phoenix app
running (by installing dependencies) and to install any extra dependencies we might need
along the way. Rebar is a similar tool used by many existing Erlang projects
that we may depend on.

Here's the command to install Hex and Rebar:

```console
$ mix local.hex
$ mix local.rebar
```

If you are not yet familiar with Elixir, I recommend taking a look at the excellent
[Getting Started](http://elixir-lang.org/getting-started/introduction.html) guide.

### Erlang

Elixir code compiles to Erlang byte code to run on the Erlang virtual machine.
Without Erlang, Elixir code has no virtual machine to run on, so we need to
install Erlang as well.

When we install Elixir using instructions from the Elixir [Installation Page](http://elixir-lang.org/install.html),
we will usually get Erlang too. If Erlang was not installed along with Elixir,
please see the [Erlang Instructions](http://elixir-lang.org/install.html#installing-erlang)
section of the Elixir Installation Page for instructions.

### Node.js (>= 5.0)

Phoenix will use [brunch.io](http://brunch.io/) to compile static assets
(javascript, css, etc), by default. Brunch.io uses the node package manager
(npm) to install its dependencies, and npm requires node.js.

We can get node.js from the [download page](https://nodejs.org/download/). When
selecting a package to download, it's important to note that Phoenix requires
version 5.0 or greater.

Mac OS X users can also install node.js via [homebrew](http://brew.sh/).

Debian/Ubuntu users might see an error that looks like this:

```console
sh: 1: node: not found
npm WARN This failure might be due to the use of legacy binary "node"
```

This is due to Debian having conflicting binaries for node: [discussion on
stackoverflow](http://stackoverflow.com/questions/21168141/can-not-install-packages-using-node-package-manager-in-ubuntu)

There are two options to fix this problem, either:

- install nodejs-legacy:
```console
$ apt-get install nodejs-legacy
```
or
- create a symlink
```console
$ ln -s /usr/bin/nodejs /usr/bin/node
```

### PostgreSQL

We will be interacting with a database while building our application. Phoenix
uses the database abstraction library [Ecto](https://github.com/elixir-ecto/ecto)
which supports a number of databases.

For this course, we'll be using PostgreSQL for consistency across attendees.

The PostgreSQL wiki has [installation guides](https://wiki.postgresql.org/wiki/Detailed_installation_guides) for
a number of different systems.

#### Optional configuration

By default, Phoenix expects to connect to the database with user of `postgres`
having a password of `postgres`. If this is not the case for your PostgreSQL
installation, you can change this in `config/dev.exs` like so:

```ex
# Configure your database
config :workshop, Workshop.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "<change-me>",
  password: "<change-me>",
  database: "workshop_dev",
  hostname: "localhost",
  pool_size: 10
```

Some installations (installing via homebrew or using Postgres.app)
will use your username with no password.

### inotify-tools (for linux users)

This is a Linux-only filesystem watcher that Phoenix uses for live code
reloading. (Mac OS X or Windows users can safely ignore it.)

Linux users need to install this dependency. Please consult the
[inotify-tools wiki](https://github.com/rvoicilas/inotify-tools/wiki) for
distribution-specific installation instructions.

### Building this application

Now that we have all the dependencies installed, let's clone, build, compile,
and start it up!

If you haven't already, clone this repo and change into the directory of your
choosing:

```shell
$ git clone https://github.com/scrogson/acme
$ cd acme
```

Next, we'll need to fetch our Elixir dependencies:

```shell
$ mix deps.get
```

Create the database for our application:

```shell
$ mix ecto.create
```

If you see this error:

```shell
FATAL (invalid_authorization_specification): role "postgres" does
not exist
```

You will need to update your `username` and `password` in `config/dev.exs` as
explained above in [Optional configuration](#optional-configuration).

If you installed Postgres with `homebrew`, you can alternatively add
the `postgres` user like so:

```shell
$(brew --prefix postgresql)/bin/createuser -s postgres
```

Install the nodejs dependencies:

```shell
$ cd assets
$ npm install
```

We are all set! Now it's time to start the application:

```shell
$ mix phx.server
```

You can also run your app inside IEx (Interactive Elixir) with:

```shell
$ iex -S mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from
your browser and see your new Phoenix app running. Yay!

## Other dependencies

We will be using an elixir package which requires a C compiler such
as `gcc` and `make` to be installed on you system.

Ubuntu and Debian-based systems can get `gcc` and `make` by installing
`build-essential` package. Also `erlang-dev` may be needed if not included in your
Erlang/OTP version.

## Having trouble?

It is vital that we get all the setup dealt with prior to the workshop so that
we can focus on learning as much as possible with the limited time. Please feel
free to [contact me](mailto:scrogson@gmail.com) directly if you have any trouble
with getting anything setup.
