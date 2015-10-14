-module(img_srv).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3, hexstring/1]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------
hexstring(Binary) when is_binary(Binary) ->
    lists:flatten(lists:map(
        fun(X) ->
                 io_lib:format("~2.16.0b", [X]) end, 
        binary_to_list(Binary))).

init(Args) ->
    {ok, Pid} = riakc_pb_socket:start_link("127.0.0.1", 8087),
    {ok, #{riak => Pid}}.

handle_call({put_image, Image}, _From, State) ->
    RiakPid = maps:find(State, riak),
    ImgData = base64:encode(Image),
    Hash = crypto:hash(sha,ImgData),
    Object = riakc_obj:new(<<"images">>, Hash, term_to_binary(ImgData)),
    riakc_pb_socket:put(RiakPid, Object),
    {reply, {ok, Hash}, State};

handle_call({get_image, Hash}, _From, State) ->
    Pid = maps:find(State, riak),    
    {ok, ImgData} = riakc_pb_socket:get(Pid, <<"images">>, list_to_binary(Hash)),
    {riakc_obj, _,_,ImgData,_,_,_} = ImgData,
    {reply, {ok, ImgData}, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

