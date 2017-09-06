# Introducing Phoenix - ElixirConf US 2017 Training Application

## Phoenix Background

- Phoenix is a distributed web services framework; it is designed with flexibility in mind
- Phoenix is built on Elixir; Elixir is basically just Erlang
- Erlang runs on the BEAM (Bogdon's/Bjorn's Erlang Abstract Machine); it was designed with fault-tolerance and concurrency in mind, leveraging a distributed environment -> this becomes important with Phoenix channels
- Phoenix channels were designed to work in this distributed environment
- Elixir and Phoenix are both functional programming languages:
  - immutable data
  - actor-based concurrency model; processes are isolated
  - the only way to update state is to send messages
- Phoenix is an OTP application that provides functionality to our OTP application.  Think of an OTP application as an isolated package of code, that can be started or stopped independently.  
- Phoenix is meant to interface business logic to the web; those two concerns should thus be separated.

## Erlang Background

- preemptive scheduler - think of this as an operating system for your code.  An operating system has to schedule all the different processes running on the machine.  Erlang makes that allocation of time and resources very "fair".  Consider a machine with 8 cores with an OS and Kernel threads.  Each of the 8 cores gets its own scheduler thread.  Each scheduler thread has a run queue, which is just a queue of processes.  As the VM processes code, it pops of the process at the head of the run queue and executes byte for byte until either the process calls code that would cause it to block, or it has hit its 2000 reduction limit.  At that time, it is pushed to the end of the run queue.  Think of a reduction like a function call.  This concept of a reduction comes from Erlang's root in Prologue - remember, Erlang has no loops, just recursion.  The Erlang virtual machine is written in C.
- processes are just pointers to bytes in memory; thus, they are very lightweight units of concurrency.  They maintain state by looping over themselves recursively.  They communicate via message passing.  OTP is an abstraction over this architecture.
- processes are isolated and concurrent -> each process has its own thread and state, meaning all data for that process is only managed by that process.  Each process has its own mailbox where messages are received.  Linking can combine the lifecylce of multiple processes together; monitoring can create parent-child relationships between processes.
- note, these are not OS processes, but Erlang-VM processes.  Erlang can support at least 1 million of these on a machine.
- garbage collection is done on a per-process basis.  This makes garbage collection very fast.
- message passing -> use a pid to send to, and pass self along so the receiver has an ability to communicate back.
- crashes are isolated; if one process crashes, only that process crashes, unless linked or monitoring.
- data is isolated
- Erlang will try to use all of the cores on your machine.

## OTP

- GenServers
- Supervisors
- Processes
- etc...

## Phoenix Directory Structure
- \_build
- assets -> where static assets are compiled
  - js -> all javascript stuff
  - etc.
- config
  - config.exs is the default, and other .exs files in this directory can overwrite it
- deps -> any explicitly defined dependency code lives here
- lib -> all application code lives here
- priv -> called this to be compatible with Erlang; not actually private stuff
- test -> tests go here
- mix.exs -> application dependencies are specified in this file

## Plug

Phoenix is basically built using Plug.  It is a specification for construction of composeable modules to build web applications.  Plugs are reusable modules of functions built to the specific specification.

### Plug.Conn

This module defines a Plug.Conn struct and the main functions for working with Plug connections.
- assigns -> contains a map of variables that could have come from previous plugs
- before_send -> a callback can be registered here to do some action that we always want to happen before sending
- halted -> if there is some kind of event that should literally stop the connection, that logic can be defined here
- method -> sets the HTTP verb for the request

Fetchable Fields
- some fields need to be accessed with `fetch_key` or there will be an error returned

Private Fields
- don't really touch anything in that `private` key

Plugs can and are encourage to be written for almost anything.

### Function Plugs

Any function that receives a connection and a set of options and returns a connection.  Signature must be:

```
(Plug.Conn.t, Plug.opts) :: Plug.Conn.t
```

Example:

This is a function from the Plug.Conn module, that changes the response content type to 'application/json'.

```
def json_header_plug(conn, _opts) do
  conn
  |> put_resp_content_type("application/json")
end
```

### Module Plugs

An extension of the function plug.  It is a module that must export: (1) `init/1` - takes a set of options and initializes it. (2) `call/2` - takes the connection and options and returns connection.

Example:

```
defmodule JSONHeaderPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("application/json")
  end
end
```

## Plug: Endpoint

## Plug: Router

Controls how all of the routes are dispatched.

Scopes help us group together routes.  Part of the scope specifies the top-level namespace, so that that controllers defined in the routes inside of that scope do not have to be fully qualified.

## Plug: Controller

## Pipelines

Pipelines are chains of plugs.

## General Notes

- think about spawning individual processes for managing the state of a model in the system, e.g. an appointment or a participant, or an enrollment
- blog post on Phoenix framework about benchmarking 2 million connections on a single server over channels; this should be absolutely sufficient for our needs
- anytime there is a new release, an archive is created which is the Phoenix installer run with 'mix phx.new app_name'
- Plug is essentially middleware for the request-response system in Phoenix
- for what it's worth, Repo should be kept out of all controller functions, and preloads done in the context, either with keyword lists as an arg for example, or very specific functions
- can use the Endpoint module when a conn is not available to use the route path helpers
- create an .iex.exs file in the root of the project and alias namespaces there so that they are available in iEx on startup
- `configure_session(conn, renew: true)` will return a brand new session, rather than using an existing/stale session.
- should probably add `singleton: true` to our sessions routes
- our context functions for updating associations on a model need to use `with...else` to handle best case flow and error flow
- use `exgravatar` for displaying avatars -> this was created by Sonny Scroggin
