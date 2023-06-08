+++
title = "Type Binding, Storage Binding, Scope"
date = 2023-05-11
[taxonomies]
tags = ["Programming Language Principles"]
[extra]
author = "JS970"
katex= true
+++
## Type Binding, Storage Binding, Scope
---
### Type
- `Type`은 `Value Set` + `Operation Set` 으로 생각할 수 있다.
- `Value Set` : 가질 수 있는 값의 집합
- `Operation Set` : 해당 타입의 값들에 대해 적용 가능한 연산자의 집합
- 예를 들어 C/C++에서 `char`타입의 경우 아래와 같은 `Value Set`, `Operation Set`을 가진다.
	- `Value Set` : 8비트 범위의 이진수
	- `Operator Set` : 단항 -, +, 이항 -, +, \*, /, 등의 연산자를 지원한다.

### Type Binding
- 타입 바인딩을 두 가지 기준으로 구분해 볼 수 있다.
- 어떻게 타입이 식별되는가 : `명시적(explicit)`, `암묵적(implicit`
- 바인딩이 일어나는 시점은 언제인가 : `정적(static)`, `동적(dynamic)`
- 이러한 기준에 의해 언어를 간단히 분류해 보면 아래와 같다.![Type Binding](/image/PL/typeBinding.png)
	- 동적 바인딩 된 경우에는 오류 검사가 힘들다.
- 타입 바인딩은 변수보다 명칭(function name, class name)에 대한 바인딩을 생각하는 경우가 많다.
- 하지만 동적 바인딩에서 변수에 대한 타입 바인딩이 실행 시간에 결정될 수 있다는 점에 차이가 없다.

### Static Typing
- 일반적으로 translation time에 타입이 결정된다.
- 타입은 명시적으로 선얼될 수도, 암시적으로 선언될 수도 있다.
	- 타입의 명시적 선언 예시로는 C언어의 명시적 타입 선언이 있다.
	- 타입의 암시적 선언 예시로는 BASIC의 `$`를 이용한 문자열 변수 암시적 선언이 있다.
- 이러한 방식을 가질 경우 `정적 타입 언어(statically typed language`라고 한다.

### Dynamic Typing
- 타입은 assignment연산을 통해 결정된다.
- 아래는 동적 타입 언어 APL의 예시이다.
	```APL
	LIST <- 2 4 6 8
	LIST <- 10.2
	```
	- 1행에서의 LIST는 정수 배열이다.
	- 2행에서의 LIST는 부동 소수점 변수이다.
- 동적 타입 바인딩의 단점
	- 형 검사(type check)가 힘들다.
	- 실행 시간 중 오류가 발생할 확률이 비교적 높다.
- 동적 타입 바인딩의 장점
	- 범용 프로그래밍(generic programming)등 유연성이 높은 프로그래밍이 가능하다.

### Type Inference(타입 추론)
- 정적으로 바인딩 되었다고 하더라도 아래의 경우와 같이 타입 정의가 생략될 수 있다.
- ML
	```ML
	fun times10(x) = 10 * x;
	```
	- time10의 반환값은 정수형으로 `inference`된다.
- Java(Java7 ~)
	```Java
	List<Integer> list2 = new ArrayList<>();
	```
	- 위 경우 생성자로 사용되는 ArrayList의 타입은 Java에서 `inference`하여 `Integer`로 설정된다.
- C++(C++11 ~)
	```C++
	string s "HELLO";
	for(auto c: s)
		cout << c << endl;
	```
	- 변수 `c`의 타입은 `s`에 의해 `char`로 `inference`된다.

### Storage Binding
- `Allocation` : 사용 가능한 메모리로부터 `memory cell`을 가져오는 것
- `Deallocation` : 할당된 `memory cell`을 사용 가능한 메모리에서 제거하는 것
- `Lifetime of a variable` : 변수가 `memory cell`에 존재하는 시간
- 일반적인 실행 시간의 메모리 구조는 아래와 같다.![Storage Binding](/image/PL/storageBinding.png)

### Static Variables
- 정적 변수는 실행 시간 이전에 `memoy cell`이 바인딩된다.
- `storage binding`이 실행 시간 중 변경되지 않는다.
- 대표적으로 C, C++, Java에서 `static`키워드를 사용하여 선언한 변수가 `static variable`이다.
- `static variable`을 사용하여 서브프로그램을 `history sensitive`하게 구현할 수 있다.
- 로컬 변수를 사용한 재귀가 불가능하다는 단점이 있다.(old FORTRAN)

### Scope
- 변수의 `scope`는 변수가 `visible`한 `statement`의 범위를 말한다.
- `statement`에서 변수가 참조될 수 있다면 변수는 `visible`하다고 말한다.
- 프로그램에서 `non-local variable`이란 `visible`하지만 그곳에 선언되지 않은 변수를 의미한다.
- 프로그래밍 언어에서 `Scope Rule`이란 변수 선언과 참조 사이의 관계를 정의한 것이다.
	- 특히 `non-local variable`에서 중요하게 다뤄진다.

### Block
- `local variable`을 선언할 수 있는 코드 영역이다.
- `Block`단위로 `storage allocation`된다.
- 여러 `Block`이 섞여서 프로그램을 구성하는 프로그래밍 언어를 `Block-Structured Language`라고 한다.
- 서브프로그램을 구성하지 않는 `Block`을 `Nonprocedural Block`이라고 한다.
- `Nonprocedural Block`예시이다.
	```
	declare TEMP: integer;
	begin
		TEMP := FIRST;
		FIRST := SECOND;
		SECOND := THIRD;
	end
	```
