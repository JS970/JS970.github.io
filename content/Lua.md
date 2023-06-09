+++
title = "Lua"
date = 2023-05-15
[taxonomies]
tags = ["Programming Language Principles"]
[extra]
author = "JS970"
katex= true
+++
## Lua Intro
---
### About Lua
- 단순하고 쉬운 구문을 가진다.
- Python과 유사하지만 들여쓰기 언어는 아니다.(인덴트 무시해도 됨)
- Hybrid implementation 방식으로 구현되어 속도 역시 Python과 비교했을 때 훨씬 빠르다.
- 동적 타입 언어이며, garbage collection을 통한 자동 메모리 관리 기능이 있다.
- ANSI C로 작성되었으며 엔진이 공개되어 있다.

### Env Setting
- [Download Page](http://www.lua.org/download.html)
- At Terminal(Mac tested)
	- 별도의 환경 변수 설정을 할 필요는 없다.
```bash
curl -R -O http://www.lua.org/ftp/lua-5.4.4.tar.gz
tar -zxf lua-5.4.4.tar.gz
cd lua-5.4.4
make all test
```
- Visual Studio에서 작업하는 것을 권장한다. 아래 확장 프로그램을 설치해서 사용한다.
	- Code Runner(필수)
	- Lua, Lua Debug(Optional)

### Lua Resources
- Lua Books
	- [Programming in Lua](https://www.amazon.com/Programming-Third-Edition-Roberto-Ierusalimschy/dp/859037985X)
	- [The first edition is available online](http://www.lua.org/pil/contents.html)
	- [Beginning Lua Programming](https://www.amazon.com/gp/product/0470069171/)
- Lua Tutorial
	- [Learn Lua in 15 Minutes](https://tylerneylon.com/a/learn-lua/)
	- [Lua for Programmers](https://ebens.me/post/lua-for-programmers-part-1/)
	- [w3big.com](https://www.w3big.com/lua/default.html)
	- [tutorialspoint.com](https://www.tutorialspoint.com/lua/index.htm)
- Other Useful Sites
	- [lua-users.org](http://lua-users.org/)
	- [Lua Short Reference](http://lua-users.org/wiki/LuaShortReference)

## Lua
---
### Data Types
- `nil` : null과 같은 표현이다. 초기 LISP에서 사용되었던 표현을 계승했다.
- `boolean` : False and True
- `number` : 정수, 부동소수점 모두 `number`타입이다.
- `string` : 문자열
- `table` : 연관 배열(Python의 dictionary와 유사하다)
	- 테이블 원소에 필드 이름을 붙이면 레코드처럼 사용할 수 있다.
	- 참조할 때는 필드 이름을 문자열로 참조한다. 아래 프로그램은 7을 출력한다.
	```Lua
	pnt = {x=3, y=4}
	print(pnt["x"] + pnt["y"])
	```
	- Mixed  Table형태로 레코드와 배열을 한 테이블에 사용 가능하다.
	- 이때 레코드와 배열의 구분을 위해 `;`를 사용한다.
	```Lua
	fav = {name="Lua", year={1993}; "script", "dynamic", "fast"}
	```
	- for구문에서 pair함수를 사용하여 테이블의 key를 참조할 수 있다.	
		- pair함수는 테이블의 key, value를 반환하는 반복자다.
		- 아래 프로그램에서는 k만 사용했으므로 value부분이 버려진 상태이다.
	```Lua
	for k in pairs(fav) do
		print(k)
	end
	```
	- for 구문에서 ipairs함수를 활용하여 테이블의 배열을 표현할 수 있다.
		- ipairs함수는 테이블의 index, value를 반환하는 반복자다.
	```Lua
	for i, v in ipairs(fav) do
		print(i, v)
	end
	```
- `type()`을 이용하여 변수의 타입을 확인 가능하다.

### Operators
- 본 절에서는 `Lua`의 특이한 operator에 대해서만 기술한다.
- 자세한 정보는 [Download Page](http://www.lua.org/download.html)에서 다운받은 파일을 압축 해제하여 README.md를 읽어보자.
- 비교 연산자
	- `~=` : 다른 언어에서의 `!=`표현과 같은 의미이다.
- 산술 연산자
	- `^` : 거듭제곱을 연산하는 산술 연산자이다.
- 논리 연산자
	- `and`, `or`, `not` : 문자 그대로의 의미를 가진다.
	- 논리 연산에서는 `nil`과 `false`를 모두 `거짓`으로 판단한다.
	- 이때 먼저 위치한 타입을 따른다.
	```Lua
	nil and false
	false and nil
	```
	- 위 코드의 첫 번째 문장을 실행하면 `nil`, 두 번째 문장을 실행하면 `false`를 출력한다.
- 조건 연산자
	- `and`, `or`를 조합하여 아래와 같이 사용한다.
	```Lua
	max = (x > y) and x or y
	```
	- 위 프로그램은 x, y중 더 큰 값을 max에 저장한다.
- string operators
	- `..`을 사용하여 string concatenation이 가능하다.
	- `sub`메소드를 사용하여 string을 자를 수 있다.
	```Lua
	s = "hello"
	s:sub(1, 2)
	```
	- 위 코드를 실행하면 "he"가 출력된다.
- 대입 연산자
	- 다중 대입 연산을 지원한다.
	- 필드 개수가 안 맞으면 남는 값은 버린다.
	- 변수의 개수가 더 많은 경우 남는 변수는 `nil`로 설정된다.
	```Lua
	a, b, c = 0, 1
	print(a, b, c)

	x, y = 0, 1, 2
	print(x, y)
	```
	- 위 코드의 2행을 실행시킨 결과는 0, 1, `nil`이다.
	- 위 코드의 5행을 실행시킨 결과는 0, 1이다.
- Sharp(#)
	- `Lua`에서는 크기를 측정할 때 `#`을 사용한다.
	- 아래는 문자열 크기를 측정하는 예시이다. 출력값은 5이다.
	```Lua
	print(#"HEllo")
	```
- Modulo Operation
	- 원래 Lua에는 modulo연산자가 없었다.
	- math 라이브러리를 활용해서 math.fmod(17, 5)와 같이 기술하여 구현했다.
	- 또는 몫과 나멎지 사이의 관계를 통해 나머지 연산을 구현하기도 했다.
		- math.fmod(17, 5)와 같은 표현으로 17 - math.floor(17/5) \* 5를 사용할 수 있다.
	- 위의 두 방법은 음수에 대한 나머지 연산 시 차이가 있으므로 이를 생각해야 한다.
		- fmod는 좌측 인수의 부호를 따라가지만 floor는 항상 작은 정수를 반환하기 때문에 차이가 생긴다.
	- 현재는 Lua에서 `%`연산자를 지원하므로 이렇게 구현할 필요는 없다.

### Comments
- One Line Comment : `--`를 사용하면 해당 행의 끝까지 주석 처리된다.
- Multiline Comment : `--[[ statement ]]`처럼 사용하면 괄호 쌍 안의 모든 내용이 주석 처리된다.
- `[[ ]]`괄호 쌍 안의 문자열은 long string literal로 사용되므로 print등 다른 함수에서도 사용 가능하다.

### Scope
- 기본적으로 `Lua`의 모든 변수는 global variable이다.
- 지역 변수를 사용하려면 키워드 `local`을 사용해야 한다.
- `Lua`의 함수 내부에서 함수를 정의할 수 있는데, 이 경우 내부 함수 역시 global function이다.

### Control Structure
- `if-else`구문은 아래 코드처럼 마지막에 `end`키워드를 사용해야 한다.
	```Lua
	if a<b then 
		return a 
	else 
		return b 
	end
	```
- `while`, `for`역시 마지막에 `end`키워드를 사용해야 한다.
	```Lua
	while condition do
		-- statement
	end
	
	-- Generic For Loop
	for variable in structure do
		-- statement
		-- structure 자리에는 iterator 가 위치한다.
		-- Generic For Loop의 경우 iterator가 모두 순회할 때까지 반복한다.
	end
	
	-- Neumeric For Loop
	for i=1, 10, 2 do
		-- statement
		-- 증분 값을 생략하면 1로 자동 설정된다.
	end
	```

### Functions
- `Lua`에서 함수를 정의할 때는 `function`키워드를 이용한다.
- 함수가 끝날 때는 `end`를 사용하여 함수의 선언이 종료되었음을 명시해야 한다.
- 대입과 마찬가지로 부족한 인수는 `nil`로 전달되며, 남는 인수는 버린다.
- 아래 함수는 두 값을 더하는 함수 add이다.
	```Lua
	function add(a, b)
		return a + b
	end
	```
- `Lua`는 Default Argument를 지원하지 않는다. 하지만 조건 연산자를 이용하면 비슷한 역할을 하도록 구현할 수 있다.
- 아래는 인수가 주어지지 않은 경우(`nil`인 경우 원하는 기본 인수(0)으로 설정하는 함수이다.
	```Lua
	function add(a, b)
		b = b or 0
		a = a or 0
		return a + b
	end
	```
- 아래는 팩토리얼을 계산하는 `Lua`함수이다.
	```Lua
	function factorial(n)
		if n == 0 then 
			return 1
		else
			return n * factorial(n-1)
		end
	end
	```
- 이를 tail recursion을 만족하도록 수정하면 다음과 같다.
	```Lua
	function tailFactorial(n, acc)
		acc = acc or 1
		if n == 0 then
			return acc
		else
			acc = acc * n
			return tailFactorial(n-1, acc)
		end
	end
	```

### Lambda
- `람다 함수`란 이름 없는 함수를 뜻한다.
- 키워드 `function`다음에 아무 이름 없이 함수를 쓰면 `람다 함수`가 된다.
- 아래는 덧셈을 수행하는 람다 함수 프로그램이다.
	```Lua
	(function(a, b) return a+b end)(2, 3)
	```
- 람다 함수를 사용하면 아래와 같이 지역 함수를 정의할 수 있다.
	```Lua
	function add(a, b)
		local add1 = function(b)
			return b + 1
		end
		return a == 0 and b or add(a-1, add1(b))
	end
	```
- 재귀 지역 함수(Recursive Local Function)의 사용에서 주의사항
	```Lua
	function count(n)
		local down = function(n)
			if n == 0 then
				print("Beep!")
			else
				print(n)
				down(n-1)
			end
		end
		down(n)
	end
	```
	- 위와 같이 선언할 경우 down의 값은 `nil`이므로 위 프로그램은 오류이다.
- 아래처럼 지역 변수를 먼저 선언한 후 할당하면, 함수 호출 시 선언된 지역 변수 값을 이용하므로 문제가 없다.
	```Lua
		function count(n)
		local down
		down = function(n)
			if n == 0 then
				print("Beep!")
			else
				print(n)
				down(n-1)
			end
		end
		down(n)
	end
	```

### File Input and Output
- 파일을 모드 문자열에 지정된 대로 여는 방법(file open)
	```Lua
	handle = io.open(fileName, MODE)
	```
- 기본 입력 혹은 출력을 handle로 바꾸는 방법(file set)
	```Lua
	io.input(handle), io.output(handle)
	```
- 파일을 닫는 방법
	```Lua
	io.close(handle)
	```

### Input
- 문자열을 입력받아 반환
	```Lua
	io.read()
	```
- 수를 입력받아 반환
	```Lua
	io.read("*n")
	```
- 한 행을 입력받아 반환
	```Lua
	io.read("1*")
	```
- 파일 내 모든 데이터를 입력받아 반환
	```Lua
	io.read("*a")
	```

### output
- 데이터를 출력한다
	```Lua
	print(data)
	```
- 파일의 맨 끝 행에 출력한다. print와 달리 개행문자를 출력하지 않는다.
	```Lua
	io.write(data)
	```

### Closure
![Closure](/image/PL/closure.png)
- 참조 환경과 함수를 묶은 것을 `Closure`라고 한다.
- 언제든지 함수를 계산할 수 있는 형태이다.
- 람다 함수는 참조 환경이 없는 클로저라고 볼 수 있다.
- 아래는 `Lua`의 `Closure`를 정의한 예시이다.
	```Lua
	function newCounter()
		local i = -1
		return function() i = i + 1 return i end
	end
	```
- 아래는 위의 `Closure` 사용 예시이다.
	- newCounter()가 총 10번 실행된다.
	- 이때 newCounter()의 호출 시마다 내부 참조 환경 i의 값이 바뀌어 매번 다른 값을 반환한다.
	```Lua
	c1 = newCounter()
	for i = 1, 10 do print(c1()) end
	```

### Iterator
- 어떤 자료 구조의 모든 자료를 훑는 함수를 반복자(iterator)라고 한다.
- `Lua`의 `Closure`를 이용하면 반복자를 작성할 수 있다.
- 아래는 `Lua`의 반복자 정의 예시이다.
	```Lua
	function iterator(t)
		local i, sz = 0, #t
		return function()
			i = i + 1
			if i <= sz then return t[i] end
		end
	end
	```
- 아래는 위 프로그램에서 정의한 반복자를 사용하는 `Lua`프로그램의 예시이다.
	```Lua
	for n in iterator({1, 2, 3, 4}) do print(n) end
	```

### Coroutine
- 자신만의 수행 상태를 지니고 있는 함수를 `Coroutine`이라고 부른다.
- 이전 상태를 기억한다는 측면에서 과거 인식 함수(history sensitive function)과 유사하다.
- 자신만의 수행 상태가 유지된다는 측면에서 스레드(Thread)와 유사하다.
- 하지만 병렬 수행은 불가하므로 유사병렬성(quasi-concurrency)을 구현하는데 사용된다.
- `Coroutine`은 수행 상태를 유지해야 하므로 아래의 상태 중 하나에 놓이게 된다.
	- `중단(suspend)` : `Coroutine`이 생성되었으나 실행되고 있지 않은 상태
	- `실행(running)` : `Coroutine`이 실행 중인 상태
	- `종료(dead)` : `Coroutine`의 본체가 모두 수행되어 종료된 상태
- `Lua`에서의 `Coroutine`은 통상적인 `Coroutine`과 달리 호출자와 피호출자가 구분되는 asymetric `Coroutine`이다.
- `Coroutine`은 상태를 지니고 있다는 점에서 `Iterator`와 유사한 측면이 있다. 하지만 `Coroutine`은 `Iterator`보다 훨씬 다양한 상태에 있을 수 있으므로 훨씬 강력하다.
- 아래의 코드는 `Coroutine`을 사용한 `Lua`프로그램 코드이다.
	```Lua
	cntdown = coroutine.create(function()
		coroutine.yield(5)
		coroutine.yield(4)
		coroutine.yield(3)
		coroutine.yield(2)
		coroutine.yield(1)
	end)
	
	repeat
		state, cnt = coroutine.resume(cntdown)
		print(cnt == nil and "Blast" or cnt, state)
	until coroutine.status(cntdown) == "dead"
	
	state, cnt = coroutine.resume(cntdown)
	print(cnt, state)
	```
- `coroutine.create`를 통해 `Coroutine`을 생성한다.
- `coroutine.tield`를 통해 `Coroutine`을 실행한다(사실상 return의 역할을 수행한다).
- `coroutine.resume`을 통해 `Coroutine`을 재개한다.
- `coroutine.status`를 통해 현재 `Coroutine`의 상태를 반환한다.

### 파일 입출력 & Coroutine을 사용한 예시 프로그램
- 아래 프로그램은 1부터 입력받은 수 n까지의 모든 수 중 짝수만을 `evens.txt`에 write하는 프로그램이다.
	```Lua
	producer = function(n)
		return coroutine.create(function()
			for i = 1, n do coroutine.yield(i) end
		end)
	end
	
	consumer = function(p)
		return coroutine.create(function()
			handle = io.open("evens.txt", "w")
			io.output(handle)
			repeat
				_, num = coroutine.resume(p)
				if num % 2 == 0 then
					io.write(num)
					io.write("\n")
				end
			until coroutine.status(p) == "dead"
			io.close(handle)
		end)
	end
	
	n = io.read("*n")
	p = producer(n)
	c = consumer(p)
	coroutine.resume(c)
	```
