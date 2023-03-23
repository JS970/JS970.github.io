+++
title = "Nachos 실습 - 1"
date = 2023-03-23
[taxonomies]
tags = ["Operating System"]
[extra]
author = "JS970"
katex= true
+++
## proj 1
KThread.java의 389행의 run함수를 고쳐서 각 Thread가 10번 실행되도록 할 수 있다.
```java
public void run() {
	for (int i=0; i<10; i++) {
		System.out.println("*** thread " + which + " looped "
		+ i + " times");
		currentThread.yield();
	}
}
```
