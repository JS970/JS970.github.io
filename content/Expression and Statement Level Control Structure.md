+++
title = "Expression and Statement Level Control Structure"
date = 2023-05-30
[taxonomies]
tags = ["Programming Language Principles"]
[extra]
author = "JS970"
katex= true
+++
## Control Flow(제어 구조)
---
### Control flow란?
- 제어분과 제어문에 의해 제어되는 문장의 집합
- 구조화 프로그래밍에서 모든 순서도는 `선택구조` 와 `반복구조` 만으로 표현이 가능하다.(prime component)
	- 구조화 프로그래밍이란?![Structure Programming](/image/PL/structure_programming.png)
- 위에서 아래로의 수행 흐름을 순차적 수행 흐름이라고 한다.
- 괄호, goto문, 문장 레이블 등을 통해 수행 흐름을 명시적으로 표기한다.
- 표현식 내에서의 수행 흐름, 문장 사이의 수행 흐름, 단위 프로그램(sub program, thread)사이의 수행 흐름이 있다.

### Control flow의 종류
- 수식 수준의 Control flow
	- Short-Circuit Evaluation
- 문장 수준의 Control flow
	- Statement-Level Control Structure
	- Goto Controversy
	- Guarded Commands

## Short-Circuit Evaluation
---
- 수식 수준에서의 control flow(제어 구조)

### 단락회로 계산
- 연산항 전부를 계산하지 않은 상태에서 연산식의 결과를 계산하는 것이다.
- 대개 논리식이나 조건 연산자에 적용된다.
	```Python
	A * (B / 13 - 1), (A >= 0) and (B < 10)
	```
	- 단락회로 계산을 지원할 경우 위 수식에서는 **A가 0 이상일 경우 and이후로는 연산할 필요가 없다**.
- `Pascal` 은 단락회로 계산을 지원하지 않는다.
- `C`, `C++`, `Java`, `Modula-2` 는 논리곱, 논리합에 대한 단락회로 계산을 지원한다.
- `Ada`는 프로그래머가 단락회로 계산 여부를 선택할 수 있다.
- 단락회로를 사용함으로써 간결한 표현이 가능하다.
	```python
	while (index <= listlen) and (list[index] <> key) do ...
	```
- 하지만 부대효과가 있는 연산항에 대해서는 결과 예측이 힘들다는 단점이 있다.
	```Python
	(a > b) || (b++ / 3)
	```
	- 위 예시에서는 증감연산자의 실행 여부가 직관적이지 않다는 문제가 있다. 이는 프로그램의 결과 예측을 힘들게 한다.

### 대입문
- 변수 값을 (동적으로) 지정하는 문장이다.
- `=` 또는 `:=` 를 사용한다.
- 대입 기호가 관계 연산과 겹지정되면 혼란을 초래할 수 있다.
	```PL/I
	A = B = C
	```
	-  위 수식에서 B = C는 비교연산으로 사용되었고,  A = ~에서의 =는 대입 연산으로 사용되었다.
- 대입문으로는 아래와 같은 구문들이 존재한다.
	- 단순 대입문(BASIC, C)
		```C
		a = a + 3;
		```
	- 다중 목적지(PL/I)
		```PL/I
		a, b = 0;
		```
	- 조건 목적지(C++)
		```c++
		flag ? a : b = 0;
		```
		- C, Java에서는 지원하지 않는다.
		- 옛날 C언어에서는 지원했다.
	- 복합 대입문(C, C++, Java, Python)
		```C
		a += 3;
		```
	- 다중 대입문(Python, Lua)
		```Lua
		a, b = 3, 4;
		```

### 대입 연산식
- 대입 연산을 문장으로 간주하지 않고 표현식으로 간주한다.
- C, C++, Java에서 이러한 방식을 채택했다.
- Python에서도 `walrus operator`(`:=`)형태로 채택했다.
	```Python
	while(line := input()):
	```
	- 위 경우에는 괄호가 선택이다.
	```Python
	buf = (line := input())
	```
	- 위 경우에는 괄호가 필수이다.
- 대입 연산의 결과 치환된 값을 반환한다.
- 대입 연산식을 사용할 경우 간결한 표현을 할 수 있다는 장점이 있다.
- 하지만 표현식에서 부대효과가 발생한다는 단점이 있다.
	```C
	a = b = c = 3.14
	```
	- a, b, c의 type에 따라 결과가 달라진다.

## Statement-Level Control Structure
---
- 문장 수준의 흐름 제어로는 `순차 구조`, `선택 구조`, `반복 구조` 가 있다.

### 구조화 프로그래밍
- 프로그램 구조를 계층적으로 설계한다.
- 계층 구조는 프로그램 코드에 그대로 반영된다.
- 문장의 공간적 배치 순서가 수행 순서에 대응된다.
	- Readability 보장
- 한 문장은 단일 목적으로만 사용해야한다.
	- Readability, Debugging, 유지보수성 측면에서 유리하다.

### 선택문
- 둘 이상의 경로 중 하나를 선택할 수 있도록 하는 제어문
- 기본 제어 구조 중 하나이다.
- 아래는 선택문 유형 도식이다.![Selection](/image/PL/selection.png)
	- 3 방향 선택문이 사용되는 언어로는 FORTRAN이 있다.(음, 0, 양)
	- C++20에서 `<=>`연산자를 통해 3 방향 선택문이 구현되었다.
