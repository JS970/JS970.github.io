+++
title = "Virtual Memory Management Strategy(1)"
date = 2023-05-22
[taxonomies]
tags = ["Operating System"]
[extra]
author = "JS970"
katex= true
+++
## Virtual Memory overview
---
- 어떤 프로그램이 실행될 때 그 프로그램 전체가 로딩될 필요는 없다.
	- 에러 코드 및 그 처리에 관한 코드는 에러가 발생했을 때 로딩해도 된다.
	- Array, lists, table등은 실제 필요한 것보다 매우 큰 메모리 할당을 요구한다. (dynamic loading)
	- 프로그램의 option을 포함한 특정 기능들은 잘 사용되지 않거나 거의 사용되지 않을 수 있다.
	- 하드디스크에서 메모리로의 load는 많은 오버헤드가 발생하므로, 당장 필요한 코드만 load해서 사용하면 오베헤드를 줄일 수 있다.
- 프로그램 실행에 있어 프로그램 전체를 로딩하지 않으면 아래와 같은 이점이 있다.
	- 더 이상 사용 가능한 physical memory에 제한받지 않는다.
		- physical memory보다 큰 프로그램을 구동 가능하다.
	- 한번에 더 많은 프로그램을 동시 실행할 수 있다(timesharing)
	- load, swap등의 동작에 I/O request으로 인한 오버헤드를 줄일 수 있다.
- 이러한 프로그램 실행은 `virtual memory management`를 통해 구현 가능하다.![Virtual Memory Overview](/image/OS/virtualMemory.png)
	- `virtual memory`를 통해 user의 `logical memory`와 `physical memory`를 독립적으로 볼 수 있다.
	- `virtual memory`가 `physical memory`보다 큰 것을 확인할 수 있다.
	- `virtual memory`에서 memory map을 통해 요구되는 데이터가 `physical memory`에 존재하지 않는 경우 `swapping`을 통해 backing store에서 `physical memory`로 데이터를 가져온다.
	- 뿐만 아니라 여러 프로세스를 Timesharing을 통해 동시 실행할 수 있다.
	- 프로그램 전체가 로딩되는 것이 아니므로 I/O request총량 역시 적다.
- 이러한 `virtual memory management`는 아래의 방법으로 구현할 수 있다.
	- Demand paging
	- Demand segmentation

## Demand Paging
---
- `Demand Paging`이란 프로그램에서 필요로 하는 데이터가 필요할 때만 메인 메모리로 load하는 것이다.
- `Demand Paging` 을 위해서는 `swap-in`, `swap-out`동작을 수행하는 `swapper`가 필요하다.
- `swapper`는 `lazy swaper`라고도 불린다. 이는 `page`가 필요할 때까지 `swap`을 수행하지 않기 때문이다.
- 메인 메모리에 찾고자 하는 `page`가 있는지 없는지를 판단하기 위해 `MMU` 등 하드웨어의 도움을 받기도 한다.
- 메인 메모리에 찾고자 하는 `page`가 있으며 `legal`하다면 이를 사용하면 된다.
- 메인 메모리에 찾고자 하는 `page`가 없을 경우 이를 `page fault`라고 한다.
	- 단순히 메인 메모리에 `page`가 없는 경우 `swapping`을 통해 메모리로 `page`를 로드한다.
	- 만약 `invalid reference`의 경우 system call을 통해 abort한다.
	- machine이 부팅된 직후에는 당연히 모든 `page`가 메인 메모리에 존재하지 않으므로 not-in memory 상태이다. 이러한 경우 `swap-out`동작은 별도로 필요하지 않다.
- `page fault`가 발생하면 아래의 순서대로 동작한다.![Demand Paging](/image/OS/demandPaging.png)
	1. 운영 체제는 `invalid reference`인지 `not-in-memory`인지 판단한다.
	2. `not-in-memory`의 경우 Free frame을 찾는다. (`invalid reference`면 abort한다)
	3. `backing store`와 메모 Free frame간의 `swapping`을 수행한다.
	4. `page table`의 valid/invalid bit을 수정한다.
	5. `page fault`를 유발한 명령어를 재수행한다.
	- 위 과정에서 `swap-out`동작은 생략되었다. `physical memory`가 Free frame이 아닌 경우 `swap-out`역시 필요하다.
- `demand paging`의 성능은 아래와 같은 세 가지 요소에 의해 결정된다.
	- Service the interrupt
	- Read the page
	- Restart the process
