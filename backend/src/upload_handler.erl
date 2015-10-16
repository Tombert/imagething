-module(upload_handler).
-behaviour(cowboy_http_handler).
 
-export([init/2]).
-export([handle/2]).
-export([terminate/3]).
 
-record(state, {
}).

init(Req, [RiakPid]) ->
    State = #{riak => RiakPid},
    handle(Req,State).

handle(Req, State) ->
    RiakPid = maps:find(riak, State),
    %%supervisor:start_child(RiakPid, []),
    Req2 = cowboy_req:reply(200,
        [{<<"content-type">>, <<"text/plain">>}],
        <<"Hello Erlang!">>,
        Req),
    {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
    
        ok.
