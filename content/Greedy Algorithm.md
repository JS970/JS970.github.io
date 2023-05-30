+++
title = "Greedy Algorithm"
date = 2023-04-24
[taxonomies]
tags = ["Computer Algorithm"]
[extra]
author = "JS970"
katex= true
+++
## Greedy Algorithm
---
- Greedy Algorithm은 "순간순간 선택의 시점마다 항상 그 상황에서 최선인 선택을 하는" 알고리즘이다.
- 아래는 Greedy Algorithm의 예시이다.
	>10원, 50원, 100원, 500원 동전이 무한 개 있다. 코인의 개수를 가장 적게 선택하여 730원을 지불하려면 어떻게 해야 하는가?
- 이를 해결하기 위해서는 동전의 선택 시점마다 항상 선택 가능한 동전 중 금액이 가장 큰 동전을 선택하면 된다.

### Greedy Algorithm vs Dynamic Programming
- 두 알고리즘 모두 최적화 문제를 풀기 위해 사용된다.
- Greedy Algorithm의 경우 한번 선택된 사항에 대해 재고하지 않는다.
- Greedy Algorithm의 선택은 이전 선택이나 이후 선택에 영향을 받지 않는다.
- Greedy Algorithm의 경우 Locally Optimal하다.
	- 따라서 Locally Optimal함이 반드시 증명되어야 한다.

### Greedy Approach
1. Selection procedure : 현재 상태에서 최선의 해답을 선택한다.
2. Feasibility Check : 선택된 해가 문제의 조건을 만족하는지 확인한다.
3. Solution Check : 원래 문제가 해결되었는지 검사하고, 해결되지 않았다면 1~3을 반복한다.

## Spanning Tree(신장 트리)
---
- G = (V, E)인 undirected weighted graph이다.
- V = {v1, v2, v3, v4, v5}
- E = {(v1, v2), (v1, v3), (v2, v4), (v3, v4), (v3, v5), (v4, v5)}
- W : 각 edge의 weight값
- Spanning Tree는 Graph G의 모든 Vertices를 포함하는 Subgraph이다.

### Minimum Spanning Tree
- G = (V, E), T = (V, F)인 undirected graph G, T가 있다. 이때  F가 E의 부분집합일 때 F의 weight 값의 합이 최솟값을 가지는 spanning tree를 Minimum Spanning Tree라고 한다.
- G에 대한 MST를 찾는 데 Greedy Algorithm이 이용된다. 대표적으로 아래와 같은 알고리즘이 있다.
	- Prim Algorithm
	- Kruskal Algorithm
	- Dijkstra Algorithm

## 0-1 Knapsack Problem
---
> 도둑이 보석 가게에 가방을 들고 물건을 훔치러 침입했다. 각각의 보석은 무게와 가격을 가지며, 가방은 최대 용량 W를 초과하면 터진다. 도둑이 가방의 최대 용량을 초과하지 않으면서 최대한 많은 보석을 훔쳐가려면 어떻게 해야 하는가?

### Brute Fore Solution
- 총 n개의 보석 집합의 부분집합의 개수는 2^n개이다.
- 모든 부분집합에 대해 가방의 용량 W를 초과하지 않으면서, 최대한 큰 가격을 가지는 보석의 부분집합을 선택한다.
- 시간복잡도가 exponential이므로 해결 불가능하다.

### Greedy Solution
- 가격 / 무게 연산을 통해 profit을 계산한다.
- 보석을 profit순서대로 내림차순 정렬한다.
- 무게를 초과하지 않을 때까지 profit이 큰 보석부터 가방에 담는다.
- 하지만 이 알고리즘은 optimal하지 않다.![Not Optimal Greedy Solution](/image/Algorithm/greedy_notopt.png)
- 0-1 Knapsack문제에 있어서 exponential보다 나은 시간복잡도를 가지는 해결법은 발견되지 않았다.
- 그렇다고 해서 exponential보다 나은 시간복잡도를 가지는 것이 불가능하다고 증명되지도 않았다.
- 하지만 greedy algorithm은 이 문제의 적절한 해결책이 아니다.