- `page fault rate`를 p 라고 하자. p = 0이면 `page fault`가 발생하지 않는 것이고, 1이면 모든 참조가 fault인 것을 의미한다.
	- 이때 EAT(Effective Access Time)는 (1-p) \* Memory Access Time + p \* Page Fault Service Time
	- Page Fault Service Time = page fault overhead = swap page out + swap page in + restart overhead
- `virtual memory`를 사용하는 중, process가 fork된 상황을 가정해 보자. 이때 실제로 자식 프로세스가 부모 프로세스와 독립된 `physical memory`를 가지지 않는다.
	- 필요한 경우에만 `physical memory`에 공간을 만드는 것이다.
	- `virtual memory mapping`을 통해 같은 `physical memory`를 공유한다.
	- 두 프로세스 중 R/W 동작이 발생하면 그때 `physical memory`에 새로운 메모리 공간을 할당한다.
	- 이를 `Copy-on-Write(COW)`라고 한다.

## Page Replacement
---
- `demand paging`과정에서 `swapping`횟수를 줄이는 것은 한계가 있다.
- 일반적으로 프로세스에 할당되는 `frame`의 개수를 늘리면 `page fault`는 줄어들지만 이 역시 한계가 있다.![Increase Frame](/image/OS/increaseFrame.png)
- 결국 `physical memory`에 존재하는 `frame`중 `victim page`를 선택하여 `swapping`을 해야 한다.![victim](/image/OS/victim.png)
- 이때 `victim page`를 선택하는 알고리즘에는 아래와 같은 알고리즘이 있다.
	- FIFO page replacement
	- Optimal page replacement
	- LRU page replacement
	- LRU-Approximation page replacement
	- Counting-Based page replacement
		- LFU algorithm
		- MFU algorithm
- 위 알고리즘을 통해 적절한 `victim page`를 선택하여 `page fault`를 최소화 하는 것이 최종 목적이다.

### FIFO page replacement
- `page frame`에 load 된 순서대로 교체되는 알고리즘이다.
- 즉, `victim page`는 가장 오래된 `page`가 선택된다.
- 성능이 좋지 않아서 다른 `page replace algorithm`에 보조 알고리즘으로 사용된다.
- 무엇보다 프로세스 당 할당되는 프레임의 수를 늘려도 경우에 따라 오히려 `page fault`가 증가하여 결과에 대해 예측하기 힘들다는 단점이 있다.![FIFO page replacement graph](/image/OS/fifoGraph.png)
	- `frame`을 3개에서 4개로 늘렸을 경우 오히려 `page fault`가 증가했다.
	- 이러한 현상을 `Belady's abnomaly`라고 한다.

### Optimal page replacement
- 가장 이상적인 `page replace algorithm`이지만 현실적으로 구현할 수 없다.
- 다른 `page replace algoritm`의 성능을 이 알고리즘과 비교하는 데 사용된다.
- `physical memory`에서 가장 나중에 사용될 `frame`을 `victim frame`으로 설정한다.
	- 가장 나중에 사용될 `frame`을 판단할 방법이 없다.
	- 이 방법을 사용해도 `page fault`는 발생한다. 이는 프로세스 당 `frame`이 제한되어 있기 때문이다.

### LRU(Least recently Used) algorithm
- `Optimal page replacement`에서는 미래에 사용될 `frame`을 체크했다. `LRU algorithm`에서는 과거에 사용된 `frame`중 가장 이전에 참조된 `frame`을 `victim frame`으로 설정한다.
- `locality`를 고려하였기 때문에, `LRU`는 `Optimal page replacement`에 근사한다.
- `stack`을 사용하기 때문에 `Belady's anomaly`가 없다.
- 하지만 소프트웨어를 이용한 방식만으로는 구현하기 힘들다. (Requires H/W supports)![LRU stack issue](/image/OS/stackIssue.png)
	- 위 그림에서 확인할 수 있듯이, a지점 이후 7을 참조하게 된다.
	- 하지만 7은 스텍의 중간에 위치해 있다. 이를 빼내어 stack.top에 올릴 방법이 없다.
	- 이 과정에서 주소를 참조하는 방식으로 하드웨어의 도움을 받아야 한다.
	- 하지만 이런 하드웨어는 비싸다.

### LRU-Approximation algorithm
- `use bit`을 사용하는 하드웨어의 도움을 받는다.
	- `page`가 참조될 때마다 `use bit`의 값을 1로 설정한다.
