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
    io:format("Body ~p", [acc_multipart(Req,[])]),
    Req3 = cowboy_req:reply(200, [
      {<<"content-type">>, <<"text/plain">>}
    ], "Hello world!", Req),
    
    {ok, Req3, RiakPid}.

   
    
terminate(_Reason, _Req, _State) ->
    
        ok.

acc_multipart(Req, Acc, Riak) ->
    case cowboy_req:part(Req) of
        {ok, Headers, Req2} ->
            [Req4, Body] = case cow_multipart:form_data(Headers) of
                               {data, _FieldName} ->
                                   {ok, MyBody, Req3} = cowboy_req:part_body(Req2),
                                   [Req3, MyBody];
                               {file, _FieldName, Filename, CType, _CTransferEncoding} ->
                                   {ok, IoDevice} = file:open( erlang:iolist_to_binary([<<"tmp/">>,Filename]), [raw, write, binary]),
                                   Req5 = stream_file(Req2, IoDevice, Riak),
                                   file:close(IoDevice),
                                   [Req5, <<"skip printing file content">>]
                           end,
            acc_multipart(Req4, [{Headers, Body}|Acc]);
        {done, Req2} ->
            {lists:reverse(Acc), Req2}
    end.

stream_file(Req, IoDevice, Riak) ->
    case cowboy_req:part_body(Req) of
        {ok, Body, Req2} ->
            io:format("part_body ok~n", []),
            file:write(IoDevice, Body),
            Req2;
        {more, Body, Req2} ->
            io:format("part_body more~n", []),
            file:write(IoDevice, Body),
            stream_file(Req2, IoDevice)
    end.
