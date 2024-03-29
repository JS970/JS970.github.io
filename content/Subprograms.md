+++
title = "Subprograms"
date = 2023-06-01
[taxonomies]
tags = ["Programming Language Principles"]
[extra]
author = "JS970"
katex= true
+++
## Subprogram Concepts
---
- Program = Algorithm + Data Structure(Wirth 저) 에서 Algorithm이 Control Flow를 담당한다.
- 그렇다면 Data Structure의 Flow는 어떻게 처리될까?
	- Data Structure을 처리하는 Subprogram을 통해 Data Flow가 관리될 수 있다.

### Subprogram
- 전체 프로그램에 포함된 독립적인 작은 프로그램
- 함수(function)과 프로시저(procedure)가 있다.
	- `함수` : 반환 값은 존재하지만 부수 효과는 존재하지 않는다.
	- `프로시저` : 반환 값은 없고 부수 효과만 존재한다.
	- 정말로 부수 효과가 없는 함수의 경우 pure function이라고 한다.
	- 함수형 프로그래밍이란 프로시저의 사용 없이 function만 사용하는 프로그래밍 방법론이다.
- 하나의 entry point를 가진다.
- 서브프로그램을 호출한 서브프로그램은 호출된 서브프로그램이 수행되기 전에 suspend한다.
- 호출된 서브프로그램의 수행이 완료되면 호출자로 수행 흐름이 바뀐다.

### Terminology of Subprogram
- `definition` : 서브프로그램의 작동을 기술한 부분이다.
	- 선언(declaration)과 함께 사용되기도 하고, 선언만 사용될 때도 있다.
	- 선언에서는 `protocol`만을 명시한다.
	- definition에서는 `header`, `body`를 명시한다.
- `call` : 서브프로그램이 수행될 것을 요구하는 부분이다.
	- 실인수(actual argument)가 서브프로그램 호출 시 전달된다.
	- 서브프로그램 호출 시 실인수가 형식 인수로 전달된다.
- `header` : 서브프로그램의 이름, 종류, 형식인수를 포함하는 부분이다.
	- 형식인수(formal parameter)가 헤더에 선언된다.
- `body` : 서브프로그램 호출 시 실행되는 부분이다.
- `parameter profile` : 매개변수 프로파일이란 인수의 개수, 순서 자료형을 의미한다.
- `protocol` : 매개변수 프로파일 + 반환형(함수의 경우)

### Formal and Actual Correspondence
---
- 형식인수가 실인수로 대응되는 방법은 위치에 의한 대응(positional correspondence)과 키워드에 의한 대응 방식(keyword correspondence)의 두 가지가 있으며, 병용되어 사용되기도 한다.
- 위치에 의한 대응
	- 매개변수의 위치에 따라 실인수가 전달된다.
	- 가장 일번적이며, C, Java, Pascal등의 언어에서 사용된다.
- 키워드에 의한 대응
	- 매개변수의 이름에 따라 실인수가 전달된다.
	- 순서가 중요하지 않으므로 실인수를 전달할 때 순서를 기억하지 않아도 된다.
	- 하지만 형식인수의 이름은 기억해야 한다.
	- 아래는 키워드에 의한 인수 전달 예시이다.
		```Python
			strcpy(src=a, tgt=b)
		```
- 위치에 의한 대응과 키워드에 의한 대응을 병용해서 사용하기도 한다.
	- Python은 매개변수 목록의 앞부분은 위치에 의한 대응, 뒷부분은 키워드에 의한 대응으로 `/`를 통해 구분한다.
	- Ada, FORTRAN 90, Python에서 이러한 방식을 사용한다.

## Procedures and Functions
---
- 어떤 언어에서는 함수와 프로시저의 구분이 프로그래머에 달려 있다.
- 대표적으로 C언어 계열에서 void함수는 프로시저이다.

### Procedure
- 사용자 정의 문장을 구현한다.
- **부대효과를 발생시킨다.**
- 발생되는 부대효과로는 입출력, 비지역변수 변경 등이 있다.

### Function
- 사용자 정의 연산자를 구현한다.
- **부대효과는 없고 결과값을 갖는다.**
- 외부로 전달하는 정보로는 결과값이 있다.

## Parameter Passing
---
### 의미 모델
- 입력 모드에서는 실인수가 형식인수로 전달된다.
- 출력 모드에서는 형식인수 값이 실인수로 전달된다.
- 입출력 모드에서는 양방향 전달이 모두 일어난다.

### 개념적 모델
- 값을 물리적으로 전달한다.(copy)
- 참조 경로만 전달한다.

### 구현 모델
> 구현 모델이 다양한 이유는 side-effect때문이다.
- 값 전달 : pass-by-value, call-by-value
	- 값에 의한 호출(copy), 입력 모드의 인수전달을 구현한다.
	- 물리적으로 값을 전달하거나, 참조 경로를 전달하여 구현 가능하다.
