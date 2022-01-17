/* simple recursive predicates in prolog without use of built-ins */

/* nth element of list */
nth(1, [X | _], X).
nth(N, [_ | T], X) :-
	Index is N-1,
	nth(Index, T, X).

/* true if 2nd list is the same as 1st without X */
remove(X, [], []).
remove(X, [X | T], OutputList) :- remove(X, T, OutputList), not OutputList = [X | T].
remove(X, [H | T], [H | T2]) :- remove(X, T, T2), not X = H.

/* split input list into even and odd numbers */
splitEvenOdd([], [], []).
splitEvenOdd([H | T], [H | T2], List2) :- X is H mod 2, X=0, splitEvenOdd(T, T2, List2).
splitEvenOdd([H | T], List1, [H | T2]) :- X is H mod 2, X=1, splitEvenOdd(T, List1, T2).

/*  length of list1 + length of list2 < length of list 3 */
lessThanEq([], [], List3).
lessThanEq([H | T], List2, [H2 | T2]) :- lessThanEq(T, List2, T2).
lessThanEq([], [H | T], [H2 | T2]) :- lessThanEq([], T, T2).

/* generate pascals triangle of size N */
row(1, [1]).
row(N, Row) :- N2 is N-1, row(N2, PrevRow), verifyRow(Row, [0 | PrevRow]).

verifyRow([1], [1]).
verifyRow([A | B], [H1, H2 | T]) :- verifyRow(B, [H2 | T]), X is H1 + H2, A = X.
