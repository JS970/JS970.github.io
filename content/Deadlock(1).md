+++
title = "Deadlock(1)"
date = 2023-05-01
[taxonomies]
tags = ["Operating System"]
[extra]
author = "JS970"
katex= true
+++
## Deadlock - Deadlock conditions
---
- 프로세스는 한정적인 resource를 사용한다. 이때 다른 프로세스가 사용중인 resource를 요구할 수 있다.
- 이 때 발생하는 문제에 대해 좀 더 직관적으로 살펴보기 위해 system model관점에서 살펴보자.

### System Model
- 시스템은 `resource`와 `process`로 구성된다.
	- `resource`들은 Resource Type으로 분류한다.(R1, R2, R3, ... , Rm)
	- 각 Resource Type들은 CPU cycle, Memory space, I/O devices등 자원 타입을 의미한다.
- Resource Type Ri는 Wi개의 `instance`를 가질 수 잇다.
	- 자원 종류별로 사용 가능한 `instance`개수가 제한된다.(Class-Object 개념으로 생각하자)
- 프로세스들은 아래와 같은 과정으로 `resource`를 사용한다.
	- Request(자원 요청)
	- Use(자원 사용)
	- Release(자원 반납)

### deadlock
> A set of blocked processes each holding a resource and waiting to acquire a resource held by another process in the set
- 두 개의 프로세스가 자원을 보유(`held`)한 상태로 상대방의 자원을 `request`하고 있는 상황이 `deadlock`이다.
- 자원을 해제하지 않으면서 다른 프로세스에 의해 점유된 자원을 `request`하는 것이 `deadlock`의 원인이다.
- `deadlock`을 해결하기 위해서는 `held`하고 있는 자원을 `release`하면 된다.
- 다음 장에서 설명할 4가지 deadlock conditions를 동시에 만족하면 deadlock이 발생할 가능성이 있다.

### Deadlock conditions
- 아래의 1, 2, 3, 4번 조건을 모두 만족한다면 deadlock이 발생할 가능성이 있다.
1. `Mutual Exclusion`
	- 하나의 프로세스만 하나의 자원을 사용할 수 있는 상황이다.(semaphore 등)
2. `Hold and Wait`
	- 다른 프로세스에서 hold되어진 자원을 요청하고 이를 기다리는 상황이다.
3. `No Preemption`
	- resource가 오직 resource를 hold하고 있는 프로세스의 release를 통해서만 회수된다.
4. `Circular Wait`
	- 프로세스 간 순환 구조를 형성하면서 대기중이다.
	- P1 -> P2 -> P3 -> P4 -> P1

### Resource Allocation Graph
- 아래는 Resource Allocation Graph의 구성 요소 도식이다.![Allocation Graph Consistents](/image/OS/resourceAllocationElements.png)
- 그래프의 vertices는 두 가지 타입으로 구성된다
	- process(P0, P1, ..., Pm) : m개의 프로세스가 존재
	- resource(R0, R1, ..., Rn) : n개의 resource가 존재
- 그래프의 edge 역시 두 종류가 있다.
	- Request Edge : directed edge Pi -> Rj
	- Assignment Edge : directed edge Rj -> Pi

### Resource Allocation Graph Example1(No Deadlock)
![Resouurce Allocation Graph Example(No Deadlock)](/image/OS/resourceAllocationGraphNoDeadlock.png)
- R1, R2, R3, R4는 mutex조건(mutual exclusion)을 만족한다고 가정하자.
	- 위 그래프만으로는 알 수 없다.
- hold and wait
	- P1은 R2를 hold하고 있으며 R1을 request하고 있다.
	- P2는 R1을 hold하고 있으며 R3를 request하고 있다.
	- P3의 경우 R3를 hold하고 있지만 resource를 request하고 있지 않다.
- No Preemption조건 역시 그래프만으로는 확인할 수 없으므로 만족한다고 가정하자.
- Circular Wait
	- circular wait을 만족하지 않는다.
	- P1 -> R1 -> P2 -> R3 -> P3, R2 -> P2

### Resource Allocation Graph Example2(Deadlock)
![Resource Allocation Graph with Deadlock](/image/OS/resourceAllocationGraphDeadlock.png)
- R1, R2, R3, R4는 mutual exclusion 조건을 만족한다고 가정하자.
- Hold and Wait
	- P1, P2, P3모두 해당된다.
- No Preemption조건을 만족한다고 가정하자.
- Circular Wait조건을 만족한다.
	- P1 -> R1 -> P2 -> R3 -> P3 -> R2 -> P1(P2)
- 네 가지 조건을 만족하기 때문에 deadlock이 존재할 수 있고, 실제로도 있다.
	- 네 가지 조건을 만족해도 deadlock이 없을 수 있다. 아래의 예시를 보자.

### Resource Allocation Graph Example3(No Deadlock)
![No Deadlock with deadlock conditions](/image/OS/resourceAllocationGraphCircleNoDeadlock.png)
- 위 그래프는 deadlock condition의 네 가지 조건을 모두 만족한다. 
- 하지만 실제로 deadlock은 발생하지 않는다.
- 이는 P4(또는 P2)가 자원을 release하면 P3가 R2에 접근하면서 Circular Cycle이 깨지게 된다.
- cycle은 P1과 P3가 형성하지만 P2, P4에 의해 cycle이 깨질 수 있으므로 deadlock이 발생하지 않는다.
- 결국 Resource Allocation Graph를 통해서 확실히 알 수 있는 정보는 cycle유무를 통해 deadlock이 없다는 것을 확실히 할 수 있다는 것이다.