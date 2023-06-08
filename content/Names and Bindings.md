+++
title = "Names and Bindings"
date = 2023-05-11
[taxonomies]
tags = ["Programming Language Principles"]
[extra]
author = "JS970"
katex= true
+++
## Names and Bindings
---
### Name
- `Name`은 프로그램에서 식별자 역할을 한다.
- `Name`은 자료 구조, 타입, 함수, 특수 기능 등 여러 `namespace`에 속할 수 있다.
- 문법적으로는 `Name`을 lexeme의 instance라고 말할 수 있다.
- 프로그래밍 언어 설계에 있어서 `Name`의 디자인 시 고려 사항으로는 아래와 같은 것들이 있다.
	- case sensitive?
	- 최대로 가질 수 있는 길이
	- Special Words의 존재
		- `Keyword`, `Reserved Word`, `Predefined Word`가 있다.
		- `Keyword` : 특정 문맥에서만 특별하게 사용되는 단어
		- `Reserved Word` : 사용자 지정 `name`으로 사용할 수 없는 단어
		- `Predefined Word` : `Reserved Word`는 아니지만 시스템에서 이미 정의된 단어
		- 어떤 프로그래밍 언어에서는 `Keyword`가 `Reserved Word`가 아닐 수 있다.
			- `FORTRAN`에서는 아래와 같은 코딩이 가능하다.
			```FORTRAN
			INTEGER REAL
			REAL INTEGER
			REAL = 3
			INTEGER = 3.4
			```
	- connector(연결 문자), special symbol등의 허용 여부
		- Pascal, Modula-2는 연결 문자를 허용하지 않았다.
		- FORTRAN 77은 연결 문자로 공백을 사용했다.
		- 대부분의 프로그래밍 언어들(C, COBOL, FORTRAN 90, ...)은 `_`을 연결 문자로 사용한다.
	- 첫 글자 대소문자의 의미(상수, 변수를 구분하는 데 사용되기도 한다)
		- Haskell : 타입 이름은 반드시 capitalized되어야 한다.
		- Prolog : 변수 이름은 반드시 capitalized되어야 한다.

### Variable
- 변수는 메모리 블럭의 추상체로 볼 수 있다.
- 변수는 `name`, `address`, `value`, `type`, `lifetime`, `scope`의 여섯 가지 `속성`값을 가진다.
- 대부분의 변수는 `name`을 가진다. 하지만 동적 할당 변수 등 `name`을 가지지 않는 변수도 있다.
- `address`는 변수와 관련된 메모리 주소이다. 변수의 `name`이 같다고 하더라도 `address`가 다를 수 있다.
	- 파라미터 타입에 따른 차이, scope(local, global)에 따른 차이

### Binding
- `binding`이란 `name`과 `속성(attribute)`을 연관 짓는 것을 말한다.
- 앞서 살펴본 변수에서와 같이 `name`자체가 `속성`일수도 있다.
- 더 넓은 관점에서 생각한다면 `프로그램 구성 요소`와 `속성`의 연관 짓는 것이라고 생각할 수 있다.

### Binding Time
- `binding`이 일어나는 시점을 바인딩 시간이라고 한다.
- 언어 구성요소마다 바인딩 시간이 다를 수 있다.
	- 예약어와 일반어의 바인딩 시간은 다르다.
- 언어의 같은 구성요소라고 하더라도 속성에 따라 바인딩 시간이 다를 수 있다.
	- 동적 할당 여부, 글로벌 변수(static) 여부
- 바인딩 시각은 다음과 같이 분류할 수 있다.
	1. 언어 정의 시점 : `Reserved Word`의 경우 언어 정의 시점에 바인딩이 일어난다고 볼 수 있다.
	2. 언어 구현 시점 : `sizeof(int)`등의 함수를 생각해 볼 수 있다.
	3. 프로그램 번역 시점 : 컴파일 시점에 바인딩이 일어나는 경우이다.
	4. 프로그램 링크 시점 : 라이브러리 함수는 이 시점에 바인딩이 일어난다.
	5. 프로그램 적재 시점 : 정적 변수의 주소는 이 시점에 바인딩이 일어난다.
	6. 프로그램 수행 시점 : runtime에 바인딩이 일어나는 모든 경우가 해당된다.
	- 프로그램 수행 이전 시점에 일어나는 `binding`을 `early binding(static binding)`이라고 한다.
	- 프로그램 수행 시점에 일어나는 `binding`은 `late binding(dynamic binding)`이라고 한다.
- 다음 C언어 프로그램이 주어졌을 때 바인딩 시점에 대해 생각해 보자.
	```C
	static int X; 
	int Y;
	scanf("%d", &X);
	X = X + 10;
	```
	- 변수 X의 타입 : 컴파일 타임(Program translation time)
	- 변수 X의 값 : runtime(Program execution time)
	- 기본타입에 관한 +의 의미 : Language definition time
	- 프로그램 코드 상에서의 +의 의미 : 컴파일 타임(Program translation time)
	- 숫자 10의 의미 : Language definition time
	- 숫자 10의 내부 표현 형태(2's complement 등) : Language implementation time
	- scanf 호출 시 수행될 내용 : Program link edit time
	- 변수 X의 주소 : Program load time
	- 변수 Y의 주소 : runtime(Program execution time)

### Early Binding
- 번역 전에 파악할 수 있는 정보가 많다.
- 다양한 정보로 프로그램의 잠재적 오류를 사전에 검사할 수 있다.
- 실행파일의 효율을 높일 수 있도록 번역할 수 있다.
- 컴파일 방식과 잘 어울린다.

### Late Binding
- 가능한 한 프로그래머의 선택을 늦은 시점까지 연기할 수 있다.
- 범용 프로그래밍(generic programming)과 같은 유연한 프로그래밍 기법을 사용하기 쉽다.
- 실행 시간에 오류를 발견하는 경우가 많다(오류 검사가 늦다).
- 인터프리터 방식과 잘 어울린다.

### Aliases(Name Binding)
- `L-value` : 변수의 주소, assignment 연산의 좌측에 위치하는 값이다.
	- C언어에서 `&`를 적용할 수 있는 값이다.
- `R-value` : 실제 content의 값, assignment 연산의 우측에 위치하는 값이다.
- `Alias` : 하나의 메모리 공간에 대해 두 개 이상의 `name`이 존재하는 것이다.
	- 가독성에 좋지 않다.
	- 효율성의 이유로 사용된 기능이다.
- `Alias`의 원인으로는 아래와 같은 것들이 있다.
	- EQUIVALENCE in FORTRAN
	- union in C/C++
	- varient records in Pascal and Ada
	- parameter passing
	- pointers and references
- 아래 프로그램은 `Alias`로 인해 가독성이 떨어진 프로그램의 예시이다.
	```C
	#include <stdio.h>
	#include <math.h>
	
	union {
		int x;
		int y;
	} a;
	
	int main() {
		a.x = 3;
		a.y = 4;
		a.x *= a.x;
		a.y *= a.y;
		int z = (int) sqrt(a.x + a.y);
		
		printf("z : %d\n", z);
		return 0;
	}
	```
	- 언뜻 생각하면 5가 출력될 것이라고 생각할 수 있지만 union자료 구조는 메모리 효율성을 위해 하나의 메모리 공간에 여러 변수를 저장하는 자료 구조이다.
	- 따라서 최종 출력은 22가 출력된다.(4\*4\*16 + 512, sqrt(512) = 22)
	- 서로 다른 변수명들이 같은 메모리 공간을 가리키고 있어서 이러한 문제가 발생한다.
