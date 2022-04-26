% A binary search tree is a binary tree,
% in which every node is greater than each member of its left subtree,
% and is less than than each member of the right subtree.
%
% bst(Value, Left, Right)


bst_value(bst(V, _, _), V).


bst_is_empty(null).


bst_is_valid(bst(V, L, R)) :-
  bst_value(L, LV),
  bst_value(R, RV),
  LV < V,
  V < RV,
  bst_is_valid(L),
  bst_is_valid(R).

bst_is_valid(null).


bst_from_list(Xs, T) :-
  bst_from_list(Xs, null, T).

bst_from_list([X|Xs], T0, T) :-
  bst_insert(X, T0, T1),
  bst_from_list(Xs, T1, T).

bst_from_list([], T, T).


% Complexity: 2d in the worst case, where d is the depth of the tree.
bst_member(X, bst(V, L, _)) :-
  X < V,
  bst_member(X, L).

bst_member(X, bst(X, _, _)).

bst_member(X, bst(V, _, R)) :-
  X > V,
  bst_member(X, R).


% Complexity: 2d in the worst case, where d is the depth of the tree.
bst_insert(X, bst(V, L, R), bst(V, L1, R)) :-
  X < V,
  bst_insert(X, L, L1).

bst_insert(X, bst(X, L, R), bst(X, L, R)).

bst_insert(X, bst(V, L, R), bst(V, L, R1)) :-
  X > V,
  bst_insert(X, R, R1).

bst_insert(X, null, bst(X, null, null)).
