+++
title = "Memory Management(2)"
date = 2023-05-12
[taxonomies]
tags = ["Operating System"]
[extra]
author = "JS970"
katex= true
+++
## Memory Allocation Schemes - Continuous Memory Allocation
---
- `MMU`에서  `limit register`, `relocation register`를 사용하여 프로세스 단위로 메모리 할당.
- 메모리 상에서 free space(`hole`)를 탐핵하여 프로세스를 할당한다.
- `partition`이 늘어나면 memory management관점에서 multiprogramming이 제한된다.
- 프로세스가 할당되기에 충분한 `hole`에 프로세스를 할당한다.
	- `first-fit` : 메모리를 탐색해서 할당 가능한 `hole`이라고 판단되면 바로 할당한다.
	- `best-fit` : 모든 메모리를 탐색해서 할당 가능한 가장 작은 `hole`에 할당한다.
	- `worst-fit` : `best-fit`과 반대로 할당 가능한 가장 큰 `hole`에 할당한다(이렇게는 안한다).
- `hole`이 여러 개 생기게 되면서 실제로는 메모리 공간이 남아 있지만 프로세스를 할당할 수 없는 경우를 `external fragmentation`이라고 한다.
	- `worst-fit`을 사용하여 프로세스를 할당하지 않는 이유가 외부 단편화가 심하기 때문이다.
	- `compaction`을 사용하여 외부 단편화를 해결할 수 있다.`compaction`은 `relocation`을 통해 메모리 상의 `hole`을 없에는 것을 의미한다. 이는 소프트웨어적인 방법으로는 불가능하다. 또한 `dynamic relocation`을 사용하는 경우에만 실현 가능하다.
	- `external fragmentation`문제를 해결하기 위해 non-continuous한 `logical memory`주소를 허용하여 `physical memory`의 어느 곳이든 할당 가능하도록 만드는 방법이 있다. 이렇게 해결하는 방법으로`Paging`과 `Segmentation`이 있다.
- `internal fragmentattion`은 메모리가 할당될 때 실제 할당된 메모리보다 살짝 남겨 쓰는 것. int 타입 변수에 short로 충분한 값을 쓰는 행위 등으로 볼 수 있다.
	- 이정도는 그냥 감안하고 넘어간다.

## Memory Allocation Schemes - Paging
---
### Paging Overview
![Paging Overview](/image/OS/paging.png)
- `page`와 `page frame`은 같은 크기를 가지는 단위이다. `page`는 `virtual memory`에 존재하고, `page frame`은 `physical memory`에 존재한다.
- 한 프로세스 내에서 `page`는 `page table`을 통해 `physical memory`로 1:1 매핑된다.
- `pageing`을 통해 궁극적으로 non-continuous한 프로세스의 메모리 할당이 가능하다.
	- 이로 인해 `external fragmentation`을 줄일 수 있다.
	- `internal fragmentation`에 대해서는 근본적인 해결이 되지는 않는다.
- 프로세스를 매핑하기 위해서는 `page table`역시 메모리에 load되어야 한다. 이 역시 오버헤드로 작용한다.
- `page table`의 관리를 위해 `TLB`라는 하드웨어를 사용하기도 한다.

### Address Translation Scheme
- `Page number` : 페이지 테이블의 index로 사용되며, 각각의 `page`가  `physical memory`로 매핑될 때의`base address`를 포함한다.
- `Page offset` : `base address`주소와 합쳐져서 `physical memory`의 주소를 도출하는 데 사용된다.
- m비트의 `logical address space`를 가지고 `page size`가 n비트라면 아래와 같은 구조를 가진다.![Address Translation Scheme](/image/OS/addressTranslationScheme.png)
- 32byte의 메모리에 `page entry size`가 4 byte인 경우 `page table`에 의해 아래와 같이 할당된다.![Paging Scheme](/image/OS/pagingScheme.png)
- `internal fragmentation`에 대해 계산해 보자.
	- page size = 2048 bytes
	- process size = 72766 bytes
	- 이 경우 72766 / 2048 = 35 \* 2048 + 1086 이므로 마지막 frame에는 1086 byte만 할당된다.
	- frame size = 2048 bytes 이므로 총 2048 - 1086 = 962 bytes의 `internal fragmentation`이 발생한다.
	- 최악의 경우 1바이트 초과로 인한 internal fragmentation이 발생할 수도 있다.
- `internal fragmentation`을 줄이기 위해 `page size`를 작게 만드는 것은 한계가 있다.
	- `page size`를 작게 하면 `page table`의 크기가 커지는데, 이 또한 메인 메모리에 적재되기 때문이다.
	- 그래서 일부 운영체제에서는 두 개의 `page size`를 설정하여 상황에 맞게 선택하여 사용하기도 한다.

### Free frames
- page 할당을 위해서는 non-continuous하게 할당된 메모리 공간에서 scatter되어 있는 free frame을 찾아야 한다.
- 이를 처리하기 위해 `free-frame list`를 도입한다. 이는 linked list등의 자료 구조를 이용한다.

### Page Table의 구현
- `page table`은 메인 메모리에 계속 적재되어 있어야 한다.
- `page table`은 `PTBR`(Page table base register), `PTLR`(Page table length register)를 사용하여 구현한다.
- 이러한 구조 상에서 `page table`을 참조하기 위한 메인 메모리 접근, 데이터/명령어 전달을 위한 메인 메모리 접근이 각각 일어난다.
	- 두 번의 메인 메모리 참조는 많은 오버헤드이다. 따라서 `TLB(Translation Look-aside Buffer)`라는 하드웨어의 도움을 받아 `page table`을 구현한다.
