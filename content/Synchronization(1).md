+++
title = "Synchronization(1)"
date = 2023-04-11
[taxonomies]
tags = ["Operating System"]
[extra]
author = "JS970"
katex= true
+++
## Critical Section Problem
---
### The Problem of Concurrency(동시성 문제)
- 아래와 같은 프로그램에서, OS는 한 번에 여러 작업에 대해서 연산한다.(juggling)
	```C
	#include <stdio.h>
	#include <stdlib.h>
	#include "common.h"
	
	volitale int counter = 0;
	int loops;
	
	void worker*(void * arg) {
		int i;
		for(i = 0; i < loops; i++)
			counter++;
		return null;
	}
	
	int main(int argc, char* argv[]){
		if(argc != 2) {
			fprintf(stderr, "usage: threads <value>\n");
			exit(1);
		}
		loops = atoi(argv[1]);
		pthread_t p1, p2;
		printf("Initial value : %d\n", counter);
	
		Pthread_create(&p1, NULL, worker, NULL);
		Pthread_create(&p2, NULL, worker, NULL);
		Pthread_join(p1, NULL);
		Pthread_join(p2, NULL);
		printf("Final value : %d\n", counter);
		return 0;
	}
	```
	- 위 코드를 실행시키면 p1과 p2가 동시에 실행된다.
- 위 프로그램을 실행시키면 1000회 정도의 적은 횟수의 loops값을 가질 때는 예상한 대로 동작할 수도 있다.
	- Result : Initial value = 0, Final value = 2000
- 하지만 loops값을 100000정도의 큰 수로 갖는다면 예상하지 못한 결과가 발생한다.
	- Result : Initial value = 0, Final value = 143012
	- 심지어 실행 시마다 Final value가 달라진다.
- 이러한 문제가 발생하는 이유는 `concurrency issue`때문이다.

### Background of Concurrency Issue
- 앞서 살펴본 `concurrency issue`가 발생하는 원인은 `shared variable`에 대한 연산이 `atomic operation`이 아니기 때문에 일어난다.
	```C
	counter++;
	```
- 위 부분을 instruction level에서 살펴보면 아래와 같다.
	- 당연하지만 그냥 예시일 뿐이다. 실제로는 아래보다 적은 연산으로도 해당 구문의 구현이 가능하다, 또한 이는 target machine의 ISA에 따라 다르다. `councurrency issue`의 이해 관점에서 참고하자.
	```asm
	MOVE R1, counter        ; get the value of counter into R1
	ADD  R1, 1              ; increase R1
	MOVE counter, R1        ; save the results in counter
	```
	- machine instruction은 atomic operation이다. 하지만 high level language(C, C++, ...)에서의 statement는 이러한 instruction들이 모인 추상화 수준이 높은 operation이다.
	- 실제 연산은 machine instruction으로 일어난다. 두 thread에서 각각의 statement를 번갈아 가며 실행하지만, 실제로는 instruction level에서 번갈아 가며 실행하는 것이다.
	- 이 과정에서 statement는 순차적으로 실행된 것 처럼 보여 문제가 없는 것처럼 보일 수 있으나, machine instruction level에서는 각 연산 간의 동기화 문제가 발생할 수 있다.
- 좀 더 직관적으로 이해하기 위해 살펴보자 동작을 살펴보자.
	- counter의 초기값은 5이다.
	- P1은 counter 값을 1만큼 증가시킨다.(counter++)
	- P2는 counter 값을 1만큼 감소시킨다.(counter--)
	- 이런 실행 환경에서 프로시저 실행이 P1, P2의 순서로 일어난다고 가정하자. 이를 instruction level에서 표현하면 아래와 같다.
		- P1 : register1 = counter \[r1 = 5]
		- P1 : register1 = register1 + 1 \[r1 = 6]
		- P2 : register2 = counter \[r1 = 5]
		- P2 : register2 = register2 - 1 \[r2 = 4]
		- P1 : counter = register1 \[counter = 6]
		- P2 : counter = register2 \[counter = 4]
	- 프로시저 P1, P2는 순서대로 실행되었다. (P1이 P2보다 먼저 실행되었으며, 먼저 종료되었다.)
	- 하지만 instruction level에서 살펴보면 counter값에 5+1-1 = 5가 아닌 4가 저장된 것을 확인할 수 있다.
