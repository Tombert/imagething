-module(upload_handler).
-behaviour(cowboy_http_handler).
 
-export([init/2]).
-export([handle/2]).
-export([terminate/3]).
 
-record(state, {
}).

init(Req, [RiakPid]) ->
%    io:format("~p~n~n~n~n", [RiakPid]),

    dispatch(Req,RiakPid).

dispatch(Req, RiakPid) ->
    %%{ok, Blah} = img_sup:start_child(RiakPid),

    handle(Req, RiakPid).

handle(Req,RiakPid) ->
    <<"POST">> = cowboy_req:method(Req),
    {ok, Body, Req2} = cowboy_req:body(Req),
    Req3 = cowboy_req:reply(200, [
      {<<"content-type">>, <<"text/plain">>}
    ], "Hello world!", Req),
    
    {ok, Req3, RiakPid}.

   
    
terminate(_Reason, _Req, _State) ->
    
        ok.
