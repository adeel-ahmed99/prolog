/* mergesort on cons cells representation of lists (LISP) */

qs(nil, nil).
qs(Input, Output) :- Input = next(X, Others), part(X, Others, Ls, Bs),
	qs(Ls, Lsorted),
	qs(Bs, Bsorted),
	mergeLists(Lsorted, next(X, Bsorted), Output).

part(X, nil, nil, nil).
part(X, next(N, T), next(N, T2), Bs) :- X > N, part(X, T, T2, Bs).
part(X, next(N, T), Ls, next(N, T2)) :- N >= X, part(X, T, Ls, T2).

mergeLists(nil, Bs, Bs).
mergeLists(next(H, T), Bs, next(H, Tail)) :- mergeLists(T, Bs, Tail).
