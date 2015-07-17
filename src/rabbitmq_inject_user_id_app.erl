-module(rabbitmq_inject_user_id_app).
-behaviour(application).
-export([start/2, stop/1]).
-behaviour(supervisor).
-export([init/1]).
start(_Type, _Args) -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).
stop(_State) -> ok.
init([]) -> {ok, {{one_for_one, 3, 10}, []}}.