- 즉, 이 상황의 근본적인 원인은 각 프로시저가 atomic operation이 아니라는 것이다.
	- P1, P2는 각각 3개의 atomic operation으로 구성된다.
- 이러한 상황을 `Race Condition`이라고 한다.
	- P1, P2가 명령어 실행 순서에 대해 **"Race"** 하는 상황임

### Solution
- `Race Condition`에 의한 `Concurrency Issue`를 해결하기 위해서는 `Critical Section`에 대한 처리를 해 주면 된다.
- `Critical Section`이란 각 프로시저의 공유 변수에 대한 연산이 일어나는 영역이다.
- `Critical Section`에 진입하기 전(`Entry Section`), Critical Section을 탈출한 후(`Exit Section`)에 대한 처리를 통해 어떠한 두 개의 프로세스도 동시에 `Critical Section`에 대해 접근할 수 없도록 하면 `Race Condition`에 의한 `Concurrency Issue`를 해결할 수 있다.
	- `Entry Section`에서는 `Critical Section`에 대한 진입 허가 요청을 한다.
	- `Exit Section`에서는 `Critical Section` 접근 권한을 반환하는 동작을 한다.
- 아래는 `Critical Section`에 대한 대표적인 해결법이다.
	- Semaphore
	- Lock
	- Monitor
- `Critical Section`의 해결법은 다수 존재하지만 반드시 아래 세 가지 요건을 충족해야 한다. 세 가지 요건을 만족하는 것을 보임으로써 유효한 `Critical Section Solution`임을 증명할 수 있다.
	- `Mutual Exclusion` : `Critical Section`으로의 접근은 항상 한 개의 프로세스만 가능하다.
	- `Progress(진행조건)` : `Critical Section`에 접근중인 프로세스가 없을 경우, 임의의 프로세스가 `Critical Section`접근을 요청하면 **지연 없이** 바로 `Critical Section`으로의 접근이 허용되어야 한다.**(절대로 접근이 지연되면 안된다)**
	- `Bounded waiting` : `Critical Section`으로의 접근을 기다리는 프로시저들은 반드시 유한시간 대기 후 접근이 보장되어야 한다.
		- 얼마나 대기하는지는 중요하지 않다. N개의 프로세스가 `Critical Section`접근을 요청한 상황이라면 최소한 N-1개의 프로세스가 실행된 후에는 `Critical Section`에 대한 접근이 가능해야 함을 의미한다.

## Peterson's Solution
---
### Peterson's Solution
> Critical Section에 대한 Software-based Solution이다.
- LOAD/STORE는 atomic opetaion이라고 가정하자.
- Critical Section을 공유하는 프로시저들은 아래의 두 변수를 사용한다.
	- turn : 누가 critical section에 접근할 수 있는지를 저장한다.
	- flag\[i] : 프로세스 i가 critical section에 접근할 준비가 되었음을 나타낸다.
	```C
	int turn;
	boolean flag[i];
	```
