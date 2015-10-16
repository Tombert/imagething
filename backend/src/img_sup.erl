-module(img_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, init/1]).




%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init(_) ->

    ImgChild = #{id => img_srv, start => {img_srv, start_link, []}},

    {ok, { {one_for_one, 5, 10}, [ImgChild]} }.
