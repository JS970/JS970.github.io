+++
title = "Routing"
date = 2022-11-10
[taxonomies]
tags = ["Computer Network"]
[extra]
author = "JS970"
+++

## Forwarding table and Routing table

![Untitled](Routing%20e2f6f3a77f834c93af44556d5ac0b672/Untitled.png)

### Forwarding table

- 패킷을 포워딩하는데 사용된다.
- 포워딩 기능을 수행하기에 적합한 정보를 포함해야 한다.
- Network Number에 대응하는 outgoing interfafce로의 매핑
- 다음 hop으로의 전송을 위한 MAC address

### Routing table

- 라우팅 테이블은 라우팅 알고리즘에 의해 사전에 구축된 테이블이다.
- Network Number와 Next hop을 매핑한다.

## Distance vector and Link State Routing Protocols

- 패킷은 라우터에 의해 포워딩되어야 한다.
- 링크를 구성하는 경로에 대한 정보를 알아야 포워딩이 가능하다.
- 어떻게 이 “topology”에 대한 정보를 얻을 수 있을까?

### Distance vector

- 각 노드는 모든 노드로 인접 노드의 정보를 전송한다.
- 각 노드는 다른 모든 노드에 대한 “거리”(비용)를 포함하는 1차원 배열을 구성한다.
- 해당 벡터를 인접한 노드에 분배한다.
- RIP(Routing Information Protocol) 프로토콜을 사용하여 정보를 전송한다.
- Bellman-Ford알고리즘을 이용한다.
- BGP(Border Gateway Protocol, CISCO), EGP(Exterior Gateway Protocol)에서 이러한 방법을 사용한다.

![Untitled](Routing%20e2f6f3a77f834c93af44556d5ac0b672/Untitled%201.png)

### Distance Vector Example

![Untitled](Routing%20e2f6f3a77f834c93af44556d5ac0b672/Untitled%202.png)

- 패킷을 교환하기 전 A노드에서 다른 노드로의 distance는 $\infty$로 초기화된다.
- 인접 노드 간의 패킷 교환을 통해 점진적으로 B, C, D, E로의 distance가 구해진다.
- 위 상황에서 A노드 기준으로 총 4번의 패킷 교환이 이루어지면 E노드에 대한 올바른 정보를 얻을 수 있다.

![Untitled](Routing%20e2f6f3a77f834c93af44556d5ac0b672/Untitled%203.png)

- A노드와 B노드 사이의 경로가 끊겼다면 위 그림과 같이 순차적인 패킷 전송에 의해 매우 느린 속도로 A 노드에서 각 노드로의 거리가 $\infty$로 갱신될 것이다.

### Link State Routing

- 각 노드는 모든 노드로 모든 노드의 정보를 전송한다.(Broadcasting, 많은 비용 소모)
- 모든 라우터는 아래와 같은 동작을 한다.
    1. 인접 노드를 발견하고 해당 노드의 네트워크 주소를 알아낸다.
    2. 인접 노드로의 delay(cost)를 측정한다.
    3. 인접 노드의 정보를 알아냈다는 패킷을 생성한다.
    4. 다른 모든 라우터로 해당 패킷을 전송한다.
    5. 다른 모든 라우터로의 최단 경로를 계산한다.
- 결과적으로 topology 와 delay가 실험적으로 측정되며, 이를 다른 라우터에 분배하여 공유한다.
- 이후 Dijkstra알고리즘을 이용하여 다른 모든 라우터로의 최단 경로를 알아낼 수 있다.
- OSPF(Open Shortest Path First)에서 이러한 방법을 사용한다.

![Untitled](Routing%20e2f6f3a77f834c93af44556d5ac0b672/Untitled%204.png)

## Reference

[[CCIE] 라우팅 프로토콜의 분류: Distance Vector Routing vs. Link State Routing](https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=nackji80&logNo=221431942767)