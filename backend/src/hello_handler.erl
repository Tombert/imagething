-module(hello_handler).
-behaviour(cowboy_http_handler).
 
-export([init/2]).
-export([handle/2]).
-export([terminate/3]).
 
-record(state, {
}).

init(Req, Blah) ->
    State = 4,
    
    handle(Req, State).

handle(Req, State=#state{}) ->

    {ok, Req, State}.
 
    
 
terminate(_Reason, _Req, _State) ->
    
        ok.