- 하드웨어는 절대 `use bit`을 clear하지 않는다. 이는 OS의 역할이다.
- LRU-Approximation : Reference Bit
	- 각 `page`마다 8비트의 `reference bit`을 가진다.
	- `reference bit`의 초기값은 0으로 초기화된다.
	- 참조된 경우 가장 왼쪽 비트를 1로 갱신한다.
	- 참조되지 않은 경우 right shift한다.
	- 8-time interval동안 페이지의 참조 정보를 알 수 있다.
	- `11000100`인 페이지는 `01110111`인 페이지보다 더 최근에 사용된 `frame`이다.
- LRU-Approximation : Second-Chance algorithm
	- `FIFO algorithm`에 하드웨어가 제공하는 `reference bit`이 추가된 circular queue형태이다.![Second-Change Algorithm](/image/OS/secondChance.png)
	- 위 도식처럼 페이지가 참조될 때 `reference bit`를 1로 갱신한다.
	- `reference bit`이 1인 경우 바로 해당 `page`를 `victim frame`으로 선정하지 않는다. 이때 `reference bit` 값은 0으로 갱신한다.
	- 모든 `reference bit`값이 동일하다면 `FIFO algorithm`과 동일하게 동작한다.
	- `reference bit`를 1bit이 아닌 2bit, 3bit으로 제공하여 `enhanced second-chance algorithm`으로 사용하기도 한다.

### Counting-Based algorithm
- 각각의 프레임은 참조가 일어난 횟수를 저장하는 카운터를 가진다.
- LFU(Least Frequently Used) algorithm은 가장 적은 횟수의 참조가 일어난 프레임을 `victim frame`으로 선정한다.
- MFU(Most Frequently Used) algorithm은 가장 많은 횟수의 참조가 일어난 프레임을 `victim frame`으로 선정한다.
- 어떤 알고리즘이든 정답은 없다. 프로그램 및 시스템 상황에 맞는 알고리즘을 선택하면 된다.

### Workload
- 일반적으로 `page replacement algorithm`에 의해 참조의 80%가 20%의 프레임에 대해 일어나고, 나머지 20%의 참조가 80%의 프레임에 대해 일어날 때 효율이 좋은 편이다.![Workload Hit Ratio](/image/OS/hitRatio.png)
	- 위 그래프는 80-20 Workload에서 각 알고리즘의 성능을 비교한 것이다.
	- 사실 메모리 크기가 충분하다면 알고리즘에 따른 차이는 없다.

## Allocation of Frames
---
> 앞서 언급한 내용들은 프로세스 당 할당되는 프레임이 제한되어 있기 때문에 이에 따라 발생하는 swapping의 횟수를 줄이고자 했다. 본 절에서는 프로세스 당 할당되는 프레임의 개수에 대해 다룬다.
- 각각의 프로세스들은 최소 프레임 개수가 존재한다.
	- 이는 컴퓨터 구조에 따라 다르고, 프로세스의 종류에 따라 다르다.
	- 예시로 IBM370의 경우 MOVE 명령어를 수행하는 데 6 page를 필요로 했다.
- 이러한 프로세스 별 프레임 할당은 아래와 같은 관점에서 바라볼 수 있다.
	- Fixed allocation vs Priority allocation
	- Global allocation vs Local allocation
- `FIxed allocation`에서는 모든 프로세스가 동일한 양의 프레임을 할당받는다.
	- `Equal allocation` : 100개의 프레임이 있고, 5개의 프로세스가 존재한다면 각각의 프로세스는 20프레임씩 할당받을 것이다.
	- `Proportional allocation` : 프로세스의 크기에 따라 프레임을 할당하는 방법이다. `priority allocation`의 일종으로 생각할 수도 있다.
- `Priority allocation`프로세스의 priority에 따라 프레임을 할당받는다.(프로세스의 크기는 고려 x)
	- 어떤 프로세스에서 `page fault`가 발생했다면 그보다 낮은 프로세스의 `frame`을 가져다 쓴다.
- `Global replacement`방식에서는 프레임의 `swapping`에 있어 프로세스를 따지지 않는다.
	- 앞선 `Priority allocation`을 생각할수 있다.
	- 이 경우 프로그램의 수행시간을 예측하기 힘들다.
- `Local replacement`의 경우 각각의 프로세스 내에서만 `swapping`이 일어난다.
	- `Global replacement`와 비교하여 균일한 수행 시간을 가지게 된다.
	- 하지만 underutilized memory가 발생할 수 있다.