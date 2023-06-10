+++
title = "Synchronization(2)"
date = 2023-04-12
[taxonomies]
tags = ["Operating System"]
[extra]
author = "JS970"
katex= true
+++
## Synchronization Hardware
---
### Lock
- `critical section`으로 진입하지 못하도록 `key`를 이용하여 `lock`하는 것
- hardware의 atomic instruction을 사용하여 구현한다.
- 대부분의 현대 기기들은 `atomic hardware instruction`을 지원한다.
	- `high level`코드를 `non-interruptable`하게 만드는 역할을 한다.
	- `test`와 `set`를 사용하여 구현하거나 `swap`을 이용하는 방법으로 `lock`을 구현한다.
	- `test`, `set`, `swap`는 모두 `atomic hardware instruction`이다.
- 아래는 `lock`을 사용하는 `critical section solution`코드이다.
	```C
	do {
		/* Acquire lock */
		
		{
			/* Critical Section */
		}

		/* Release lock */

		{
			/* Remainder Section */
		}
	} while(TRUE);
	```
	- high level코드이지만 실제로는 `atomic instruction`이 사용되므로 `critical section`에 대한 보호가 가능하다.
- `Peterson's Solution`으로 2개의 프로세스에 대한 Solution은 제공할 수 있지만, 실제로는 n개의 프로세스에 대한 `critical section solution`이 요구된다. 이는 Software적인 방식으로는 현실적인 문제가 있으므로 `Synchronization Hardwar`를 이용한다.

### TestAndSet Instruction
- 아래는 `lock`을 `TestAndSet`명령어를 사용하여 구현한 코드이다.
	```C
	boolean TestAndSet(boolean *target) {
		boolean rv = *target;
		*target = TRUE;
		return rv;
	}

	do {
		while(TestAndSet(&lcok));
		
		/* critical section */
		
		lock = FALSE;
		
		/* remainder section */
	
	} while(TRUE);
	```
- `Mutual Exclusion`과 `Progress`조건은 만족한다.
- 하지만 `Bounded Waiting`조건을 만족하지 않는다는 문제가 있다.
	- 여러 프로세스가 `critical section`진입을 위해 대기하고 있다고 했을 때, 현재 실행중인 프로세스가 `critical section`에 대한 접근을 반환한 후 어떤 프로세스가 접근할 지 알 수 없다.
	- 경우에 따라서는 특정 프로세스 `critical section`에 접근을 하지 못하는 `starvation`문제가 발생할 수도 있다.
	- `Bounded Waiting`조건을 만족하지 않으므로 유효한 `critical section solution`으로 볼 수 없다.
- 이는 `critical section`으로 진입하려는 프로세스들의 **순서**가 정해지지 않았기 때문이다.

### Swap Instruction
- `Swap`명령어는 `key`와 `lock`값을 바꾸는 함수이다.
- 아래는 `lock`을 `Swap`명령어를 사용하여 구현한 코드이다.
	```C
	void Swap (boolean *a, boolean *b) {
		boolean temp = *a;
		*a = b;
		*b = temp;
	}

	do {
		key = TRUE;
		while (key == TRUE)
			Swap(&lock, &key);
			
		/* critical section */
		
		lock = FALSE;
		
		/* remainder section */
	
	} while (TRUE);
	```
- `TestAndSet`의 경우와 마찬가지로 `Mutual Exclusion`과 `Progress`조건은 만족하지만 `Bounded Waiting`조건을 만족하지 않아 유효한 `critical section solution`으로 볼 수 없다.

### Bounded Waiting 조건 해결
- 아래는 **순서**를 정해서 `Bounded Waiting`조건을 만족시키도록 `TestAndSet`을 사용하는 코드이다.
	```C
	do {
		waiting[i] = TRUE;
		key = TRUE;
		while (waiting[i] && key)
			key = TestAndSet(&lock);
		waiting[i] = FALSE;
		
		/* critical section */
		
		j = (i+1) % n;
		while((j != i) && !waiting[j])
			j = (j+1) % n;

		if(j == i)
			lock = FALSE;
		else
			waiting[j] = FALSE;
			
		/* remainder section */
	}
	```
