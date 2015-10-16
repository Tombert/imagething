-module(img_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, Pid} = img_sup:start_link(), 
    Dispatch = cowboy_router:compile([
        {'_', [
               {"/", hello_handler, [Pid]}, 
               {"/upload", upload_handler, [Pid]} 
              ]
        }
    ]),

    cowboy:start_http(my_http_listener, 100, [{port, 8080}], 
       [{env, [{dispatch, Dispatch}]}]
    ),

    {ok, Pid}.




stop(_State) ->
    ok.
