+++
title = "1260 - DFS와 BFS"
date = 2023-02-23
[taxonomies]
tags = ["baekjoon", "BFS", "DFS", "Graph"]
[extra]
author = "JS970"
+++

- 난이도: 실버 2
- 날짜: 2023년 2월 23일
- 상태: Correct/Retry
- 추가 검토 여부: Yes

# solution

- DFS와 BFS를 조건에 맞게 구현하기만 하면 되는 문제이다.
- DFS, BFS의 개념은 자료 구조 수업에서 배웠다고 생각했지만 막상 구현하려고 하니 어려움이 많았다.
- 결국 구현의 핵심은 adjacency list와 visited list의 사용이었다.
- 각 블로그 및 교재를 참조하였으나 잘 이해가 되지 않아서… chat GPT에게 코드를 요청했고 그 코드를 바탕으로 학습하였다.
- 아래는 DFS와 BFS의 chat GPT코드의 개념이다.
    - DFS
    
    ![DFS](/content/baekjoon/1260-img/DFS.png?raw=true)
    
    - 인접 리스트의 첫 번째 원소부터 접근하여 해당 노드가 visited == false인 경우 그 노드를 시작 노드로 가지는 DFS를 호출한다. 이러한 방식으로 첫 번째 호출된 DFS의 시작 노드에 대한 모든 adjacency list에 대한 탐색을 모두 마치면 함수가 종료된다.
    - BFS
    
    ![BFS](/content/baekjoon/1260-img/BFS.png?raw=true)
    
    - 앞선 DFS는 함수의 재귀 호출을 통해 구현했다면 BFS는 while loop과 queue를 통해 구현했다. start node에서 시작하여 한 번의 루프마다 queue에서 pop을 수행한다. queue에서 pop 된 후 pop된 노드에 대한 인접 리스트를 탐색한다. 인접 리스트의 원소가 visited == false인 경우 해당 노드를 queue에 push한다. 이런 방식으로 queue가 empty가 아니라면 계속해서 while문을 수행한다. queue를 통해 계층 별로 순서에 맞게 탐색하는 BFS를 구현할 수 있다.
- DFS, BFS와 별개로 본 문제에서 요구한 사항인 방문 가능한 노드가 다수 있을 경우 번호가 작은 노드를 먼저 방문해야 한다는 조건에 따라 adjacency list를 오름차순으로 정렬해 주어야 했다.
    - 이는 algorithm 헤더의 sort method를 이용하여 구현하였다.
    - 본 문제에서 노드 번호는 1부터 시작하는데 이를 간과한 채 sort함수를 실행하여 segmentation fault로 한번 오답을 제출했다. 범위를 바꿔 주니 정답을 출력했다.

# code

- chat GPT 코드 - give me c++ code implementing DFS and BFS algorithm
    
    ```cpp
    #include <iostream>
    #include <vector>
    #include <queue>
    #include <stack>
    
    using namespace std;
    
    // function to perform Depth First Search (DFS)
    void dfs(int node, vector<int> adj[], vector<bool>& visited) {
        visited[node] = true;
        cout << node << " ";
    
        for(int i = 0; i < adj[node].size(); i++) {
            int neighbor = adj[node][i];
            if(!visited[neighbor]) {
                dfs(neighbor, adj, visited);
            }
        }
    }
    
    // function to perform Breadth First Search (BFS)
    void bfs(int start, vector<int> adj[], vector<bool>& visited) {
        queue<int> q;
        visited[start] = true;
        q.push(start);
    
        while(!q.empty()) {
            int node = q.front();
            q.pop();
            cout << node << " ";
    
            for(int i = 0; i < adj[node].size(); i++) {
                int neighbor = adj[node][i];
                if(!visited[neighbor]) {
                    visited[neighbor] = true;
                    q.push(neighbor);
                }
            }
        }
    }
    
    int main() {
        int n, m;
        cin >> n >> m; // n: number of nodes, m: number of edges
    
        vector<int> adj[n+1]; // adjacency list
    
        // build the graph
        for(int i = 0; i < m; i++) {
            int u, v;
            cin >> u >> v;
            adj[u].push_back(v);
            adj[v].push_back(u);
        }
    
        // initialize visited array
        vector<bool> visited(n+1, false);
    
        // perform DFS
        for(int i = 1; i <= n; i++) {
            if(!visited[i]) {
                dfs(i, adj, visited);
            }
        }
    
        // reset visited array
        visited.assign(n+1, false);
    
        // perform BFS
        for(int i = 1; i <= n; i++) {
            if(!visited[i]) {
                bfs(i, adj, visited);
            }
        }
    
        return 0;
    }
    ```
    
    - 놀랍게도…? syntax error가 있다(2023/02/23). 벡터 선언에 있어 lvalue 가지고 동적 할당이 아니라 바로 선언을 해버렸다. 아래의 제출 코드는 이 문법 문제를 동적 할당으로 바꾸어 해결했다.
- 제출 코드

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
using namespace std;

void dfs(int node, vector<int> adj[], vector<bool>& visited)
{
    visited[node] = true;
    cout << node << " ";

    for(int i = 0; i < adj[node].size(); i++)
    {
        int neighbor = adj[node][i];
        if(!visited[neighbor])
            dfs(neighbor, adj, visited);
    }
}

void bfs(int start, vector<int> adj[], vector<bool>& visited)
{
    queue<int> q;
    visited[start] = true;
    q.push(start);

    while(!q.empty())
    {
        int node = q.front();
        q.pop();
        cout << node << " ";

        for(int i = 0; i < adj[node].size(); i++)
        {
            int neighbor = adj[node][i];
            if(!visited[neighbor])
            {
                visited[neighbor] = true;
                q.push(neighbor);
            }
        }
    }
}

int main()
{
    int n, m, v;
    cin >> n >> m >> v;
    vector<int> * adj = new vector<int>[n+1];
    for(int i = 0; i < m; i++)
    {
        int u, v;
        cin >> u >> v;
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    for(int i = 1; i <= n; i++) sort(adj[i].begin(), adj[i].end());

    vector<bool> visited(n+1, false);
    dfs(v, adj, visited);
    cout << endl;

    visited.assign(n+1, false);
    bfs(v, adj, visited);

    return 0;
}
```

# ref

[1260번: DFS와 BFS](https://www.acmicpc.net/problem/1260)