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
> Critical Section에 대한 Software-based Solution이다.
- LOAD/STORE는 atomic opetaion이라고 가정하자.
- Critical Section을 공유하는 프로시저들은 아래의 두 변수를 사용한다.
	- turn : 누가 critical section에 접근할 수 있는지를 저장한다.
	- flag\[i] : 프로세스 i가 critical section에 접근할 준비가 되었음을 나타낸다.
```C
int turn;
boolean flag[i];
```
- 아래는 Pi와 Pj에 대한 Peterson's Solution을 적용한 예시이다.
	- Pi의 관점에서는 Pj가 실행중일 때는 while문을 이용해 Pj의 Critical Section접근 권한이 유효한 동안 무한 대기한다. Pj의 경우 반대로 동작한다.
	- Exit Section에서는 접근 권한을 반환하여 while문에서 대기중이던 상대 프로세스가 Critical Section으로 진입할 수 있도록 한다.
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
> 중간고사 이후 이어서 계속...