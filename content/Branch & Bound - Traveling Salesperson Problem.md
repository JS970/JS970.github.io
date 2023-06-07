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
	- 주어진 city에서 출발한다.
	- 모든 city를 정확히 한 번씩 방문한다.
	- 다시 처음 시작한 city로 돌아온다.

### Bound
> 이 부분은 교수님께 질문드려 보자..
- 수업시간에 배운 bound계산은 [인터넷에서 찾아지는 bound계산법](https://www.geeksforgeeks.org/traveling-salesman-problem-using-branch-and-bound-2/)과는 차이가 있는 것 같다.
- [bound 계산 예시](https://gtl.csa.iisc.ac.in/dsa/node187.html)