- 설계 고려 사항
	- 조건식의 형태와 타입
	- 선택 가능한 형태로는 어떠한 형태가 있는가?(양방향, 단방향, 3방향)
	- 중첩된 선택구조의 해석 방법(dnagling else)

### 선택문의 중첩(dangling else)
```Python
if sum = 0 then
	if count = 0 then
		result := 0
else
	result := 1
```
- 마지막에 사용된 else 구문이 중첩된 if문과 짝을 이루는지, 상위에 있는 if문과 짝을 이루는지 구분할 규칙이 필요하다.
- 해결책(규칙)으로는 아래와 같은 방법이 있다.
	- 근거리 우선 : 짝이 없는 가장 가까운 앞쪽 if와 짝을 이룬다.(Pascal, C, C++, Java)
	- 직접 중첩 금지 : if문이 중첩되려면 복합문을 사용해야 한다.(Algol 60)
		- 복합문은 begin - end 블럭을 의미한다.
	- 종결어 사용 : if의 종결어(end if, fi 등)를 사용하여 끝을 나타낸다.(FORTRAN 90, Ada, Lua)

### 반복문
- 반복 구조를 나타내기 위한 두 가지 방법으로 반복문과 재귀 호출이 있다.
- 반복 구조로는 아래와 같은 세 가지 구조가 있다.
	- counter-controlled repetition(계수기에 따른 반복 구조) : 횟수에 따라 반복하는 for문
	- condition-controlled repetition(조건에 따른 반복 구조) : while, do-while, repeat-until
		- 보통은 셋 다 지원하거나 두 가지 이상 지원하는데 특이하게 python은 while만 지원한다.
	- repetion over data structure(자료 구조에 대한 반복 구조) : foreach, for-in
		- range-based for loop이다.
- 반복문 설계 고려 사항으로는 아래와 같은 사항이 있다.
	- 제어 부분이 반복문의 어디에 위치하는가?
	- break기능을 지원하는가?
		- Java의 경우 labeled break를 지원하다.(원하는 계층까지 break)

## GOTO controversy
---
- 무조건 분기 GOTO에 대한 논란이다.
- Dijkstra에 의해 제기된 논란이다.
	- GOTO문을 사용하면 스파게티 코드가 양산되고, 이에 따라 가독성이 떨어지게 되며 결과적으로 프로그램이 엉망이 된다.
- 무조건 분기를 지원하지 않는 언어 : Modula-2, CLU, Euclid, Gypsy, Java
- 하지만 이후로 Donald Knuth는 GOTO로 인한 문제점을 만들지 않는 방법에 대해 기술하였고 Frank Rubin은 아예 Dijkstra의 GOTO에 대한 문제 제기 자체를 해롭다고 비판했다.

## guarded commands
---
- Dijkstra가 제시했다. 조건부 명령어라고도 한다.
- 조건을 만족할 때 해당 문장을 수행한다.
- 프로그램 수행 흐름에서 비결정성을 강조한다.(non-determination)
	- a와 b두 정수 중 최솟값을 반환하는 함수에 대해 생각해 보자. 이 경우 a와 b가 같을 경우는 중요한 고려사항이 아니다. 따라서 코드에서는 a<=b, a>=b등으로 기술해도 아무런 상관이 없다. 이러한 경우에 대해 Dijkstra는 코드의 비결정성을 강조했다. 
- 프로그램 증명과 깊은 관련이 있다.
	- GOTO를 포함할 경우 프로그램 증명이 거의 불가능하다.
	- 선택 구조와 사전 검사 반복 구조만 허용된다면 증명이 가능하다.
		- if, do만 있다면 프로그램 증명이 간단해진다.
	- 조건이 붙은 병령어만 허용한다면 프로그램 증명이 용이하다.

### 선택 구문
```
if<조건> -> <문장>
[]<조건 -> <문장>
[]<조건 -> <문장>
[]<조건 -> <문장>
...
[]<조건 -> <문장>
fi
```
1. 모든 조건식을 계산한다.
2. 참인 것 중 하나를 무작위로 선택하여 수행한다.(코드의 비결정성)
3. 참인 것이 없다면 수행 오류이다.

### 반복 구문
```
do<조건> -> 문장
[]<조건 -> <문장>
[]<조건 -> <문장>
[]<조건 -> <문장>
...
[]<조건 -> <문장>
od
```
1. 모든 조건식을 계산한다.
2. 참인 것 중 하나를 무작위로 선택하여 수행한 후 1부터 반복한다.
3. 참이 것이 없다면 종료한다.

### 조건부 명령어의 예시
- 선택 구문
	```
	if x >= y -> max := x
	[] y >= x -> max := y
	```
- 반복 구문
	```
	do q1 > q2 -> temp := q1; q1 := q2; q2 := temp // swap(q1, q2)
	[] q2 > q3 -> temp := q2; q2 := q3; q3 := temp // swap(q2, q3)
	[] q3 > q4 -> temp := q3; q3 := q4; q4 := temp // swap(q3, q4)
	od
	```
- 결국 위 반복 구문의 의미는 아래의 조건을 만족할 때까지 q1, q2, q3, q4를 정렬하는 것이다.	$$(q1 \leq q2)\  \wedge \ (q2 \leq q3)\ \wedge \ (q3 \leq q4)$$ 