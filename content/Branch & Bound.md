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

## Branch & Bound - 0-1 Knapsack Problem
---
### Space State Tree
![0-1 Knapsack Problem BFS](/image/Algorithm/knapsackBFS.png)
- BFS를 이용하여 Space State Tree를 Pruning한다.
- 1번 노드에서 `price`의 최댓값이 40으로 갱신되었으므로 2번 노드의 child를 방문한다.
	- DFS를 이용한 Backtracking방법에서는 2번 노드의 child를 탐색하지 않았다.
	- 방문하는 이유는 2번 노드의 promising이 82\$이기 때문이다.
- 3번 노드에서 다시 `price`의 최댓값이 70으로 갱신된다. 따라서 6번 노드의 child는 방문하지 않는다.
	- 6번 노드의 promising이 60\$이기 때문이다.
- 이런 방식으로 탐색을 하면 총 16회의 탐색 끝에 본 0-1 Knapsack Problem의 최적해를 구할 수 있다.
- [0-1 Knapsack Backtracking Solution](https://js970.github.io/backtracking-0-1-knapsack-problem/)에서 확인할 수 있지만, Backtracking을 사용한 경우 12회의 탐색으로, Branch & Bound방법을 사용했을 때 오히려 탐색 시간은 더 오래 걸렸다.