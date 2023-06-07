+++
title = "Prolog"
date = 2023-05-04
[taxonomies]
tags = ["Programming Language Principles"]
[extra]
author = "JS970"
katex= true
+++
## Prolog Intro
---
### Prolog History
- 1972년에 Alain colmerauer와 Philippe Roussel이 만들었다.
- 1979년에 Kowalski의 논문 Algorithm = Logic + Control에서 소개된 이후 널리 알려졌다.
- 일본 정부에서 5세대 프로젝트의 기본 언어로 채택되는 등 나름 영향력이 있었다.

### Prolog Resources
- Prolog Env
	- [SWI Prolog](http://www.swi-prolog.org/)
	- [Visual Prolog](http://www.visual-prolog.com/)
	- [Strawberry Prolog](http://www.dobrev.com/)
- Prolog Docs
	- [J.R. Fisher, Prolog Tutorial](https://www.cpp.edu/~jrfisher/www/prolog_tutorial/contents.html)
	- [Prolog part1 - General core](https://www.iso.org/standard/73194.html)
	- [J.P.E. Hudgson, Prolog : The ISO Standard Documents, 1999](https://pauillac.inria.fr/~deransar/prolog/docs.html)
- Prolog Books
	- [Ivan Bratko, Prolog Programming for Artificial Intelligence, 4th Ed., AddisonWesley, 2012](https://www.pearson.com/uk/educators/higher-education-educators/program/Bratko-Prolog-Programming-for-Artificial-Intelligence-4th-Edition)
	- [Patrick Blackburn, Johan Bos and Kristina Striegnitz, Learn Proglog Now!, College Publication, 2006](https://www.learnprolognow.org/)
	- [Dennis Merritt, Building Expert System in Prolog, Springer-Verlag, 1989](https://www.amzi.com/ExpertSystemsInProlog/index.htm)

### 순차적 프로그래밍 언어 vs 선언적 프로그래밍 언어
- 순차적 프로그래밍 언어(Procedural Language)
	- BASIC, FORTRAN, C++, Pascal, Java, ...
	- `computational step`을 일일히 명시해야 한다.
	- `computational step`이란 `instruction`, `statement`, `procedure`을 통한 계산 과정이다.
	- `어떻게(How)`문제를 풀어야 하는지 기술한다.
- 선언적 프로그래밍 언어(Declarative Language)
	- LISP, Prolog, ML, ...
	- `computational rules`를 기술한다.
	- `fact`는 `computational rules`의 한 종류이다.
	- `무엇(What)`을 풀어야 하는지 기술한다.
- 사실 순차적 프로그래밍 언어와 선언적 프로그래밍 언어에서 문제의 기술에 관한 부분은 현실에서 항상 명확히 구별되지는 않는다.
	- 순차적 프로그래밍 언어에서 타입 선언에 관한 부분은 `What`으로 생각할 수 있다.
	- Prolog의 cut은 `How`에 대한 기술로 생각할 수 있다.

### Computational Model of Prolog
- 1차 술어 계산(1st-order predicate calculus)을 기반으로 한다.
- `Rule`은 `Horn clause`를 이용하여 표기한다.(CNF, Conjunctive Normal Form)
	```Prolog
	interesting(L) :- lectureByWoo(L), language(L).
	```
- `Fact`는 아무 조건 없이 상상 성립하는 `Rule`이다.
	```Prolog
	fact.
	```
- `Goal`은 사실인지 확인하고 싶은 명제에 대해 질의하는 것을 의미한다. 질의의 결과는 참 또는 거짓이다.
	```Prolog
	?- goal.
	```
- 아래는 `Rule`, `Fact`를 포함하는 Prolog프로그램의 예시이다.
	```Prolog
	lectureByWoo(prolog).
	lectureByWoo(scheme).
	language(prolog).
	language(scheme).

	interesting(L) :- lectureByWoo(L), language(L).
	```
- 위 프로그램을 실행하여 질의하면 아래와 같다.
	```Prolog
	?- interesting(prolog).
	true.

	?- interesting(scheme).
	true.

	?- interesting(cpp).
	false.
	```

## SWI-Prolog Basic
---
### 기본 사용법
- 프로그램 소스 편집
	```Prolog
	edit(file('filename.pl')).
	```
- 프로그램 파일 참조(load). 두 표현은 같은 표현이다.
	```Prolog
	?- consult(filename).

	?- [filename].
	```
- 질의
	- parent에 관한 아래와 같은 `rule`이 있다.
	```Prolog
		son(jim, jane).
		son(jim, john).
	
		parent(X, Y) :- son(Y, X).
	```
	- 아래 질의에서는 parent `rule`을 만족시키는지를 반환한다.
	```Prolog
		?- parent(jane, jim).
	```
	- 아래 질의에서는 목적을 명시하여 답변을 얻는다.
	- 질의가 true가 되도록 하는 결과를 출력한다.
	- 답변에 만족했다면 질의 이후 "enter"를 입력하면 질의가 종료된다.
	- 다른 답변을 원한다면 질의 이후 ";"를 입력하여 게속 질의할 수 있다.
	```Prolog
		?- parent(X, jim).
	```
	- 답변 출력(jane에서 `;`를 입력하여 다른 답을 요청했다)
	```Prolog
		X = jane ;
		X = john.
	```
- 해석기 종료
	```Prolog
		?- halt.
	```

### Prolog = predicate + term
- Prolog는 `computational rules`를 `Horn clause`를 사용하여 정의한다.
- `Horn clause`는 `predicate`(술어) 와 `term`(항)으로 구성된다.
- `predicate`(술어) : 소문자로 시작하며, 상수의 일종으로 생각할 수 있다.
- `term`(항): 변수 또는 상수이다.
	- 변수 : `_`또는 대문자로 시작한다.
	- 상수 : 소문자로 시작한다.
- `Clause`(절) : `predicate`의 개별 정의를 `clauses`라고 한다.
	- `fact`, `rule`모두 `Clause`에 포함된다.
	- 아래 문장은 `fact`로 이루어진 하나의 `Clause`이다.
		```Prolog
		parent(jane, alen).
		```
		- `body`없이 `fact`로만 이루어져 있으므로 항상 참이다.
	- 아래 문장은 두 개의 `Clause`로 이루어진 `rule`이다.
		```Prolog
		parent(X, Y) :- mother(X, Y).
		```
		- 좌항은 `head`, 우항은 `body`라고 한다.

### Arguments
- `predicate`는 인수를 받을 수 있다.
- `term`은 `상수`, `변수`, `복합형` 중 하나의 형태이다.
	- `상수` : 소문자로 시작하는 이름을 가진다.
		- 수(number) : 정수 및 부동소수점 수
		- 기호상수(symbolic constants) : 항상 소문자로 시작되어야 하며, 숫자, `_`기호가 그 뒤로 올 수 있다.
		- 문자열 상수(string constants) : 작은 따음표로 감싼 형태이다. 꼭 대문자를 사용하여 상수명을 지정하고 싶을 경우 사용한다.
	- `변수` : 대문자 또는 `_`로 시작하는 이름을 가진다.
		- Prolog에서 `변수`, `상수`는 type을 가지지 않는다. 즉 어떠한 값이든 될 수 있다.
		- Prolog에서 모든 `변수`는 local variable이다.
		- `변수`의 값은 같은 절(clause)내에서는 일정하며, 절 외부의 값을 유지하는경우는 없다.
	- `복합형` : 여러 항을 functional constructor(functor)로 묶은 것이다.
		- data constructor이다.
		- function으로 구성된다.
		- list역시 복합형이다.

### Lists
- 리스트는 `복합형` `term`이며, 아래의 두 가지 형태 중 하나의 형태를 가진다.
	- 빈 리스트
	- 원소가 하나 이상인 리스트
- 일반 항을 사용할 때 아래의 두 가지 패턴 중 하나를 사용하면 된다.
	- 빈 리스트 : `[]`
	- 원소가 하나 이상인 리스트 : `[H|T]`
- 아래는 리스트 사용 예시이다.
	```Prolog
	sum([], 0).
	sum([H|T], X) :- sum(T|Y), X is H + Y.

	?- sum([1, 2, 3, 4], X).
	X = 10
	```
	- X = 10이 유도되는 과정은 아래와 같다.
		1. sum([1, 2, 3, 4], X) = sum([2, 3, 4], Y), X = 1 + Y
		2. sum([2, 3, 4], X) = sum([3, 4], Y), X = 2 + Y
		3. sum([3, 4], X) = sum([4], Y), X = 3 + Y
		4. sum([4], X) = sum([], Y), H = 4 + Y, Y = 0, X = H + Y = 4
		5. by 4, 3's Y is 4, 3's X is 7
		6. by 3, 2's Y is 7, 2's X is 9
		7. by 2, 1's Y is 9, 1's X is 10
		8. by 1~7, sum([1, 2, 3, 4], X). X = 10
	- 참고로 Prolog는 선언적 프로그래밍 언어이므로, 위 프로그램의 1행과 2행의 위치를 바꾸어도 정상적으로 동작한다.

### Unification(단일화)
- 변수가 포함된 두 개의 항을 일치시키는 것을 의미하므로 `동형화`라고 볼 수도 있다.
- 두 항의 단일화가 가능하다면 `일치(match)`한다고 한다.
- 구조와 인수가 맞아야 사용 가능하므로, 서로 다른 상수, 상수와 변수 간에는 `match`가 불가능하다.
- 아래는 단일화의 예시이다.
	```Prolog
	?- loves(john, X) = loves(Y, marry).
	X = mary, Y = john

	?- loves(john, X) = loves(mary, X).
	false.
	```

### Computation
- Prolog에서는 `단일화(unification)`중 `computation`이 일어난다.
- `computation` : `is/2` 술어를 통해 수행된다. 
- 값을 계산하기 위해 술어 `is`를 사용해야 하는 것에 주의하자, `=`를 사용할 경우 Prolog는 연산하지 않고 값을 그대로 보여준다.
- 아래는 리스트 절에서 다룬 sum프로그램의 `is`를 `=`로 변경한 코드와 그 실행 결과이다.
	- 코드
		```Prolog
		sum([], 0).
		sum([H|T], S) :- sum(T, S1), S = H + S1.
		```
	- 실행 결과                                                             ![predecate test](/image/PL/isPredecateTest.png)

### Factorial in Prolog
- 아래 프로그램은 Prolog에서 Factorial을 계산하는 코드이다.
	```Prolog
	fact(0, 1).
	fact(N, M) :-
		N > 0,
		N1 is N - 1,
		fact(N1, M1),
		M is N * M1.
	```

## Prolog and Tail Recursion
---
### Tail Recursion
- 아래 코드는 계산 결과를 저장하는 변수(M)의 연산이 이뤄지는 부분에서 재귀 이외의 연산이 있다.
	```Prolog
	fact(0, 1).
	fact(N, M) :-
		N > 0,
		N1 is N-1,
		fact(N1, M1),
		M is N * M1.
	```
	- 연산 과정을 자세히 살펴보자. 10!을 연산하기 위해서는 아래와 같이 질의해야 한다.
		```Prolog
		?- fact(1, X).
		```
	- 이때 X는 질의 결과를 저장하는 변수임과 동시에 계산 과정의 중간 결과를 저장하는 변수이다.
	- 프로그램의 마지막 줄에서 M is N * M1부분이 있는데, M1은 fact(N1, M1).의 호출을 통해 도출된다.
	- X의 값을 구하기 위한 부분에서 fact의 호출 후 이를 N과 곱하는 연산이 추가로 일어나는 것을 확인할 수 있다.
	- 따라서 위 코드는 Tail Recursion이 아니다.
- Tail Recursion조건을 만족하도록 `fact/3`을 작성하면 아래와 같다.
	```Prolog
	fact(0, M, M).
	fact(N, Acc, F) :-
		N > 0,
		N1 is N - 1,
		Acc1 is Acc * N,
		fact(N1, Acc1, F).
	```
	- 질의 결과를 저장하는 변수 F와 계산의 중간 결과를 저장하는 Acc를 따로 설정하여 전달하므로 재귀 과정에서 `fact/3`의 호출 이외의 연산이 일어나지 않는다.
	- 따라서 위 코드는 Tail Recursion 조건을 만족한다.

### Tail Recursion과 연산 순서
- 앞서 연산은 `is/2`로만 이루어지고 `=`를 사용할 경우 연산 없이 그대로 출력한다고 했다. 이를 이용해서 연산 순서 및 결합 방향에 대해 알아보자.
- 아래는 Tail Recursion 조건을 만족하지 않는 sum함수이다.
	```Prolog
	sum([], 0).
	sum([H|T], S) :- sum([T|S1], S1), S is H + S1.	
	```
	- 위 코드의 `is`를 `=`로 수정하여 연산 순서를 확인하면 아래와 같다.![predecate test](/image/PL/isPredecateTest.png)
- 아래는 같은 프로그램을 Tail Recursion 조건을 만족하도록 하여 구현한 코드이다.
	```Prolog
	sum([], Si, Si).
	sum([H|T], Acc, So) :-
		Acc1 is H + Si,
		sum(T, Acc1, So).
	```
	- 위 코드의 `is`를 `=`로 수정하여 연산 순서를 확인하면 아래와 같다.![tailAssign](/image/PL/tailAssign.png)
- Tail Recursion의 경우 Top-Down으로 연산한다. Tail Recursion이 아닌 Recursion의 경우 Bottom-up으로 연산한다.

## SWI-Prolog Debugging
---
### 4 Port Model of prolog Execution
![Four Port Model](/image/PL/fourPortModel.png)
- 위 그림은 Prolog의 프로그램이 실행되는 상태 전이 모형을 나타낸 것이다.
- `Call` : 프로그램이 처음 호출되었을 대 사용되는 포트
- `Exit`:  프로그램이 진행되어 실행이 종료될 때 사용되는 포트
- `Fail` : 프로그램 실행 중 완전히 실패(failure)한 경우 사용되는 포트
- `Redo` : failure한 경우 다른 정답을 찾으려 시도할 때 사용되는 포트

### Enable Debugging
- `trace/0` : 모든 포트에서 정지하도록 설정
- `nottrace/0` : 정지 설정을 끈다.
- `debug/0` : 디버깅 모드를 활성화한다.
- `nodebug/0` : 디버깅 모드를 종료한다.

### Debugging Example
- 아래는 짝수인지 판별하는 결함이 있는 Prolog 코드이다.
	```Prolog
	isEven(2).
	isEven(X) :-
		Y is X - 2,
		isEven(Y).
	```
	- 위 코드의 입력으로 짝수가 주어졌을 때는 프로그램이 정상적으로 동작한다.![isEven(4) Nobug](/image/PL/noBugDebugging.png)
	 - 하지만 입력으로 홀수가 주어졌을 때 프로그램이 종료되지 않는 문제가 있다.![isEven(5) Bug](/image/PL/isEven5Bug.png)
- 버그를 수정하기 위해 `fail/0`을 사용하여 홀수에 대한 처리를 해 주자.
	```Prolog
	isEven(1) :- fail.
	isEven(2).
	isEven(X) :-
		Y is X - 2,
		isEven(Y).
	```
	- 하지만 여전히 종료되지 않고 계속해서 실행되는 문제가 있다.![isEven(5) Bug2](/image/PL/isEven5BugRedo.png)
	- 이는 `fail`을 유도하지 않는 다른 정답에 대해 계속해서 탐색하기 때문이다.
- 프로그램이 되추적을 중단시키도록 `cut`을 사용하도록 코드를 수정한다.
	```Prolog
	isEven(1) :-
		!, fail.
	isEven(2).
	isEven(X) :-
		Y is X - 2,
		isEven(Y).
	```
	- `cut`은 위와 같이 `!`으로 표기한다.
	- 이제는 프로그램이 정상적으로 홀수에 대해서도 처리하는 것을 확인할 수 있다.![isEven(5) No Bug](/image/PL/isEven5NoBug.png)

### N-Queen's Problem with Prolog
- 다른 프로그래밍 언어에 비해 매우 간단하게 이 문제를 해결할 수 있다.
- 아래는 N-Queen's Problem을 해결하는 Prolog코드이다.
	```Prolog
	queens(N, Qs) :-
		range(1, N, Ns),
		permutation(Ns, Qs),
		safe(Qs).

	safe([]).
	safe([Q|Qs]) :-
		safe(Qs),
		not(attack(Q, Qs)).

	attack(X, Xs) :-
		attack(X, 1, Xs).

	attack(X, N, [Y|_]) :-
		X is Y + N; X is Y - N.

	attack(X, N, [_|Ys]) :-
		N1 is N + 1,
		attack(X, N1, Ys).

	range(N, N, [N]).
	range(M, N, [M|Ns]) :-
		M < N,
		M1 is M + 1,
		range(M1, N, Ns).
	```
- 위 프로그램을 이용하여 4-Queen, 6-Queen에 대해 정답을 출력한 결과이다.![NQueens Prolog](/image/PL/nqueensProlog.png)
