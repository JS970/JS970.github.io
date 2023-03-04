+++
title = "15829 - Hashing"
date = 2023-02-11
[taxonomies]
tags = ["baekjoon"]
[extra]
author = "JS970"
+++

- 난이도: 브론즈 2
- 날짜: 2023년 2월 11일
- 상태: Correct
- 추가 검토 여부: No
- 알고리즘 : 정수의 성질

# solution

- 얼핏 생각하면 난감하지만 mod연산의 특징을 이해한다면 쉽게 풀 수 있다.
- mod 1234567891 공간에서 값을 가지기 때문에 31의 50승이라는 말도 안 되는 수임에도 불구하고 연산 과정마다 mod연산을 통해 hash값을 구할 수 있다.
- 각각 따로 mod한 값을 이후에 더한 후 mod해도 다 더해서 mod한 값과 같다.

# code

```cpp
#include <iostream>
using namespace std;

long long int pow(int exp, long long int n)
{
    for(int i = 0; i < exp; i++)
    {   
        n %= 1234567891;
        n *= 31;
    }

    return n;
}

long long int myhash(string str)
{
    long long int n;
    long long int ret = 0;
    for(int i = 0; i < str.length(); i++)
    {
        n = str[i] - 'a' + 1;
        ret += pow(i, n);
        ret %= 1234567891;
    }

    return ret;
}

int main()
{
    int L;
    cin >> L;
    string input;
    cin >> input;
    myhash(input);
    cout << myhash(input) << endl;

    return 0;
}
```

# ref

[15829번: Hashing](https://www.acmicpc.net/problem/15829)