- 결과 전달 : pass-by-result, call-by-result
	- 형식인수의 값이 호출자로 전달된다.
	- 물리적으로 값을 전달하거나, 참조 경로를 전달하여 구현 가능하다.
- 값-결과 전달 : pass-by-value-result, call-by-value-result
	- 호출시 값을 복사(실인수 -> 형식인수)하고, 복귀시 다시 값을 복사(형식인수 -> 실인수)한다.
	- 입출력 모드의 인수전달을 구현한다.
	- 입출력 모드의 인수 전달이 가능하며, 인수 전달로 인한 alias가 생기지 않는다는 장점이 있다.
- 참조 전달 : pass-by-reference, call-by reference
	- 참조 경로(주소)를 전달한다.
	- pass-by-sharing이라고도 한다.
	- 입출력 모드의 인수전달을 구현한다.
	- 전달 과정 자체가 효율적이라는 장점이 있다.
	- 하지만 참조 시간이 오래 걸리고 alias가 발생할 수 있다는 아주 큰 단점이 있다.
	- alias가 발생하면 프로그램의 결과를 예측하기가 매우 힘들어진다.
- 이름 전달 : pass-by-name, call-by-name
	- 글자 그대로 치환(rewrite)한다.
	- `참조 방법` 을 형식인수에 대응시킨 후, 형식인수를 사용할 때마다 이 참조 방법대로 변수를 구한다.
		- `참조 방법` : L-value, R-value를 구하는 함수
		- 위 함수의 function call을 통해 late-binding이 이뤄진다.
	- late binding을 통한 유연성을 제공한다.
	- 실인수의 종류에 따라 인수 전달의 의미가 달라진다.
		- 단순 변수 : 참조 전달과 동등하다.
		- 상수 식 : 값 전달과 동등하다.
		- 배열 등이 포함된 복잡한 식 : 대응되는 인수전달 방법이 없다.
	- 인수 참조가 너무 비효율적이라는 단점이 있다(참조할 때마다 function call이 일어나기 때문이다).
	- 또한 함수를 구현에 따른 오버헤드도 존재한다.

## Function Overloading
---
- 서브프로그램의 오버로딩 : 동일한 참조환경 내에서 다른 서브프로그램과 이름이 같은 서브프로그램
- 연산자의 오버로딩 : 연산항의 타입에 따라 의미가 달라지는 연산자.
- C++, Java, Ada는 사용자 정의 서브프로그램도 overloading이 가능하다.
- C++, Python은 연산자 overloading도 지원한다.
- overloading resolving algorithm을 통해 기본값이 있을 경우 어떤 서브프로그램을 호출할 지 선택할 수 있다. 아래는 overloading resolving algorithm이 필요한 예시이다.
	```C++
	void fun(float b = 0.0);
	void fun();
	fun();; // 어떤 fun()을 호출해야 할지 선택해야 한다.
	```

## Jensen's Device
---
### Generic Subprogram
- 여러 타입의 인수에 적용될 수 있는 서브프로그램
- 다형적 서브프로그램(ploymorphic subprogram)의 일종이다.
- 다형성의 종류로는 아래와 같은 것들이 있다.
	- 순수 다형성(pure polymorphism) : 상속과 가상함수를 통한 다형성
	- 경험적 다형성(ad-hoc polymorphism) : 중복 지정을 통한 다형성
	- 매개변수적 다형성(parametric polymorphism) : 타입을 인수로 받는 형태의 다형성
- 주요 언어의 예시는 아래와 같다.
	- Ada : 서브프로그램, 패키지를 generic으로 선언할 수 있다.
	- C++ : 타입을 인수로 하는 template함수 및 Class를 작성할 수 있다.
	- Ada, C++모두 범용 서브프로그램은 어떤 틀 구실을 하며, 실제 컴파일 시간에 구체적 타입에 대하여 개별 복사가 이루어진다.

### Jensen's Device
- pass-by-name 인수를 이용한 범용 서브루틴
- 아래는 의사 코드이다.
	```
	begin
		real procedure sum(i, li, hi, term);
			value lo, hi; // pass-by-name 인수들
			integer i, io, hi;
			real term;
		begin
			real temp;
			remp := 0;
			for i := lo step 1 until hi do
				temp := temp + term;
			sum := temp
		end;
		print(sum(i, 1, 100, 1/i))
	end
	```
	- 위 프로그램은 1/1 + 1/2 + 1/3 + ... + 1/100 을 계산하는 프로그램이다.
	- 이를 이용해서 행렬의 행, 열, 주대각선의 합 등을 구할 수 있다.

## Coroutine
---
- 여러 개의 진입 위치를 스스로 관리하는 서브프로그램이다.
- 코루틴은 호출된다(called)고 말하지 않고 계속된다(resumed)고 한다.
- 프로그램 수행이 번갈아 이루어지므로 유사병렬성을 지니고 있다.
- 지원 언어 : SIMULA 67, BLISS, INTERLISP, Modula-2, Python, Lua(비대칭 coroutine)