- 아래 그림은 `TLB`가 포함된 `page table`을 활용한 메모리 활당 과정이다.![TLB](/image/OS/tlb.png)
	- `TLB` lookup에 사용되는 시간을 $\varepsilon$ 이라고 하자.
	- 메인 메모리 참조에 걸리는 시간은 1 time unit이라고 하자.
	- 이때 Hit ratio를 $\alpha$ 라고 하면 아래와 같이 Effective Access Time(EAT)을 구할 수 있다.
		- EAT = (1+$\varepsilon$)$\alpha$ + (2+$\varepsilon$)(1-$\alpha$) = 2 + $\varepsilon$ - $\alpha$
		- 위 공식을 이용하여 상황에 맞는 메모리 참조 시간을 구할 수 있다.

### Shared Code
- 아래 그림의 경우 프로세스 P1, P2, P3가 각각 ed1, ed2, ed3 페이지를 공유하는 상황이다. 이 경우 `physical memory`에 별도의 공간을 각각 확보하는 것은 낭비이다.![Shared Code](/image/OS/sharedCode.png)
	- 운영 체제는 이렇게 `page table`을 이용하여 메모리 할당 시 프로세스 간 `page`를 공유하는 기능을 제공한다.
	- 이러한 기능의 구현을 위해 아래 그림과 같은 `vaild-invalid bit`을 사용한다.![Valid - Invalid bit](/image/OS/validInvalid.png)

### Page Table - Hierarchical paging
> 지금까지 살펴본 page table의 구조는 single-level page table이다. 앞서 살펴본 것처럼 page table이 커지면 메인 메모리의 많은 부분이 page table에 할당되어 오버헤드가 발생한다. 이를 해결하기 위한 page table의 구조로 hierarchical paging, hashed page tables, inverted page tables가 있다. 본 절에서는 이 중 hierarchical paging에 대해서 다룬다.
- `page table`을 다단계로 나눈 구조이다.![Hierarchical paging](/image/OS/hierarchical.png)
	- `outer page table`을 이용하여`page table`을 non-continuous하게 할당할 수 있다.
	- 실제로 모든 `page table`을 사용하게 된다면 `outer page table`이 추가로 메인 메모리에 올라가므로 손해일 수 있다.
	- 하지만 대부분의 경우 `page table`의 모든 공간을 사용하지 않는 경우가 더 많다.
	- 또한 `page table`자체의 크기가 일반적으로 너무 커서 이것이 메인 메모리에 전부 올라가는 것 자체가 굉장한 오버헤드이다.
	- Hierarchical paging에서는  `outer page table`을 이용하여 메인 메모리에 올라가는 `page table`의 크기를 유동적으로 설정하는 구조를 채택했다.
	- 아래는 32bit machine에서 page size가 4K일때 2-level page table의 scheme이다.![Two Level Scheme](/image/OS/twoScheme.png)
- 2-level뿐만 아니라 3-level로 hierarchical page table을 구성하기도 한다.
- 하지만 64비트 machine에서는 hierarchical page table방식으로도 너무 큰 `page table`을 가진다.
	- 64비트 machine에서는 `page size`가 3G라고 해도 이미 `page table`의 크기가 4G이다.
	- hierarchical paging은 32비트 machine을 대상으로 한 설계에 사용된다.

### Page Table - Hashed Page Table
- `virtual page number`가 해시 함수를 통해 `page frame`으로 hashed된다.
- 해시 함수는 고정 길이를 가지기 때문에 `page`의 크기가 작아져도 table의 크기는 일정하다.
- 같은 해시 값을 가질 경우 linked list를 통해 element를 보관한다.
	- linked list에 저장되는 값은 `virtual page number`, `frame number`, `next pointer`가 있다.
- 해시 값의 linked list를 탐색하여 `virtual page number`와 일치되는 값일 경우 해당되는 `physical frame`이 추출된다.
- 결과적으로 테이블의 크기가 커지는 것을 해시 함수와 리스트(linked list)를 이용하여 해결했다.
- 아래는 `hashed page table`을 그림으로 나타낸 것이다.![Hashed Page Table](/image/OS/hashPaging.png)

### Page Table - Inverted Page Table
- **One entry for each frame(real page of memory)**
- 이전까지 다룬 구조에서는 프로세스 별 `page`를 `logical address`로 매핑했다.
- `Inverted Page Table`은 `page table`이 `physical memory`와 같은 크기를 가지며, `logical address`를 생성할 때 PID값을 고려하여 생성한다.
- 일반적으로 `logical address`는 무제한이며, 실제 `physical memory`보다 큰 `logical address`공간을 사용한다.
- `Inverted Page Table`구조는 충분한 `physical memory`가 확보된 경우 사용할 수 있는 구조이다. 
- `logical memory address`를 해석하는 작업이 없으므로 search time이 비약적으로 상승한다는 장점이 있다.
- 아래는 `Inverted Page Table`의 구조이다.![Inverted Page Table](/image/OS/invertedPaging.png)

## Memory Allocation Schemes - Segmentation
---
- user view 에서의 memory management이다.
- `page`는 system view에서 memory를 `fixed size`로 관리했다.
- 사실상 `page`가 아닌 사용자에게 익숙한 자료 구조(procedure, function, method, ...)단위로 메모리를 할당한다는 점 이외에 `Page`를 기반으로 메모리 할당을 하는 방식과 차이가 없다.
	- `PTBR`, `PTLR`대신에 `STBR`, `STLR`을 사용하여 base, limit값을 설정한다.
	- 이름만 다를 뿐 같은 역할을 하는 레지스터들이다.
- 아래는 Segmentation을 통한 메모리 할당 도식이다.![Segment](/image/OS/segment.png)