- `critical section`을 나온 뒤 어떤 프로세스에게 `critical section`의 점유를 넘겨줄 지를 정한다.
- 위 코드상으로는 `i == j`가 아니라면 프로세스 i+1에게 `critical section`의 점유를 넘긴다.
- `i == j`인 경우는 현재 디기 중인 프로세스가 프로세스 `i`밖에 없는 상태이므로 다시 `critical section`으로 들어가면 된다.
- `waiting`배열을 통해 `critical section`접근을 대기하는 프로세스는  순차대로 접근이 보장된다. 
- 최악의 경우에도 n-1번의 다른 프로세스의 `critical section`접근이 끝난 뒤에는 `critical section`으로의 접근이 보장되므로 `Bounded waiting`을 만족한다.
- 따라서 이 Solution은 유효한 `critical section solution`이다.

## Semaphore
---
- `Semaphore`는  `wait()`, `signal()`의 두 개의 `atomic operation`에 의해서만 접근 가능한 정수 변수이다. 
- 아래는 `wait()`을 구현한 코드이다.
	```C
	wait(S) {
		while S <= 0;
		S--;
	}
	```
	- `wait()`는 `Semaphore`값을 1만큼 감소시킨다.
	- `Semaphore`값이 0이하라면 대기한다.
- 아래는 `signal()`을 구현한 코드이다.
	```C
	signal(s) {
		S++;
	}
	```
	- `signal()`은 `Semaphore`값을 1만큼 증가시킨다.

### Semaphore의 종류
- `Binary Semaphore(0..1)` : `Semaphore`는 0 또는 1의 값만 가질 수 있다(`mutex lock`이라고도 한다).
	- 초기값은 1로 설정된다.
- `Counting Semaphore(0..N)` : `Semaphore`는 는 제한된 범위의 모든 값을 가질 수 있다.
	- 여러 개의 `resources`가 있을 경우 사용한다.

### Semaphore의 사용
- `critical section problem`을 해결하기 위해 아래 코드처럼 `Semaphore`를 사용할 수 있다.
	```C
	do {
		wait(mutex);

		/* critical sesction */

		signal(mutex);

		/* remainder section */
	} while(TRUE);
	```
- `Process Syncronization`을 위해 아래 코드처럼 `Semaphore`를 사용할 수 있다.
	```C
	/* Process P1*/
	s1;
	signal(sync);

	/* Process P2 */
	wait(sync);
	s2;
	```
	- `sync`의 값이 0인 상태라면, s2는 Process P1의 signal이 실행되기 전에는 실행되지 않는다.

### Semaphore의 구현
- `Busy waiting` : 어떤 프로세스가 `critical section`에 있는 경우, `critical section`에 접근을 시도하는 다른 프로세스들은 loop의 entry code를 계속해서 계산하면서 loop을 순회하게 된다.
- `Blocking & Wake-up` : `Busy waiting`문제를 해결하기 위한 방법이다.
	- 각각의 `Semaphore`에는 `waiting queue`가 존재한다.
	- 프로세스가 `wait()`를 실행시키고 `Semaphore`값이 음수임이 확인되면 프로세스를 `waiting queue`에 삽입하여 동작을 중지한다(`block`).
	- `waiting queue`를 사용하여 다음에 실행될 프로세스의 순서가 확정되므로 `Bounded Waiting`조건을 만족한다.

### Semaphore의 문제점
- Deadlock
	- 두 개 이상의 프로세스가 `Semaphore`를 점유한 채로 다른 `Semaphore`를 `wait()`하고 있는 상태
	- 자원을 점유한 상태에서 자원을 해제하지 않고 다른 자원을 요청하는 상황이 상호 프로세스 간 맞물린 것
	- 아래 코드에서 `Semaphore` S, Q가 각각 1로 초기화 되었다면 P0과 P1은 `deadlock`상태에 빠지게 된다.
		```C
		/* Process P0 */
		wait(S);
		wait(Q);
		...
		signal(S);
		signal(Q);

		/* Process P1 */
		wait(Q);
		wait(S);
		...
		signal(Q);
		signal(S);
		```
		- P0의 `wait(S)`가 실행되면서 S = 0이 된다.
		- P1의 `wait(Q)`가 실행되면서 Q = 0이 된다.
		- P0, P1는 각각 Q, S를 요구하는 상황이 되는데(`wait(Q)`, `wait(S)`호출) 이때 서로가 자원을 해제하지 않으면 영원히 교착 상태에 빠져 탈출하지 못한다.
- Starvation
	- `Indefinite blocking`이라고도 한다.
	- 프로세스가 `Semaphore`의 queue에서 빠져나오지 못해 사실상 중단된 상태이다.
	- `deadlock`으로 인해 `Semaphore`의 queue에 있는 다른 프로세스들이 실행되지 못하여 발생한다.
