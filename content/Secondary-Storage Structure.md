+++
title = "Secondary-Storage Structure"
date = 2023-06-12
[taxonomies]
tags = ["Operating System"]
[extra]
author = "JS970"
katex= true
+++
## Overview of Mass Storage Structure
---
> 많은 Secondary Storage가 존재하지만 본 절에서는 HDD등 Magnetic disk에 대해서 다룬다.
- 아래는 기본적인 하드디스크의 구조이다.![HDD](/image/OS/hdd.png)
- I/O에 소요되는 시간은 아래와 같이 나타낼 수 있다.$$T_{I/O} = T_{seek} + T_{rotation} + T_{transfer}$$
	- I/O 소요시간 = 탐색시간 + 회전시간 + 전송시간
- 이 중에서 운영 체제 범위에서 줄일 수 있는 것은 탐색시간 밖에 없다.
	- 회전시간은 HDD의 영역이고, 전송시간은 하드웨어 버스에 의해 결정된다.
	- 탐색시간은 `Disk Scheduling`을 통해 줄일 수 있다.
- 전송률을 식으로 나타내면 아래와 같다.$$R_{I/O} = \frac{Size_{transfer}}{T_{I/O}}$$

## Disk Scheduling
---
- 디스크 암을 움직여 데이터에 접근하는 과정에는 많은 지연시간이 있다.
- 운영 체제는 `Disk Scheduling`을 통해 Seek Time을 최소화 하는 것이 목적이다.
- 회전 속도, 버스의 대역폭에 대해서는 고려하지 않는다.
- 아래는 `Disk Scheduling`알고리즘이 고려해야 할 사항이다.
	- 주어진 I/O request를 어떠한 순서로 처리할 것인가?
	- Scheduling을 통해 순서만 바뀔 뿐 요청된 동작은 모두 수행되어야 한다.
	- ~~일반적이지는 않지만, 오히려 일을 하지 않는 것이 더 도움이 될때도 있다.~~
- `Disk Scheduling Algorithm`으로는 아래와 같은 것들이 있다.
	- FCFS
	- SSTF
	- SCAN
	- C-SCAN
	- C-Look
- 경우에 따라 적절한 `Disk Scheduling Algorithm`을 선택하는 것이 중요하다. 
- 결국 request에 의해 성능은 변하기 때문에 정답은 없다.
- 일반적으로 SSTF, Look방식이 Best Effort로 가장 많이 사용된다.
- 또한, 최근에는 마이크로커널을 지향하기 때문에 본 포스트에서 다루는 내용은 최신 운영체제에는 포함되지 않을 수 있다. 본 포스트의 기능은 보통은 하드웨어 레벨에서 별도의 기능으로 구현된다.

### FCFS
- First Come First Serve(== do nothing)
- 로드가 적을 때는 그나마 낫다
- 하지만 로드가 많을 경우 효율이 좋지 않다.
- 아래는 주어진 request에 따른 처리 과정이다.![FCFS](/image/OS/diskFCFS.png)
	- 53번 실린더에서 탐색을 시작하며 총 이동 거리는 640실린더를 이동해야 한다.
	- 위 그래프에서 가로로 중복되는 부분들은 전부 의미 없는 이동이라고 봐야 한다.

### SSTF
- Shortest-Seek-Time-First
- 현재 실린더 위치에서 가장 가까운 실린더의 request를 처리한다.
- `starvation`을 야기할 수 있다.
- 아래는 주어진 request에 따른 처리 과정이다.![SSTF](/image/OS/SSTF.png)
	- 53번 실린더에서 탐색을 시작하며 총 이동 거리는 236실린더를 이동해야 한다.
	- FCFS방식에 비해 가로로 중복되는 부분이 많이 줄었다.
	- 경계값에 대한 의미 없는 탐색을 하지 않는다.

### SCAN
- 디스크 암이 실린더의 시작부터 끝까지 이동하면서 그 사이의 request를 처리한다.
- elevator algorithm이라고 부르기도 한다.
- 아래는 주어진 request에 따른 처리 과정이다.![SCAN](/image/OS/SCAN.png)
	- 53번 실린더에서 시작하여 총 236실린더를 이동한다.
	- 경계값에 대한 무의미한 탐색이 있다.
	- request마다 처리되는 데 걸리는 시간이 다르며 이를 예측하기 힘들다.

### C-SCAN
- Circular SCAN방식이다.
- 0번부터 199번 실린더 까지 탐색을 마친 뒤 바로 되돌아 가는 것이 아닌 다시 0번부터 199번으로 탐색을 한다.
- 속도는 SCAN에 비해 느리지만 request 응답 지연을 예측할 수 있다는 장점이 있다.
- 하지만 여전히 경계값에 대한 의미 없는 탐색을 수행한다.
- 아래는 주어진 request에 따른 처리 과정이다.![C-SCAN](/image/OS/CSCAN.png)

### Look/C-Look
- SCAN방식과 SSTF방식의 장점을 합친 것이다.
- SCAN방식과 달리 request 대상 실린더의 경계값에 대해서만 순회한다.
	- SSTF방식과 마찬가지로 경계값에 대한 의미 없는 탐색을 하지 않는다.
- 아래는 주어진 request에 대해 C-Look으로 `disk scheduling`을 수행한 것이다.![C-Look](/image/OS/CLOOK.png)


