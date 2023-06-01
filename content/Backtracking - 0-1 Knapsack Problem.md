+++
title = "Backtracking - 0-1 Knapsack Problem"
date = 2023-05-03
[taxonomies]
tags = ["Computer Algorithm"]
[extra]
author = "JS970"
katex= true
+++
## Backtracking - 0-1 Knapsack Problem
---
> 0-1 Knapsack problem에 대해서는 [Greedy Algorithm](https://js970.github.io/greedy-algorithm/)에서 다루었다. 본 단에서는  Backtracking 알고리즘을 사용하여 0-1 Knapsack problem을 해결하는 방법에 대해 다룬다.

### Promising Function
- `profit` : 현재 노드까지 가방에 넣은 보석을 판 값의 합
- `weight` : 현재 노드까지 가방에 넣은 보석의 무게 합
- `total_weight` : `weight` + 무게를 초과하지 않는 선에서 앞으로 담을 수 있는 보석의 무게 합
- `bound` : `profit` + 무게를 초과하지 않는 선에서 앞으로 담을 수 있는 보석을 판 값의 합 + 담을 수 없는 보석의 weight 당 profit을 계산하여 무게를 초과하지 않는 선에서 이를 추가한 값.
	- 애초에 0-1 Knapsack problem에서 보석을 쪼개는 행위는 허용되지 않지만, 보석을 쪼갤 수 있다고 가정하고 획득 가능한 최대 `profit`상한을 계산한 것이 `bound`이다.
- 아래 의사 코드는 위의 조건을 고려하여 작성한 promising function이다.
	```C++
	bool promising(index i) {
		index j, k;
		int totweight;
		float bound;

		if(weight > W) return false;
		else {
			j = i + 1;
			bound = profit;
			totweight = weight;
			while(j <= n && totweight + w[j] < W){
				totweight += w[j];
				bound += p[j];
				j++;
			}
			k = j;
			if(k <= n) bound += (W - totweight) * p[k] / w[k];
			return bound > maxprofit;
		}
	}
	```

### State Space Tree


### Solution


### Code
```C++
// TODO 2023-05-31
```