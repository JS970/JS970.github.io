+++
title = "Memory Management(1)"
date = 2023-05-11
[taxonomies]
tags = ["Operating System"]
[extra]
author = "JS970"
katex= true
+++
> Synchronization, Deadlock 에서는 프로세스의 자원 공유에 관해 다뤘다면, 이번 글에서는 메모리 공유에 대해 다룬다. 
## Memory Management Backgrounds
---
### Address Space
- 운영 체제가 생성하는 physical memory의 추상체가 `Address Space`이다.
- `Program Code`, `Heap`,` Stack`영역으로 구분된다.                                                  ![Address Space](/image/OS/addressSpace.png)
	- `Program Code` : 명령어들이 위치하는 공간
	- `Heap` : 동적 할당 메모리, C언어에서의 `malloc`, Java계열에서의 `new`로 할당되는 공간
	- `Stack` : `return address`, `value`등이 위치하는 공간. 
		- `value`에는 `local variable`, `arguments`가 있다.
- `Address Space`는 `Address Translation Mechanism`을 통해 physical memory로 할당된다.![Address Translation Mechanism](/image/OS/ATM.png)

### Memory Virtualization
- Virtual Address
	- 모든 실행 중인 프로그램의 주소는 `virtual`이다.
	- 운영 체제(CPU)는 `virtual address`를 `physical address`로 변환하는 동작을 한다.
	- `virtual address`는 `logical address`라고도 하며, `physical address`로 bound된다.
	- `virtual address`와 `physical address`는 컴파일 타임및 load-time에는 같은 의미를 지닌다.
	- 프로그램 실행 시 `virtual address`와 `physical address`의 binding이 일어난다.
		- 당연히 프로그램 실행 시에는 두 주소값의 차이가 있다.
- Memory Virtualization
	- 운영 체제는 각각의 프로세스마다 가상 메모리 공간을 부여한다.
	- 이를 통해 각각의 프로세스는 메모리 공간 전체를 사용하는 것처럼 보인다.
- Memory Virtualization을 통해 `Transparency`, ``Efficiency``, `Protection`을 기대할 수 있다.
	- `Transparency` : 프로세스는 메모리가 공유되고 있다는 사실을 고려하지 않는다.
	- `Efficiency` : 단편화(fragmentation) 문제를 최소화 할 수 있다.
	- `Protection` : 다른 프로세스 및 OS가 메모리 공간을 침범하는 것을 방지한다. 마찬가지로, 프로세스가 다른 프로세스에 영향을 미치며 종료되지 않도록 한다. 협력 프로세스의 경우에는 일부 메모리를 공유할 수 있다.

### Static Relocation
- Software-based relocation이다.
- context switching에 의해 프로그램이 binding되는 `physical address`의 주소가 바뀔 수 있다.
- 이때 Memory Space를 통재로 다른 `physical address`에 relocate하는 것이 `static relocation`이다.
- 하드웨어의 지원이 없어도 된다는 장점이 있다.
- 하지만 아래와 같은 단점이 존재한다.
	- 의도치 않게 다른 프로세스의 메모리를 읽을 수 있다.
	- OS를 포함한 다른 메모리 영역을 침범할 수 있다.
	- External Fragmentation(외부 단편화)이 발생하여 메모리가 낭비될 수 있다.

### Dynamic Relocation
- Hardware-based relocation이다.
- `MMU(Memory Management Unit)`가 모든 메모리 참조 명령어에 대해 address translation을 수행한다.
- 하드웨어에 의해 `protection`이 강제된다.
	- 만약 `virtual address`가 유효하지 않다면, `MMU`에서 예외 처리를 한다.
	- 이는 운영 체제가 `MMU`에 유효한 `virtual address`에 대한 정보를 넘겨주기 때문에 가능하다.
- `MMU`의 구조에 대해 간단히 살펴보자![MMU](/image/OS/MMU.png)
	- `reallocation register`는 `base register`라고도 한다.
	- 위 도식에서 확인할 수 있듯이, 유저 프로그램은 오직 `logical address`에 대해서만 관여하고, `physical address`에는 접근하지 않는다. 실제로 `physical address`에 대한 정보도 알 수 없다.
	- 이 모든 과정은 실행 시간(execution time)에 일어난다.