- Priority Inversion
	- 높은 우선순위를 가지는 프로세스가 낮은 우선순위를 가지는 프로세스가 점유한 `Semaphore`를 대기중일 때 발생하는 문제이다.
	- 아래 그림과 같은 상황은 독립된 프로세스 간에는 상관이 없지만 서로 연관되어 있으면서 서로 다른 우선순위를 가지는 프로세스들에 의해 발생한다.![Priority Inversion](/image/OS/priority_inversion.png)
	- 위 그림에서 우선순위는 Process A가 Process B보다 높지만, Process C에서 점유한  `Semaphore`에 의해 프로세스가 block되면서 Process B가 Process A보다 먼저 실행되는 문제가 발생한다.
	- `priority inversion`문제를 해결하기 위해 `priority-inheritance protocol`을 사용한다.
	- `priority-inheritance protocol`이란 낮은 우선순위(C, 5)를 가지는 프로세스의 우선순위를 일시적으로 높은 우선순위를 가지는 프로세스의 우선순위(A, 1)를 가지도록 우선순위를 높이는 것을 말한다.
	- 이후 높은 프로세스에서 `Semaphore`에 의해 block이 일어나지 않는 시점이 되면, 낮은 프로세스의 우선순위를 원래대로 되돌린다.

## Classical Problems
---
> 본 절에서는 대표적인 동기화 문제에 대해서 알아본다.
### Bounded-Buffer Problem
- N개의 buffer가 각각 하나의 item을 hold할 수 있다고 하자.
- 아래와 같은 `Semaphore`를 사용한다.
	- `mutex` : 버퍼 pool에 `Mutual Exclusive`하게 접근하기 위한 `Semaphore`, 1로 초기화된다.
	- `full` : `full buffer`의 개수를 세기 위한 `Semaphore`, 0으로 초기화된다.
	- `empty` : `empty buffer`의 개수를 세기 위한 `Semaphore`, N으로 초기화된다.
- item을 생산하는 프로세스 Producer의 코드는 아래와 같다.
	```C
	do {
		/* Produce an item */
		wait(empty);
		wait(mutex);
		/* Add next product to buffer */
		signal(mutex);
		signal(full);
	} while(TRUE);
	```
	- `mutex`를 이용하여 버퍼 pool로의 `Mutual Exclusion`을 보장한다.
	- 생산자 프로세스에서 item을 생산할 예정이므로 `wait(empty)`를 사용해 item을 저장할 수 있는 버퍼가 있는지 확인한다.
	- 작업이 끝나면 버퍼 pool로 다른 프로세스가 접근할 수 있도록 `signal(mutex)`를 호출한다.
	- 작업이 끝나면 생산자 프로세스에서 item을 생산하였으므로 `full`을 증가시킨다.
- item을 소비하는 프로세스 Consumer의 코드는 아래와 같다.
	```C
	do {
		wait(full);
		wait(mutex);
		/* remove an item from the buffer */
		signal(mutex);
		signal(empty);
	} while(TRUE);
	```
	- `mutex`를 이용하여 버퍼 pool로의 `Mutual Exclusion`을 보장한다.
	- 소비자 프로세스에서 item을 소비할 예정이므로 `wait(full)`을 통해 사용할 item이 있는지 확인한다.
	- 작업이 끝나면 버퍼 pool로 다른 프로세스가 접근할 수 있도록 `signal(mutex)`를 호출한다.
	- 작업이 끝나면 소비자 프로세스에서 item을 소비하였으므로 `empty`을 증가시킨다.
- 참고로 프로세스 Consumer의 코드를 아래와 같이 수정하면 `deadlock`이 발생한다.
	```C
	do {
		wait(mutex);
		wait(full);
		/* remove an item from the buffer */
		signal(mutex);
		signal(empty);
	} while(TRUE);
	```
	- 만약 `full`의 값이 0인 상황에서 Consumer가 실행되어 `mutex`를 점유하게 된다고 하자.
	- 이때 `full`의 값이 0이므로 Consumer는 `wait(full)`에서 루프에 빠진다.
	- Consumer가 루프에서 탈출하기 위해서는 Product에서 item을 생산해야 한다.
	- 하지만 `mutex`가 Consumer에 의해 점유된 상태이므로 Product는 `wait(mutex)`에서 루프에 빠진다.
	- 서로가 자원을 점유한 상태에서 상대 프로세스의 자원을 대기중인 상황이므로 `deadlock`이다.
	- 아래 그림은 위 상황을 도식으로 나타낸 것이다.![Bounded Buffer Deadlock](image/OS/boundedBuffer.png) 

