+++
title = "Synchronization(1)"
date = 2023-04-12
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
	- p1과 p2가 동시에 실행된다.
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
- 위 프로그램을 실행시키면 1000회 정도의 적은 횟수의 loops값을 가질 때는 예상한 대로 동작할 수도 있다.
	- Result : Initial value = 0, Final value = 2000
- 하지만 loops값을 100000정도의 큰 수로 갖는다면 예상하지 못한 결과가 발생한다.
	- Result : Initial value = 0, Final value = 143012
	- 심지어 실행 시마다 Final value가 달라진다.
- 이러한 문제가 발생하는 이유는 concurrency issue때문이다.

### Background of Concurrency Issue
- 앞서 살펴본 concurrency issue가 발생하는 원인은 shared variable에 대한 연산이 atomic operation이 아니기 때문에 일어난다.
```C
counter++;
```
- 위 부분을 instruction level에서 살펴보면 아래와 같다.
	- 당연하지만 그냥 예시일 뿐이다. 실제로는 아래보다 적은 연산으로도 해당 구문의 구현이 가능하다, 또한 이는 target macnine의 ISA에 따라 다르다. councurrency issue의 이해 관점에서 참고하자.
```asm
MOVE R1, counter        ; get the value of counter into R1
ADD  R1, 1              ; increase R1
MOVE counter, R1        ; save the results in counter
```
- machine instruction은 atomic operation이다. 하지만 high level language(C, C++, ...)에서의 statement는 이러한 instruction들이 모인 추상화 수준이 높은 operation이다.
- 실제 연산은 machine instruction으로 일어난다. 두 thread에서 각각의 statement를 번갈아 가며 실행하지만, 실제로는 instruction level에서 번갈아 가며 실행하는 것이다.
- 이 과정에서 statement는 순차적으로 실행된 것 처럼 보여 문제가 없는 것처럼 보일 수 있으나, machine instruction level에서는 각 연산 간의 동기화 문제가 발생할 수 있다.
- 아래 예시를 통해 좀 더 직관적으로 이해해 보자
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
- 이러한 상황을 **Race Condition**이라고 한다.
	- P1, P2가 명령어 실해애 순서에 대해 "Race" 하는 상황임

### Solution
- Race Condition에 의한 Concurrency Issue를 해결하기 위해서는 Critical Section에 대한 처리를 해 주면 된다.
- Critical Section이란 각 프로시저의 공유 변수에 대한 연산이 일어나는 영역이다.
- Critical Section에 진입하기 전(Entry Section), Critical Section을 탈출한 후(Exit Section)에 대한 처리를 통해 어떠한 두 개의 프로세스도 동시에 Critical Section에 대해 접근할 수 없도록 하면 Race Condition에 의한 Concurrency Issue를 해결할 수 있다.
	- Entry Section에서는 Critical Section에 대한 진입 허가 요청을 한다.
	- Exit Section에서는 Critical Section 접근 권한을 반환하는 동작을 한다.
- Critical Section에 대한 Solution으로는 아래와 같은 방법들이 존재한다.
	- Semaphore
	- Lock
	- Monitor
	- etc...
- Critical Section Solution은 다수 존재하지만 반드시 아래 세 가지 요건을 충족해야 한다. 세 가지 요건을 만족하는 것을 보임으로써 유효한 Critical Sesction Solution임을 증명할 수 있다.
	- **Mutual Exclusion** : Critical Section으로의 접근은 항상 한 개의 프로세스만 가능하다.
	- **Progress(진행조건)** : Critical Section에 접근중인 프로세스가 없을 경우, 임의의 프로세스가 Critical Section접근을 요청하면 지연 없이 바로 Critical Section으로의 접근이 허용되어야 한다.(절대로 접근이 지연되면 안된다.)
	- **Bounded waiting** : Critical Section으로의 접근을 기다리는 프로시저들은 반드시 유한시간 대기 후 접근이 보장되어야 한다.
		- 얼마나 대기하는지는 중요하지 않다. N개의 프로세스가 Critical Section접근을 요청한 상황이라면 최소한 N-1개의 프로세스가 실행된 후에는 Critical Section에 대한 접근이 가능해야 함을 의미한다.