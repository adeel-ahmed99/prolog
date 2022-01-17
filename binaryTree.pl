/* substituting first occurence of X inside a binary tree with Y */

subsFirst(X, Y, void, void).
subsFirst(X, Y, tree(X, L, M, R), tree(Y, L, M, R)).
subsFirst(X, Y, tree(Z, L1, M, R), tree(Z, L2, M, R)) :-
	not X=Z,
	memberTree(X, L1),
	subsFirst(X, Y, L1, L2).
subsFirst(X, Y, tree(Z, L, M1, R), tree(Z, L, M2, R)) :-
	not X=Z,
	not memberTree(X, L),
	memberTree(X, M1),
	subsFirst(X, Y, M1, M2).
subsFirst(X, Y, tree(Z, L, M, R1), tree(Z, L, M, R2)) :-
	not X=Z,
	not memberTree(X, L),
	not memberTree(X, M),
	memberTree(X, R1),
	subsFirst(X, Y, R1, R2).

memberTree(X, X).
memberTree(X, tree(X, L, M, R)).
memberTree(X, tree(Element, L, M, R)) :- memberTree(X, L).
memberTree(X, tree(Element, L, M, R)) :- memberTree(X, M).
memberTree(X, tree(Element, L, M, R)) :- memberTree(X, R).


testTree(T) :-   T = tree(5,  tree(4, tree(7, tree(1,void,void,void),
                                              tree(2,void,void,void),
                                              tree(3,void,void,void) ),
                                      tree(d, tree(a,void,void,void),
                                              tree(b,void,void,void),
                                              tree(c,void,void,void) ),
                                      void
                                   ),
                             tree(5,  tree(d, tree(a,void,void,void),
                                              tree(b,void,void,void),
                                              tree(c,void,void,void) ),
                                      void,
                                      tree(8, tree(3,void,void,void),
                                              tree(2,void,void,void),
                                              tree(1,void,void,void) )
                                  ),
                             tree(6,  void,
                                      tree(5, tree(7,void,void,void),
                                              tree(8,void,void,void),
                                              tree(9,void,void,void) ),
                                      tree(f, tree(a,void,void,void),
                                              tree(1,void,void,void),
                                              tree(5,void,void,void) )
                                  )
                         ).