### Readers and Writers Problem
- Concurrent processes 간에 Data set이 공유되고 있다고 하자.
	- Readers : **only read** the data set, don't perform any updates
	- Writers : can both **read and write** the data set
- 아래의 조건을 만족해야 한다.
	- 동시에 여러 Readers가 읽는 동작을 수행하는 것을 허용한다. 
	- 하지만 오직 하나의 writer만 shared data에 접근 가능하다.
	- 이에 따른 shared data에 대한 접근 제어가 필요하다.
- Semaphores & Shared data
	- `readcount` : 몇 개의 reader 프로세스가 data set을 read하고 있는지 count
	- `mutex` : 초기값은 1로 설정되며, `readcount`가 업데이트 될 때의 `mutual exclusion`을 보장한다.
	- `wrt` : 초기값은 1로 설정되며, writer의 `mutual exclusion`을 보장한다.(writer가 1개일 때는 의미x)
- 아래에서 설명한 코드들은 writer process가 하나인 경우에 대한 solution이다.
- Writer의 코드는 아래와 같다.
	```c
	do {
		wait(wrt);
		// writing is performed
		signal(wrt);
	} while(TRUE)
	```
- Reader의 코드는 아래와 같다.
	```c
	do {
		// readcount에 대한 mutual exclusion
		wait(mutex);
		readcount++;
	
		// 첫 번째 reader의 경우 데이터가 쓰여졌는지 확인해야 한다.
		if(readcount == 1) wait(wrt);
		
		// reading is performed
	
		// readcount에 대한 mutual exclusion
		signal(mutex);
		readcount--;
	
		// 마지막 reader의 경우 writer가 쓸 수 있는 상태임을 알려줘야 한다.
		if(readcount == 0) signal(wrt);
		
		signal(mutex);
	} while(TRUE)
	```

### Dining-Philoosophers Problem
- 식사하는 철학자 문제(사진출처 : 위키피디아)![Dining Philosophers Problem](/image/OS/dining_philosophers.png)
- 굉장히 큰 규모의 concurrent process의 동시제어가 필요한 상황에 대해 다룬다.
- 문제 설명
	- 다섯 명의 철학자가 원탁에 앉아 있고, 음식을 먹기 위해서는 양 옆의 젓가락을 동시에 들어야 한다.
	- 이때 바로 옆의 사람이 음식을 먹기 위해서는 본인이 젓가락을 내려 놓아야 하는 상황이다.
	- 다섯 명 모두가 서로를 기다리는 `deadlock`상태에 빠질 수 있다.
- chopstick을 `semaphore`로, philosophers를 `process`라고 생각하자.
	- 젓가락의 사용 여부를 mutex로 0/1로 표현한다.(초기값은 1로 설정된다.)
	- 규칙을 tough하게 설정하여 `deadlock`이 발생하지 않도록 만들어야 한다.

## Monitor
---
- `Semaphore`를 잘못 사용하면 `deadlock`을 포함한 탐지하기 힘든 error를 유발한다.
	- signal(mutex) -> wait(mutex) : `Mutual Exclusion`을 만족하지 않는다.
	- wait(mutex) -> wait(mutex) : `deadlock`상태에 빠질 위험이 있다.
	- wait(mutex), signal(mutex)를 빠트린 경우 : `Mutual Exclusion`, `deadlock`모두 유발 가능
- Java에서는 `Semaphore`를 잘못 사용하는 문제 등을 high level에서 해결하기 위해 `Monitor`를 제공한다.
- `Monitor`의 동작은 아래와 같다.![Monitor](/image/OS/monitor.png)
	- 모니터 내부의 프로시저들이 순차적으로 실행된다.
	- condition variable을 사용한다.(그림에서의 x와 y)
	- condition variable에 대한 wait(), signal()메소드를 제공한다.
		- `wait` : 어떤 프로세스를 대기 상태로 변경
		- `signal` : 대기 상태에서 다시 resume
- 아래 코드의 프로시저(P1, P2, P3 ... )는 한 번에 하나만 실행 가능하다.
	```java
	monitor monotor_name {
		// shared variable declaration
		procedure P1(...) {...}
		
		procedure P2(...) {...}
		
		procedure P3(...) {...}
	
		...
	}
	```
