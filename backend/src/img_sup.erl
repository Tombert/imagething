-module(img_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, init/1, start_child/1]).


start_child(Pid) ->
    ImgChild = #{id => img_srv, start => {img_srv, start_link, []}},
    supervisor:start_child(Pid, ImgChild).


%% Helper macro for declaring children of supervisor

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init(_) ->
    {ok, { {one_for_one, 5, 10}, []} }.