- Pascal, Modula-2는 `Nonprocedural Block`을 지원하지 않는다.

### Static Scope
- 변수들이 실행 시간 이전에 정적으로 결정되는 `Scope`이다.
- 프로그램 텍스트에 기반한다.
- 자신으로 부터 가장 가까운 scope의 변수를 사용한다.
	```C
	int a = 3;
	int add1(int a) {
		return a + 1;
	}

	int main() {
		add1(10);
		return 0;
	}
	```
	- 위 프로그램의 add1에서는 해당 `scope`에서 가장 가까운 형식 매개변수인 10을 참조하여 11을 반환한다.
	- 위 프로그램에서 처럼 지역 변수에 의해 비지역 변수가 사용할 수 없는 지점을 `Scope Hole`이라 한다.
- `Static Ancestor` : 상위의 모든 `Scope`를 지칭한다.
- `Static Parent` : 바로 상위의 `Scope`를 지칭한다.
- Ada, C++등 특정 언어에서는 `Scope Hole`에서 가려진 변수를 접근할 수 있는 방법을 제공한다.
	- Ada에서 x가 hidden variable인 경우 접근하는 방법
		```Ada
		big.x
		```
	- C++에서 x가 hidden variable인 경우 접근하는 방법
		```C++
		::x
		```

### Static Scope Example
```
program main;
	procedure A;
		procedure C;
			begin ... end;
		procedure D;
			begin ... end;
		begin {A}
		...
		end;  {A}
	procedure B;
		procedure E;
			begin ... end;
		begin {B}
		...
		end;  {B}
	begin {main}
	...
	end.  {main}
```
- 위 프로그램에서 호출 가능성을 그래프로 나타내면 아래와 같다.![Call Graph](/image/PL/callGraph.png)
	- main에서는 재귀 호출이 불가능하다.
	- A, B, C, D, E는 서브프로그램이므로 재귀 호출이 가능하다.
	- B, D는 각각 A, C이후에 선언된 서브프로그램이므로 A, C에 접근할 수 있지만 그 역은 불가능하다.

### Dynamic Scope
- `Scope`는 서브프로그램의 호출 순서에 따라 결정된다.
- `Static Scope`는 공간에 의한 관계를 가지지만, `Dynamic Scope`는 일시적인 관계를 가진다.
- LISP에서 나온 개념이며 일반적으로 사용되지는 않는다.
	- MaCarthy본인도 잘못 설계했음을 시인했다...

### Evaluations of Scoping Rules
- Static Scope 장점
	- Static type checking이 가능하므로 reliable하다.
	- type information을 이용하여 신속한 코드 생성이 가능하다.
	- 가독성이 좋다.
- Static Scope 단점
	- 변수 및 프로시저는 실제 필요한 범위보다 더 `visible`하다.
	- 조금의 참조 기능의 사용만으로 전체 프로그램이 변경될 수 있다.
- Dynamic Scope 장점
	- 특정 상황에서 파라미터 전달을 생략할 수 있다.
- Dynamic Scope 단점
	- 프로시저 호출자의 지역 변수는 피호출 프로시저에서 항상 `visible`하다.
	- Static type checking을 적용할 수가 없다.
	- 프로그램 가독성이 좋지 않다.
	- 구현 역시 쉽지 않다(bad writability).

### Scope and Lifetime
- `Scope`와 `Lifetime`은 밀접한 관계가 있다. 하지만 엄연히 구분하여야 한다.
- `Local Scope`의 `Lifetime`은 `Stack-Dynamic`이다.
	- 물론, C계열 언어에서의 `static`변수 등 예외도 있다.
- `Global Scope`의 `Lifetime`은 `Static`이다.
- `Lifetime`을 고려했을 때 아래와 같이 유용하게 생각할 수 있다.
	- C계열 언어에서 main()실행 전에 에러가 날 경우 높은 확률로 `static`의 선언에 문제가 발생한 것이다.

### Referencing Environment
- 참조 공간(Referencing Environment)란 `Scope Rule`을 다른 관점에서 본 것이다.
- 프로그램 상에서 `visivle`한 `namespace`를 지칭한다.
- `Static Scope Language`에서의 참조 공간은 아래와 같다.
	- 지역 변수
	- 모든 `ancestor scope`의 `visible`한 변수
- `Dynamic Scope Language`에서의 참조 공간은 아래와 같다.
	- 모든 실행 중인 프로그램에서 `visible`한 변수
- `Static Scope Ref Environment` 예시
	```
	program main;
		var a, b: integer;
	procedure sub1;
		var x, y: integer;
		begin {sub1}
		..{1}..
		end;  {sub1}
	procedure sub2;
		var x: integer;
		procedure sub3;
			var x: integer;
			begin {sub3}
			..{2}..
			end;  {sub3}
		begin {sub2}
		..{3}..
		end;  {sub2}
	begin {main}
	..{4}..
	end.  {main}	
	```
	- {1} : sub1's {x, y}, main's {a, b}
	- {2} : sub3's {x}, main's {a, b}
	- {3} : sub2's {x}, main's {a, b}
	- {4} : main's {a, b}
- `Dynamic Scope Ref Environment` 예시
	```
	void sub1() {
		int a, b;
		..{1}..
	}

	void sub2() {
		int b, c;
		..{2}..
		sub1();
	}

	void main() {
		int c, d;
		..{3}..
		sub2();
	}
	```
	- {1} : sub1's {a, b}, sub2's {c}, main's {d}
	- {2} : sub2's {b, c}, main's {d}
	- {3} : main's {c, d}s