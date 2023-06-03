+++
title = "Deadlock - Deadlock Handling"
date = 2023-05-03
[taxonomies]
tags = ["Operating System"]
[extra]
author = "JS970"
katex= true
+++
# Flow
- Deadlock Handling - Deadlock Prevention
- Deadlock Handling - Deadlock Avoidance
- Deadlock Handling - Deadlock Detection

## Deadlock Handling - Deadlock Prevention
---
- deadlock condition중 최소 한 가지 이상의 조건을 만족하지 않도록 설정하여 deadlock을 예방하는 방법
- Computational Overhead가 너무 커서 실제로 사용하지는 않는다.
- 본 절에서는 방법론에 대해서만 다룬다.

### Mutual Exclusion
- shared resources를 require하지 않고 nonsharable resource만 hold하는 방법으로 구현한다.
- 일반적으로 Mutual Exclusion을 부정하는 방법으로는 deadlock prevent를 할 수 없다.
	- 일부 자원의 경우 애초부터 non-sharable이기 때문

### Hold and Wait
- 어떤 프로세스든 자원을 request할 때는 어떠한 resource도 hold하지 않는 것을 보장한다.
- 오버헤드가 너무 크다.(Low resource utilization문제가 있다)
- starvation이 발생할 가능성이 있다.

### No Preemption
- 어떤 프로세스가 자원을 holding하고 있으면서 request할 때, 곧바로 할당받는 것이 아니라 모든 resource를  release한 후에 자원을 할당받는다.
- 프로세스는 모든 자원을 확보한 후에야 실행 가능하다.
	- 결과적으로 한번의 request를 통해 필요한 자원을 확보애햐 한다
- Preemptive동작을 하는 것과 동일한 효과이다.

### Circular Wait
- waiting이 circular cycle을 형성하지 않도록 한다.
- process, resource가 increasing order로만 request가능하도록 설정한다.
- P3는 P1이 점유중인 자원에 대해 request할 수 없는 rule을 만들어서 구현하는 방식이다.

## Deadlock Handling - Deadlock Avoidance
---
- Deadlock Avoidance를 구현하기 위해서 시스템은 아래와 같은 사전 정보를 필요로 한다.
	- Resource currently available
	- The resources currently allocated to each process
	- The future requests and releases of each process
- Deadlock Avoidance는 앞서 설명한 사전 정보들을 이용해서 circular-wait condition을 형성하는 자원 할당이 이루어지지 않도록 dynamically examines하는 알고리즘이다.

### Safe State
- 데드락을 발생시키지 않는 상태
	- `unsafe`의 경우 데드락이 생길 수도 있고, 생기지 않을 수도 있다.
- 프로세스가 자원 할당을 요청할 때, 시스템은 immediate allocation이 시스템의 `safe state`에 영향을 미칠지를 판단해야 한다.
- 만약 시스템의 모든 프로세스에 대해 P0, P1, P2, ..., Pn의 sequence가 존재한다면 시스템은 `safe State`에 있다고 한다.
	- 시스템의 모든 프로세스 request에 대해 데드락을 발생시키지 않는 프로세스의 sequence가 있다면 시스템은`safe state` 이다.

### Deadlock Avoidance Strategy
- Deadlock Avoidance를 위해서는 아래와 같은 사항을 생각해야 한다.
	- 현재 시점에서 `safe state`여야 한다.
	- request가 온 이후에도 `safe state`여야 한다.
		- request가 온 것으로 가정(pretend)하고 deadlock이 발생할지 판단한다.
		- 이는 미래에 올 request를 알고 있기 때문에 가능하다.
- 자원이 한 개의 인스턴스로만 이루어질 때는 `resource-allocation graph`를 사용한다.
- 자원이 여러 개의 인스턴스 타입을 가질 때는 `Banker's Algorithm`을 사용한다.

### Resource-Allocation graph Scheme
- 자원이 한 개의 인스턴스로만 이루어질 경우 Deadlock Avoidance를 위해 사용한다.
-  `claim edge` : Pi가 Rj를 request할 지도 모른다는 것을 점선으로 표시한다.
	- 할당된 자원이 해제되면 `assignment edge`는 `claim edge`로 변경된다.
- `request edge` : 실제로 프로세스가 자원을 request할 경우
	- `claim edge`의 Pi가 실제로 Rj를 request하면 `request edge`로 변경된다.
- `assignment edge` : 자원이 실제로 프로세스에 할당된 경우
	- request에 따라 자원이 할당되면 `request edge`는 `assignment edge`로 변경된다.
- 자원 할당은 claim -> request -> assignment의 과정을 거친다.![Resource-Allocation Graph Scheme](/image/OS/graphAvoidance.png)
	- 항상 claim을 처리하는 것이 아닌, claim 요청을 통해 cycle이 생성되지 않는 경우에만 request를 통해 assignment를 수행한다.
	- 잠정적으로 deadlock을 발생시킬 수 있는 cycle이 발생하면 request를 처리하지 않는다.
	- 위 도식에서 P2는 R2를 claim하지만, 이 `claim edge`가 `request edge`로 변경되면 cycle이 생성되므로 이는 request되지 않는다.

### Banker's Algorithm
- 자원이 여러 개의 인스턴스 타입으로 이루어질 경우 Deadlock Avoidance를 위해 사용된다.
- Banker's Algorithm 용어 정리
	- `n` : 프로세스의 개수
	- `m` : resource 인스턴스의 개수
	- `available[j] = k` : Rj는 k개의 인스턴스에 할당 가능하다.
	- `Max[i, j] = k` : Pi는 최대 Rj에 최대 k개의 인스턴스를 요청할 것이다.
	- `Allocation[i, j] = k` : Pi는 Rj로부터 k개의 인스턴스를 할당받은 상태이다.
	- `Need[i, j] = k` : Pi는 task 수행을 완료하기 위해 Rj에 k개(이상)의 인스턴스를 요청할 것이다.
		- Need\[i, j\] = Max\[i, j\] - Allocation\[i , j\]
