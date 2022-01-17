/* basic parser that can be used to return yes / no responses to queries about flights in knowledge base below */

/* flight facts */
flight(ac077, airCanada, toronto, montreal).
flight(aa200, americanAirlines, ny, london).
flight(ac610, airCanada, toronto, losAngeles).
flight(aa300, americanAirlines, ny, austin).
flight(ua95, unitedAirlines, chicago, toronto).
flight(ac987, airCanada, edmonton, montreal).
flight(ac087, airCanada, vancouver, shanghai).
flight(aa110, americanAirlines, dallas, miami).
flight(aa250, americanAirlines, boston, philadelphia).
flight(ac600, airCanada, toronto, quebecCity).
flight(ac900, airCanada, toronto, paris).
flight(ba200, britishAirways, london, liverpool).
flight(ac500, airCanada, montreal, ny).
flight(ac088, airCanada, toronto, beijing).
flight(ac089, airCanada, toronto, shanghai).
flight(ac111, airCanada, toronto, vancouver).

dtime(aa300, ny, 0200).
dtime(ua95, chicago, 1400).
dtime(ac987, edmonton, 0600).
dtime(ac087, vancouver, 1200).
dtime(ac077, toronto, 0700).
dtime(aa200, ny, 1100).
dtime(aa110, dallas, 1500).
dtime(aa250, boston, 1900).
dtime(ac600, toronto, 0800).
dtime(ac900, toronto, 0900).
dtime(ac610, toronto, 1200).
dtime(ba200, london, 1500).
dtime(ac500, montreal, 0700).
dtime(ac088, toronto, 0500).
dtime(ac089, toronto, 0500).
dtime(ac111, toronto, 1000).

atime(aa300, austin, 0600).
atime(ua95, toronto, 1800).
atime(ac987, montreal, 1600).
atime(ac087, shanghai, 2200).
atime(ac077, montreal, 1240).
atime(aa200, london, 1800).
atime(aa110, miami, 2000).
atime(aa250, philadelphia, 2300).
atime(ac600, quebecCity, 1400).
atime(ac900, paris, 1330).
atime(ac610, losAngeles, 1600).
atime(ba200, liverpool, 1900).
atime(ac500, ny, 1230).
atime(ac088, beijing, 1500).
atime(ac089, shanghai, 1800).
atime(ac111, vancouver, 1200).

location(quebecCity, canada).
location(montreal, canada).
location(edmonton, canada).
location(vancouver, canada).
location(toronto, canada).
location(ny, america).
location(dallas, america).
location(boston, america).
location(chicago, america).
location(philadelphia, america).
location(miami, america).
location(austin, america).
location(losAngeles, america).
location(liverpool, uk).
location(london, uk).
location(shanghai, china).
location(beijing, china).
location(paris, france).


/* helper predicate to calculate travel time */
/* elapsed time is in same format: HHMM */
elapsed(Dtime, Atime, Time) :-
	Hours is ((Atime - Dtime) // 100),
	Minutes is (Atime mod 100 - Dtime mod 100) mod 60,
	Time is 100*Hours + Minutes.


/* LEXICON
================================================
*/

article(a).
article(an).
article(any).
article(the).

adjective(domestic, Flight) :-
	flight(Flight, _, City1, City2),
	location(City1, Country),
	location(City2, Country).
adjective(international, Flight) :-
	flight(Flight, _, City1, City2),
	location(City1, Country1),
	location(City2, Country2),
	not Country1 = Country2.
adjective(departure, Flight) :- dtime(Flight, _, Time).
adjective(arrival, Flight) :- atime(Flight, _, Time).
adjective(morning, Flight) :-
	flight(Flight, _, _, _),
	dtime(Flight, _, Time),
	Time >= 500,
	900 > Time.
adjective(day, Flight) :-
	flight(Flight, _, _, _),
	dtime(Flight, _, Time),
	Time >= 900,
	1200 > Time.
adjective(afternoon, Flight) :-
	flight(Flight, _, _, _),
	dtime(Flight, _, Time),
	Time >= 1200,
	1700 > Time.
adjective(evening, Flight) :-
	flight(Flight, _, _, _),
	dtime(Flight, _, Time),
	Time >= 1700,
	2200 > Time.
adjective(canadian, City) :- location(City, canada).
adjective(chinese, City) :- location(City, china).
adjective(american, City) :- location(City, america).
adjective(airCanada, Flight) :- flight(Flight, airCanada, _, _).
adjective(unitedAirlines, Flight) :- flight(Flight, unitedAirlines, _, _).
adjective(britishAirways, Flight) :- flight(Flight, britishAirways, _, _).
adjective(americanAirlines, Flight) :- flight(Flight, americanAirlines, _, _).
adjective(shortest, Flight) :-
	flight(Flight, _, Origin, Dest),
	dtime(Flight, Origin, DTime),
	atime(Flight, Dest, ATime),
	elapsed(DTime, ATime, Time),
	not (flight(Flight2, _, Origin, Dest),
	 	not Flight = Flight2,
		dtime(Flight2, Origin, DTime2),
		atime(Flight2, Dest, ATime2),
		elapsed(DTime2, ATime2, Time2),
		Time > Time2).
adjective(long, Flight1) :-
    flight(Flight1, _, Origin, Destination),
    flight(Flight2, _, Origin, Destination),
    not Flight1 = Flight2,
    dtime(Flight1, Origin, DTime1),
    atime(Flight1, Destination, ATime1),
    dtime(Flight2, Origin, DTime2),
    atime(Flight2, Destination, ATime2),
    elapsed(DTime1, ATime1, Time1),
	elapsed(DTime2, ATime2, Time2),
    Time1 > Time2.

/* long and shortest flight adjectives remaining */


common_noun(flight, X) :- flight(X, _, _, _).
common_noun(city, X) :- location(X, _).
common_noun(country, X) :- location(_, X).
common_noun(time, X) :- atime(_, _, X).
common_noun(time, X) :- dtime(_, _, X).

/* CITIES */
proper_noun(X) :-
	not article(X), not common_noun(X,_),
	not adjective(X,_), not preposition(X,_,_).


preposition(in, X, Y) :- location(X, Y).
preposition(to, X, Ref) :- flight(X, _, _, Ref).
preposition(to, X, Ref) :- flight(X, _, _, City), location(City, Ref).
preposition(from, X, Ref) :- flight(X, _, Ref, _).
preposition(from, X, Ref) :- flight(X, _, City, _), location(City, Ref).


/******************* parser **********************/

what(Words, F) :- np(Words, F).

/* Noun phrase can be a proper name or can start with an article */

np([Name],Name) :- proper_noun(Name).
np([Art|Rest], F) :- article(Art), np2(Rest, F).


/* If a noun phrase starts with an article, then it must be followed
   by another noun phrase that starts either with an adjective
   or with a common noun. */

np2([Adj|Rest],Who) :- adjective(Adj,Who), np2(Rest, Who).
np2([Noun|Rest], Who) :- common_noun(Noun, Who), mods(Rest,Who).


/* Modifier(s) provide an additional specific info about nouns.
   Modifier can be a prepositional phrase followed by none, one or more
   additional modifiers.  */

mods([], _).
mods(Words, Who) :-
    appendLists(Start, End, Words),
    prepPhrase(Start, Who),    mods(End, Who).

prepPhrase([Prep|Rest], F) :-
    preposition(Prep, F, Ref), np(Rest, Ref).

appendLists([], L, L).
appendLists([H|L1], L2, [H|L3]) :-  appendLists(L1, L2, L3).