- `MMU`는 운영 체제에서 가장 중요한 역할 중 하나인 프로세스 보호(운영체제, user processes)를 수행한다.
	- 이를 수행하기 위해 `base register`와 `limit register`를 사용한다.
	- `base register`에는 프로세스 메모리의 시작 주소가 저장되어 있다.
	- `limit register`에는 프로세스 메모리의 크기가 저장된다.
	- 즉, `base register value` ~ `base register value + limit register value` 가 프로세스가 할당된 공간을 의미한다.
	- 위와 같은 레지스터를 활용하여 하드웨어 레벨에서 메모리에 할당된 각각의 프로세스가 서로의 영역을 침범하지 않게 한다.![Base and Limit Register](/image/OS/baseAndLimit.png)
		- 위 그림에서 `bound register`는 `limit register`를 의미한다.

### OS Issues for Memory Virtualizing
- 운영 체제는 `base-and-bound`접근을 구현하도록 동작해야 한다.
	- `bound register`와 `limit register`를 사용하는 접근을 의미한다.
- 구체적으로는 아래와 같은 동작을 수행해야 한다.
	1. 프로세스가 실행될 때 `physical memory`의 Free Space를 찾아야 한다.
		- 사용중이지 않은 `physical memory`공간을 저장하는 `free list`를 이용한다.
	2. 프로세스가 종료될 때 `physical memory`에 대한 해제가 필요하다.
		- `free list`에 사용했던 메모리 공간을 추가해야 한다.
	3. context-switch가 일어날 때 `base-bound pair`를 저장해야 한다.
		- `PCB(process control block)`에 해당 `base-bound pair`를 저장해야 한다.

### Dynamic Loading
- `Dynamic Loading`이란 호출될 때까지는 data를 loading하지 않고 있다가 호출 되면 load하는 것이다.
	- 메모리 공간의 utilization을 높일 수 있다.
	- 특히 대용량의 코드가 빈번하지 않게 처리될 경우에 유용하다.
	- 운영 체제의 지원이 필요 없다. 프로그램 디자인을 통해 구현 가능하다.
- `Dynamic Loading`에 의해 Linking역시 execution time 까지 연기된다. 
	- 이것을 `Dynamic linking`이라 한다.
	- `stub`코드를 사용하여 구현한다.
	- 특히 라이브러리를 사용할 때 유용하다.
	- 이러한 라이브러리의 사용을 공유 라이브러리(`shared libraries`)라고 한다.

### Swapping
- `Swapping`이란 backing store(HDD, SSD)와 main memory간에 프로세스를 교체하는 것을 말한다.
	- main memory 에서 backing store로 가는 것을 `swap out`이라고 한다.
	- backing store에서 main memory로 오는 것을 `swap in`이라고 한다.
	- `swap in`을 통해 프로세스는 연속적으로 실행될 수 있다.
- `Swaping`의 핵심은 전송 시간이다.
	- backing store의 write/read속도가 매우 느리기 때문에 `swap`되는 정보량에 따라 전송 시간이 차이난다.
	- 결국 `swap`을 최소화 하는 것이 핵심이다.
- `Swapping`의 특징으로는 아래와 같은 것들이 있다.
	- 운영 체제의 지원이 필요 없다.
	- 프로그래머가 직접 코드나 데이터를 필요에 의해 옮기는 것이 가능하다.
- `Swapping`은 `process level swapping`과 `page level swapping`이 있다.
	- `process level swapping`에서는 프로세스가 main memory와 backing store간에 `swapping`된다.
	- `page level swapping`에서는 `page`단위로 `swapping`된다.
- `process level swapping`은 전체 프로세스가 `swapping`되므로 시간이 많이 소모된다.
- `page level swapping`은 `swapping`에 대한 예측이 가능하다는 장점이 있다.