- Safety Algorithm
	1. `Work` : m크기의 벡터, `Finish` : n크기의 백터. 
		- `Work` = `Available`, `Finish[i] = false`로 초기화한다.
	2. `Finish[i] == false` 이고, `Need[i] <= Work`인 i를 찾는다. 만약 이러한 i가 없다면 4로 간다.
	3. `Work` = `Work` + `Allocation[i]`, `Finish[i] = true`, 2로 돌아간다.
	4. 만약 모든 i에 대해`Finish[i] == true` 라면 시스템은 `safe state`이다.
- Resource-Request Algorithm for Pi
	- `Request[i, j]` : Pi의 Rj로의 request vector
		- `Request[i, j] = k`라면 Pi가 Rj의 인스턴스 k개를 요청하는 것이다.
	1. 만약 `Request[i, j] <= Need[i]` 라면 2로 넘어간다. 이외의 경우 에러를 발생시킨다.
	2. 만약 `Request[i, j] <= Available[j]` 라면 3으로 넘어간다. 
		- 이외의 경우 자원 할당이 불가능하므로 대기해야 한다. 
	3. Pi에 자원 할당을 하는 것처럼 아래와 같이 시뮬레이션 한다.(pretend to allocate)
		- `Available[j]` = `Available[j]` - `Request[i]`
		- `Allocation[i]` = `Allocation[i]` + `Request[i]`
		- `Need[i]` = `Need[i]` - `Request[i]`
	- 위의 과정을 모든 프로세스에 대헤 진행하여 safe하다면 Pi에 자원을 할당한다.
	 - unsafe라면 Pi는 선행 프로세스가 자원 할당을 해제할 때까지 대기해야 한다.
- Banker's Algorithm 동작
	1. Request에 대해 `Resource-Request Algorithm`을 수행한다.
	2. `Safety Algorithm`을 수행하여 `safe state`를 검사한다.
- Deadlock Avoidance에서는 `Need`정보를 바탕으로 `safe sequence`가 존재하는지 검사한다. 
	- `safe sequence` 가 존재한다면 Deadlock Avoidance가 되는 것이다.
	- `safe sequence`가 존재하지 않는다면 `unsafe`이다.

## Deadlock Handling - Deadlock Detection
---
- 앞서 살펴본 Deadlock Prevention, Deadlock Avoidance는 오버헤드가 너무 커서 실제로는 사용하지 않는 Deadlock 해결 방법이다.
- 실제로는 Deadlock을 허용하고, 이를 탐지하여 처리하는 방법인 Deadlock Detection을 사용한다.
	- 이 방법 역시 오버헤드가 적지는 않지만 앞선 두 방법보다는 확실히 현실적이다.
- 자원이 한 개의 인스턴스로 이루어진 경우 `request-allocation graph`를 변형한 `wait-for graph`를 사용한다.
- 자원이 여러 개의 인스턴스로 이루어진 경우 `변형된 banker's algorithm`을 사용한다.

### Wait-for graph
![Wait - For Graph](/image/OS/waitForGraph.png)
- 앞서 다루었던 `resource-allocation graph`를 통해 `wait-for graph`를 만들 수 있다.
- `resource` 를 고려하지 않고 프로세스 간의 관계만 고려한다.
	- 자원이 한 개의 인스턴스로 이루어졌으므로 이것이 가능하다.

### Variant of the Banker's Algorithm
- Deadlock Avoidance가 목적이 아니라 Deadlock Detection이 목적이다.
- `Need[i]`에 대해서는 생각하지 않고, 순간 순간의 `Request[i]`를 처리할 수 있는지 판단한다.
- 모든 `Request`가 처리되는 `sequence`가 존재한다면 해당 시스템에서는 Deadlock이 탐지되지 않은 것이다.
	- 이는 `Request`의 순서를 다루는 것이므로 `safe sequence`와는 다른 개념이다.
- 만약 `Work[i]`상태에서 처리할 수 있는 `Request[i]`가 없다면, `Finish == false`인 모든 프로세스가 Deadlock을 유발하는 프로세스이다.
- `Finish == false`로 Deadlock을 유발하는 프로세스들에 대해서 `Process Termination`혹은 `Resource Preemption`을 통해 Deadlock Recovery를 수행한다.

### Recovery shceme : Process Termination
- Deadlock이 Detection된 경우 프로세스를 종료시키는 방법
- 한 번에 프로세스를 하나씩 abort하면서 deadlock이 없어지는지(cycle이 없어지는지)확인한다.
- 경우에 따라 다르지만 아래와 같은 기준으로 abort순서를 정한다.
	- 프로세스의 priority
	- 프로세스가 얼마나 오래 실행되었는지, 혹은 실행시간이 얼마나 남았는지
	- 프로세스가 사용한 자원의 양

### Recovery Scheme : Resource Preemption
- `victim`을 선택한다.(minimize cost)
- `safe state`로 돌아간 뒤 해당 상태에서 다시 프로세스를 실행시킨다.
- 이 과정에서 cost를 줄이는 방향으로 `victim`을 선정하게 되면 특정 프로세스가 계속 `victim`이 되어 `starvation`문제가 발생할 수 있다.
	- 딱히 권장하는 방법은 아니다.