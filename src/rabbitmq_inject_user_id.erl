-module(rabbitmq_inject_user_id).

-include_lib("amqp_client/include/amqp_client.hrl").

-behaviour(rabbit_channel_interceptor).

-export([applies_to/0,
         intercept/3,
         init/1]).

-rabbit_boot_step({?MODULE,
                   [{description, "rabbitmq_inject_user_id"},
                    {mfa,
                     {rabbit_registry, register,
                      [channel_interceptor,
                       <<"rabbitmq_inject_user_id">>,
                       ?MODULE]}},
                    {requires, rabbit_registry},
                    {enables, recovery}]}).

applies_to() -> ['basic.publish'].

set_user_id_header(Content, #user{username = Username}) ->
    Content1 = #content{properties = Props} =
      rabbit_binary_parser:ensure_content_decoded(Content),
    Props1 = Props#'P_basic'{user_id = Username},
    rabbit_binary_generator:clear_encoded_content(
        Content1#content{properties = Props1}).

intercept(M = #'basic.publish'{}, C, User) -> {M, set_user_id_header(C, User)};
intercept(M, C, _) -> {M, C}.

init(Ch) -> rabbit_channel:get_user(Ch).
