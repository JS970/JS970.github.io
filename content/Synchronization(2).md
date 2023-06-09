+++
title = "Synchronization(2)"
date = 2023-04-12
[taxonomies]
tags = ["Operating System"]
[extra]
author = "JS970"
katex= true
+++
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
