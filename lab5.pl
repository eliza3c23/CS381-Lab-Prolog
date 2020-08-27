%Eliza Nip
% CS 381 Lab

% Load the file royal.pl
:- consult('royal.pl').

% mother/2: M is C's parent. M is female
mother(M,C):- parent(M,C),female(M).
% father/2: F is C's parent. F is male
father(F,C):- parent(F,C),male(F).
% spouse/2: M is the spouse of F. F is the spouse of M
spouse(M,F):- married(M,F); married(F,M).
% child/2: C is P's child. P is C's parent
child(C,P) :- parent(P,C).
%son/2: S is P's son. S is male.
son(S,P):- child(S,P),male(S).
%daughter/2: D is P's daughter.D is female. 
daughter(D,P):- child(D,P),female(D).
%sibling/2: P is S1's parent, P is S2's parent. S1 is not S2.
sibling(S1,S2):- parent(P,S1),parent(P,S2), S1 \= S2.
%brother/2: B is S's brother. B is male.
brother(B,S) :- sibling(B,S),male(B).
%sister/2 S is C's sister. S is female.
sister(S,C) :- sibling(S,C),female(S).
%uncle/2 (Two rules: One by blood;One by marriage)
% U is A's uncle by blood. A is P's child. U is P's brother.
% U is A's uncle by marriage. U is the spouse of S. P is S's sister. P is A's parent.
uncle(U,A) :- parent(P,A),brother(U,P); parent(P,A),spouse(U,S),sister(S,P).

%aunt/2 (Two rules: One by blood;One by marriage)
% A is N's aunt by blood. N is P's child. A is P's sister.
% A is N's aount by marriage. A is the spouse of U. P is U's brother. P is N's parent.
aunt(A,N) :- parent(P,N),sister(A,P); parent(P,N),spouse(A,U),brother(P,U).

%grandparent/2: G is C's grandparent. P is C's parent. G is P's parent.
grandparent(G,C) :- parent(G,P),parent(P,C).
%grandfather/2: G is C's grandparent. P is C's parent. G is P's parent. G is male.
grandfather(G,C) :- grandparent(G,C),male(G).
% grandmother/2: G is C's grandparent. P is C's parent. G is P's parent. G is female.
grandmother(G,C) :- grandparent(G,C),female(G).
% grandchild/2 C is G's grandchild. C is child of P. P is child of C. 
grandchild(C,G) :- grandparent(G,C).
% ancestor/2
    % ancestor(X, Y)means X is the ancestor of Y
% https://en.wikibooks.org/wiki/Prolog/Recursive_Rules#:~:text=A%2C%20B).-,ancestor(A%2C%20B)%20%3A%2D%20parent(A%2C%20X,ancestor(steve%2Cjohn).
% Base case. X is parent of Y.
ancestor(X,Y) :- parent(X,Y).
% Recusive case.
ancestor(X,Y) :- parent(X,Z),ancestor(Z,Y).
% descendant/2
    % descendant(X, Y)means X is the descendant of Y
% Base case. X is child of Y.
descendant(X,Y) :- child(X,Y).
% Recusive case.
descendant(X,Y) :- child(X,Z),descendant(Z,Y).

% older/2: Older(X,Y)means X is older than Y.
% Born(X,A) means X was born in A yr.Born(Y,B)means Y was born in B yr.
% A yr < B yr
older(X,Y) :- born(X,A),born(Y,B),A<B. 
%younger/2: Younger(X,Y)means X is younger than Y.
% Born(X,A)means X was born in A yr.Born(Y,B)means Y was born in B yr.
% A yr > B yr
younger(X,Y) :- born(X,A),born(Y,B),A>B.
% regentWhenBorn/2
    % regentWhenBorn(X, Y) should ask who was King/Queen(X) when person Y was born.
    % reigned(A,B,C)means A(King/Queen) reigns from B yr to C yr.
    % born(P,D)means P person was born in D yr.
    % A yr needs to be > X yr and < Y yr
regentWhenBorn(X,Y) :- reigned(X,B,C),born(Y,D),D>B,D<C.
% ----------------------------------------------------------------------------------
% Extra credit:
% cousin/2:First cousin relationship. A child of one's uncle/aunt.
% Cousin(X,Y)means X is Y's cousin. 
    % X is a child of Y's uncle/aunt -> child(X,U),child(X,A)
    % U is Y's uncle -> uncle(U,Y)
    % A is Y's aunt -> aunt(A,Y)
cousin(X,Y) :- uncle(U,X),child(Y,U),spouse(U,A1),mother(A1,Y), X\=Y | aunt(A,X),child(Y,A),spouse(A,U1),father(U1,Y), X\=Y.

%     % P1,P2 could be either uncle or aunt.
%     % P1 is parent of X.
%     % P2 is parent of Y.
%     % P1 and P2 are syblings.
% cousin(X,Y) :- parent(P1,X),parent(P2,Y),sibling(P1,P2), P1 \= P2, X \= Y.
% ----------------------------------------------------------------------------------
% Output format
portray(Term) :- atom(Term), format("~s", Term).