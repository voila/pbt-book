-module(prop_chap3).

-include_lib("proper/include/proper.hrl").

%%%%%%%%%%%%%%%%%%
%%% Properties %%%
%%%%%%%%%%%%%%%%%%

%% Question 2
prop_keysort() ->
    ?FORALL(L, (list({term(), term()})),
	    begin is_ordered(lists:keysort(1, L)) end).

prop_length() ->
    ?FORALL(L, (list({term(), term()})),
	    begin length(lists:keysort(1, L)) =:= length(L) end).

prop_permutation() ->
    ?FORALL(L, (list({term(), term()})),
	    begin
	      Sorted = lists:keysort(1, L),
	      lists:all(fun ({K, _}) -> lists:keymember(K, 1, L) end,
			Sorted)
		andalso
		lists:all(fun ({K, _}) -> lists:keymember(K, 1, Sorted)
			  end,
			  L)
	    end).

%% Question 3
prop_set_union() ->
    ?FORALL({L1, L2}, {list(number()), list(number())},
	    begin
	      S1 = sets:from_list(L1),
	      S2 = sets:from_list(L2),
	      ModelUnion = lists:usort(L1 ++ L2),
	      lists:sort(sets:to_list(sets:union(S1, S2))) =:=
		ModelUnion
	    end).

%% Question 5
prop_count_words() ->
    ?FORALL(L, (list(non_empty(list(range(97, 122))))),
	    begin
	      S = lists:foldl(fun (S, A) -> S ++ " " ++ A end, [], L),
	      C = count_words(S),
	      length(L) =:= C
	    end).

%%%%%%%%%%%%%%%
%%% Helpers %%%
%%%%%%%%%%%%%%%
is_ordered([{K1, _}, {K2, V2} | Xs]) ->
    K1 =< K2 andalso is_ordered([{K2, V2} | Xs]);
is_ordered(_L) -> true.

count_words(S) -> count_words(0, space, S).

count_words(N, _, []) -> N;
count_words(N, word, [$\s | Xs]) ->
    count_words(N, space, Xs);
count_words(N, word, [_ | Xs]) ->
    count_words(N, word, Xs);
count_words(N, space, [$\s | Xs]) ->
    count_words(N, space, Xs);
count_words(N, space, [_ | Xs]) ->
    count_words(N + 1, word, Xs).
