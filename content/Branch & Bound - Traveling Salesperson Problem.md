+++
title = "Branch & Bound - Traveling Salesperson Problem"
date = 2023-06-04
[taxonomies]
tags = ["Computer Algorithm"]
[extra]
author = "JS970"
katex= true
+++
## Branch & Bound - Traveling Salesperson Problem
---
- 아래의 조건을 만족하면서 총 이동 거리가 최소가 되는 최적 경로를 찾는 문제이다.
	- 주어진 city(노드)에서 출발한다.
	- 모든 city(노드)를 정확히 한 번씩 방문한다.
	- 다시 처음 시작한 city(노드)로 돌아온다.

### Bound 및 문제 해결 전략
> 수업시간에 다룬 Bound방법에 대해서는 제대로 이해를 못해서 인터넷에서 따로 찾았다.
- 노드에서 가장 weight가 작은 edge를 두 개 선택하여 경로가 가질 수 있는 최저 거리인 minimum bound를 산정한다.
- 이렇게 각 노드 별로 기대 가능한 최소 거리를 가지는 경로의 minimum bound를 계산한다.
- 경로 구성 중 cycle을 형성하거나, 시작 지점으로 되돌아가지 못하는 경우 `non-promising`이다.
- 현재 탐색된 경로의 이동거리보다 bound가 클 경우 해당 노드는 `non-promising`이다.
- 시작 노드에서부터 BFS Bound값을 이용한 Best First Search를 통해 최소 경로를 찾는다.

### Reference
- [Traveling Salesman Problem using Branch And Bound](https://www.geeksforgeeks.org/traveling-salesman-problem-using-branch-and-bound-2/)
- [Example of calculate Bound](https://gtl.csa.iisc.ac.in/dsa/node187.html)
