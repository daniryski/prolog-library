% A weight-biased leftist heap is a heap-ordered binary tree,
% satisfying the weight-biased leftist property:
% * the size of any left subheap is at least as large as the size of its
% right sibling.
%
% Note on complexity:
% * it's easy to prove, that for a weight-biased leftist heap with size n,
% the rightmost path from the root contains at most log(n + 1) elements.
%
% wblh(Value, Weight, Left, Right)


wblh_value(wblh(V, _, _, _), V).


wblh_weight(wblh(_, W, _, _), W).
wblh_weight(null, 0).


wblh_is_empty(null).


wblh_is_valid(wblh(_, W, L, R)) :-
  wblh_weight(L, LW),
  wblh_weight(R, RW),
  LW >= RW,
  W is LW + RW + 1,
  wblh_is_valid(L),
  wblh_is_valid(R).

wblh_is_valid(null).


% Complexity: n.
% The algorithm makes a singleton heap from every element of the list,
% and then merges the heaps two by two, until there's only one heap remaining,
% which takes approximately n * log1 + n/2 * log2 + n/4 * log4 + ...
wblh_from_list(Xs, H) :-
  wblh_singletons_from_list(Xs, [], Hs),
  wblh_from_singletons(Hs, [], H).


wblh_singletons_from_list([X|Xs], Hs0, Hs) :-
  wblh_singletons_from_list(Xs, [wblh(X, 1, null, null)|Hs0], Hs).

wblh_singletons_from_list([], Hs, Hs).


wblh_from_singletons([H1, H2|Hs], Hs0, H) :-
  wblh_merge(H1, H2, H0),
  wblh_from_singletons(Hs, [H0|Hs0], H).

wblh_from_singletons([H1], [H0|Hs0], H) :-
  wblh_from_singletons([H1, H0|Hs0], [], H).

wblh_from_singletons([], [H0|Hs0], H) :-
  wblh_from_singletons([H0|Hs0], [], H).

wblh_from_singletons([H], [], H).
wblh_from_singletons([], [], null).


% Correctness: the algorithm recursively merges the rightmost paths
% of the two heaps.
% Complexity: logn + logm, where n, and m are the sizes of the two heaps
% (see Note on complexity).
wblh_merge(wblh(V1, _, L1, R1), H2, H) :-
  wblh_value(H2, V2),
  V1 =< V2,
  wblh_merge(R1, H2, R),
  wblh_adjust(V1, L1, R, H).

wblh_merge(wblh(V1, W1, L1, R1), H2, H) :-
  wblh_value(H2, V2),
  V1 > V2,
  wblh_merge(H2, wblh(V1, W1, L1, R1), H).

wblh_merge(wblh(V, W, L, R), null, wblh(V, W, L, R)).
wblh_merge(null, wblh(V, W, L, R), wblh(V, W, L, R)).
wblh_merge(null, null, null).


wblh_adjust(V, L, R, wblh(V, W, L, R)) :-
  wblh_weight(L, LW),
  wblh_weight(R, RW),
  LW >= RW,
  W is LW + RW + 1.

wblh_adjust(V, L, R, wblh(V, W, R, L)) :-
  wblh_weight(L, LW),
  wblh_weight(R, RW),
  LW < RW,
  W is LW + RW + 1.


wblh_insert(X, H, H1) :-
  wblh_merge(wblh(X, 1, null, null), H, H1).


% Complexity: c.
wblh_find_min(wblh(X, _, _, _), X).


wblh_delete_min(wblh(X, _, L, R), X, H) :-
  wblh_merge(L, R, H).


% Complexity: n * logn.
wblh_sort(Xs, Zs) :-
  wblh_from_list(Xs, H),
  wblh_delete_mins(H, [], Ys),
  reverse(Ys, Zs).


wblh_delete_mins(H, Xs, Ys) :-
  wblh_delete_min(H, X, H1),
  wblh_delete_mins(H1, [X|Xs], Ys).

wblh_delete_mins(null, Xs, Xs).
