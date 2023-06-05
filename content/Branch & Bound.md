+++
title = "Branch & Bound"
date = 2023-06-04
[taxonomies]
tags = ["Computer Algorithm"]
[extra]
author = "JS970"
katex= true
+++
# Flow
- Branch & Bound
- Branch & Bound - 0-1 Knapsack Problem

## Branch & Bound
---
### Backtracking vs Branch & Bound
- Backtracking
	- 노드를 추가한 뒤 `non-promising`임이 확인되면 Backtracking을 수행한다.
	- preorder traversal을 이용한다.
	- 최적화 문제와 비 최적화 문제 모두에 사용된다.
- Branch & Bound
	- 노드에서 더 이상 최적해를 찾을 가능성이 없다면 분기를 수행하지 않는다.
	- 노드에서는 Bound값을 계산해서 노드가 promising인지 아닌지를 판단한다. 
		- promising한 경우 해당 노드의 child노드를 방문한다.
	- Bound값이란 노드를 확장하여 얻을 수 있는 value의 범위를 뜻한다.
	- 트리 순회 방식에 제약받지 않는다.
	- 최적화 문제에만 사용된다.

### Branch & Bound with Best-First Search
- 본 포스트의 **Branch & Bound - 0-1 Knapsack problem**에서 확인 가능하지만, 단순히 Branch & Bound기법을 적용하는 것 만으로는 Backtracking과 비교하여 이점이 없다.
- 이는 BFS Pruning, DFS Pruning모두 트리의 노드를 정해진 순회 순서에 따라 차례대로 탐색하기 때문이다.
- DFS와 달리, BFS에서는 child를 가지는 같은 계층의 노드에 대한 Bound값을 비교하는 것이 가능하다. 이를 활용하여 Branch & Bound의 성능을 향상시킬 수 있다.
- 같은 레벨의 노드의 Bound를 비교하여, 높은 Bound를 가지는 노드의 자식 노드를 먼저 탐색하는 것이 `Best-First Search`이다.

### (DFS + Pruning) vs (BFS + Pruning) vs (Best-First Search + Pruning)
- DFS + Pruning
	- Backtracking 기법이다.
	- `stack`을 사용하여 모든 노드를 DFS를 통해 순회한다.
	- 이 과정에서 `promising`함수를 사용하여 더 이상 진행 불가능한 노드에서는 Backtracking 한다.
- BFS + Pruning
	- Branch & Bound 기법이다.
	- `queue`를 사용하여 모든 노드를 BFS(Breadth First Search)를 통해 순회한다.
	- `promising`함수에서 bound값을 비교하여 자식 노드 방문 여부를 판단한다. 
		- bound값을 비교했을 때 방문이 필요 없다고 판단되면 해당 노드의 자식 노드는 방문하지 않는다.
- Best-First Search + Pruning
	- 향상된 Branch & Bound 기법이다.
	- `priority_queue`를 사용하여 같은 레벨 상에서 높은 Bound값을 가지는 노드의 자식을 먼저 탐색한다.
	- 정해진 순서에 따라 노드를 방문하는 것이 아닌, 유망성을 기준으로 높은 유망성을 가지는 노드를 먼저 방문하기 때문에 BFS + Pruning방식에 비해 방문해야 할 노드가 적다.


## Branch & Bound - 0-1 Knapsack Problem
---
### Space State Tree(Breadth-First Search Pruning)
![0-1 Knapsack Problem BFS](/image/Algorithm/knapsackBFS.png)
- BFS를 이용하여 Space State Tree를 Pruning한다.
- 1번 노드에서 `price`의 최댓값이 40으로 갱신되었으므로 2번 노드의 child를 방문한다.
	- DFS를 이용한 Backtracking방법에서는 2번 노드의 child를 탐색하지 않았다.
	- 방문하는 이유는 2번 노드의 promising이 82\$이기 때문이다.
- 3번 노드에서 다시 `price`의 최댓값이 70으로 갱신된다. 따라서 6번 노드의 child는 방문하지 않는다.
	- 6번 노드의 promising이 60\$이기 때문이다.
- 이런 방식으로 탐색을 하면 총 16회의 탐색 끝에 본 0-1 Knapsack Problem의 최적해를 구할 수 있다.
- [0-1 Knapsack Backtracking Solution](https://js970.github.io/backtracking-0-1-knapsack-problem/)에서 확인할 수 있지만, Backtracking을 사용한 경우 12회의 탐색으로 최적해를 구했다, Branch & Bound방법을 사용했을 때 오히려 탐색 시간은 더 오래 걸렸다.

### Space State Tree(Best-First Search Pruning)
![Best-First Search Branch & Bound 0-1 Knapsack](/image/Algorithm/knapsackBestFirstSearch.png)
- Best - First Search를 이용하여 Space State Tree를 Pruning한다.
- 1번 노드의 `bound`가 115\$이므로, 1번 노드의 child부터 탐색한다.
- 3번 노드의 `bound`는 115\$, 4번 노드의 `bound`는 98\$이므로, 3번 노드의 child를 먼저 탐색한다.
- 5번 노드는 `non-promising`이고, 6번 노드가 최대 이익을 가지는 노드로 설정된다. 한편 이때의 `bound`는 80\$ 이므로 4번 노드의 child를 탐색한다.
- 7번 노드에서 최대 이익 노드가 6번 노드로 갱신된다. 이때의 `bound`는 98\$로, Space State Tree에서 이보다 높은 `bound`를 가지는 노드가 존재하지 않으므로 탐색이 종료된다.

### Code
```C++
// TODO 2023-06-05
```