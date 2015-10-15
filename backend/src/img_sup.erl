-module(img_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).




%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    {ok, Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, []),

    Dispatch = cowboy_router:compile([
        {'_', [{"/", hello_handler, [Pid]}]}
    ]),

%    cowboy:start_http(my_http_listener, 100, [{port, 8080}], 
%        [{env, [{dispatch, Dispatch}]}]
%    ),

    {ok, Pid}.

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    ImgChild = {img_srv,{img_srv, start_link,[]}, permanent,brutal_kill, worker, dynamic},
    {ok, { {one_for_one, 5, 10}, [ImgChild]} }.