- 아래는 Pi와 Pj에 대한 `Peterson's Solution`을 적용한 예시이다.
	- Pi의 관점에서는 Pj가 실행중일 때는 while문을 이용해 Pj의 `Critical Section`접근 권한이 유효한 동안 무한 대기한다. Pj의 경우 반대로 동작한다.
	- `Exit Section`에서는 접근 권한을 반환하여 while문에서 대기중이던 상대 프로세스가 `Critical Section`으로 진입할 수 있도록 한다.
	- Procedure `i`
		```C
		// Procedure : Pi
		do {
			/* Entry Section */
			flag[i] = TRUE;
			turn = j;
			while(flag[j] == TRUE && turn == j);
		
			// critical section
		
			/* Exit Section */
			flag[i] = FALSE;
		
			// remainder section
		} while(TRUE)
		```
	- Procedure `j`
		```C
		// Procedure : Pj
		do {
			/* Entry Section */
			flag[j] = TRUE;
			turn = i;
			while(flag[i] == TRUE && turn == i);
		
			// critical section
		
			/* Exit Section */
			flag[j] = FALSE;
		
			// remainder section
		} while(TRUE)
		```

### Proof of Peterson's Solution
- `Peterson's Solution`은 아래의 세 가지 조건을 만족하므로 유효한 `Critical Section Solution`이다.
1. `Mutual Exclusion`조건을 만족하는가?
	- 두 개의 프로세스가 `critical section`에 접근하려 한다고 하자.
	- 프로세스 `i`가 `critical section`으로 진입하기 위한 조건은 아래와 같다.
		- `flag[i] == TRUE && flag[j] == FALSE && turn == i`
	- 프로세스 `j`가 `critical section`으로 진입하기 위한 조건은 아래와 같다.
		- `flag[j] == TRUE && flag[i] == FALSE && turn == j`
	- 위의 두 조건의 경우에만 프로세스 `i`, `j`가 각각 `critical section`에 진입 가능하다.
	- 두 조건을 제외하고는 프로세스 `i`, `j`모두 `critical section`에 진입할 수 없다.
	- 두 조건은 서로 일치하는 조건이 아니므로 두 프로세스가 동시에 `critical section`에 진입할 수 없다.
	- 따라서 `Peterson's Solution`은 `Mutual Exclusion`조건을 만족한다.
2. `Progress`조건을 만족하는가?
	- 프로세스 `j`가 준비되지 않은 경우 프로세스 `i`는 즉시 `critical section`에 진입할 수 있다.
		- 프로세스 `j`가 준비되지 않은 경우란 `flag[j] == fasle`인 경우를 말한다.
		- 동일한 이유로 프로세스 `i`가 준비되지 않은 경우에도 프로세스 `j`가 즉시 `critical section`에 진입할 수 있다.
	- 프로세스 `j`가 준비된 상태이고, 프로세스 `j`의 while루프를 순회하면서 대기 중이라고 하자.
		- 이 경우 `turn == i`라면 프로세스 `i`는 지연 없이 `critical section`에 진입할 수 있다.
		- 마찬가지로 `turn == j`라면 프로세스 `j`는 지연 없이 `critical section`에 진입할 수 있다.
	- 위의 두 상황에 대해 대기 중인 프로세스가 없을 경우, 지연 없이 프로세스가 `critical section`에 진입 가능함을 확인 가능하다.
	- 대기 중인 프로세스는 `critical section`에서 실행중인 프로세스가 `Exit Section`에서 플래그 값을 변경하면 그 즉시 `critical section`으로 진입할 수 있다.
	- 따라서 `Peterson's Solution`은 `Progress`조건을 만족한다.
3. `Bounded Waiting`조건을 만족하는가?
	- 프로세스 `j`의 플래그가 true로 설정된 후, trun값을 i로 갱신한다.
	- while문의 조건에 의해 프로세스 `j`의 `critical section`접근이 종료된 후에 프로세스 `i`가 대기중인 상황이라면, 그 즉시 `critical section`으로 진입할 수 있다.
	- 프로세스 `i`는 최악의 경우에도 프로세스 `j`가 한 번 실행된 이후에 실행이 보장된다.
	- 따라서 `Peterson's Solution`은 `Bounded Waiting`을 보장한다.

> 사실 대부분의 critical section solution은 Mutual Exclusion 조건은 만족시킨다. Progress조건과 Bounded Waiting조건을 만족시키는지 자세히 살펴보는 것이 중요하다.