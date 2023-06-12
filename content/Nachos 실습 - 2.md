+++
title = "Nachos(2)"
date = 2023-04-30
[taxonomies]
tags = ["Operating System"]
[extra]
author = "JS970"
katex= true
+++
# #1
## 코드
- selfTest2 메소드와 SimpleThread클래스를 아래와 같이 작성하여 Round-Robin 스케줄링을 구현할 수 있다.
### selfTest2()
```java
public static void selfTest2() {
	Lib.debug(dbgThread, "Enter KThread.selfTest2");

	int timeslice;
	int numberOfThreads;
	int burstTime1;
	int burstTime2;

	String fileName = "input";
	try {
		FileReader fileReader = new FileReader(fileName);
		BufferedReader bufferedReader = new BufferedReader(fileReader);

		String line = bufferedReader.readLine();
		timeslice = Integer.parseInt(line);

		line = bufferedReader.readLine();
		numberOfThreads = Integer.parseInt(line);

		line = bufferedReader.readLine();
		burstTime1 = Integer.parseInt(line);

		line = bufferedReader.readLine();
		burstTime2= Integer.parseInt(line);

		bufferedReader.close();

		new KThread(new SimpleThread(burstTime1, timeslice))
		.setName("forked thread 1").fork();
		new KThread(new SimpleThread(burstTime2, timeslice))
		.setName("forked thread 2").fork();
		new mainThread().run();
		yield();
	} catch (IOException e) {
		e.printStackTrace();
	}
}
```
- `input.txt`파일을 읽어서 timeslice, numberOfThread, burstTime1, burstTime2를 초기화한다.
- 초기화한 변수들을 바탕으로 KThread를 생성한다.

### SimpleThread
```java
private static class SimpleThread implements Runnable {
	SimpleThread(int burst_time, int timeslice) {
		this.burst_time = burst_time;
		this.timeslice = timeslice;
	}

	public void run() {
		int remaining_time = burst_time;
		long current_tick;
		while(remaining_time > 0) {
			while(timeslice > 0 && remaining_time > 0) {
				current_tick = Machine.timer().getTime();
				remaining_time--;
				timeslice--;
				System.out.println(current_tick 
				+ " running:" + currentThread.getName()
					+ ", remaining time: " + remaining_time);
				Machine.interrupt().tick(false);
			}
			currentThread.yield();
			timeslice = 2;
		}
	}
	private int burst_time;
	private int timeslice;
}
```
- selfTest2()에서 생성되는 KThread의 생성자 인수로 들어가는 SimpleThread class이다.
- SimpleThread역시 Runnable인터페이스를 구현했으므로 run()에 대한 정의가 필요하다.
- SimpleThread는 Round-Robin Scheduling으로 동작하는 Thread이다. timeslice 멤버 변수를 사용해서 두 틱동안 동작하고 yield()를 호출하여 다음 ready process로 resource를 넘긴다.
- 만약 timeslice안에 프로세스가 종료되었을 경우, 곧바로 다음 프로세스로 resource를 넘긴다.

## 실행 결과
![result01](/image/OS/proj2-1_result.png)

# #2
- PriorityScheduler는 Scheduler 추상 클래스를 상속하여 만들어진다.
- PriorityScheduler를 구현하기에 앞서 Scheduler에 대해 분석해 보았다.
- 아래와 같이 코드를 수정한 후 proj폴더의 nachos.conf파일에서 scheduler를 priority scheduler로 변경해 주어야 한다.

## Abstract Class Scheduler
---
### Schdeuler()
- Scheduler의 생성자이다.

### _newThreadQueue(boolean transferPriority)
- public abstract ThreadQueue newThreadQueue(boolean transferPriority);
- thread를 저장하는 Queue이다.
- 추상 메소드이므로 PriorityScheduler 에서 구현해 줘야 한다.

### getPriority(KThread thread)
- public int getPriority(KThread thread)
- 현재 thread의 priority를 반환하도록 구현되어야 한다.
- 제공된 코드에서는 구현된 바가 없다.

### getPriority()
- 위의 메소드의 thread파라미터가 들어갈 자리에 현재 thread가 들어간다.
- getPriority(KThread.currentThread());

### getEffectivePriority(KThread thread)
- public int getEffectivePriority(KThread thread)
- 본 함수를 사용하여 threadQueue에서 상대적인 priority를 비교한다.
- 제공된 코드에서는 구현된 바가 없다.

### getEffectivePriority()
- 위의 메소드의 thread 파라미터가 들어갈 자리에 현재 thread가 들어간다.
- getEffectivePriority(KThread.currentThread());

### setPriority(KThread thread, int priority)
- public void setPriority(KThread thread, int priority)
- 우선순위를 설정하는 역할을 수행한다.
- 제공된 코드에서는 구현된 바가 없다.

### setPriority(int priority)
- 위의 메소드의 thread 파라미터가 들어갈 자리에 현재 thread가 들어간다.
- setPriority(KThread.currentThread(), priority);

### increasePriority(), decreasePriority()
- public boolean increasePriority(), public boolean decreasePriority()
- 현재 thread의 priority를 올리거나 내린다.
- 제공된 코드에서는 구현된 바가 없다.

## PriorityScheduler
---
### newThreadQueue(boolean transferPriority)
```java
public ThreadQueue newThreadQueue(boolean transferPriority) {
	return new PriorityQueue(transferPriority);
}
```
- PriorityQueue를 생성하여 반환하도록 abstract method가 구현되었다.

### getPriority(KThread thread)
```java
public int getPriority(KThread thread) {
	Lib.assertTrue(Machine.interrupt().disabled());
	
	return getThreadState(thread).getPriority();
}
```
- 현재 ThreadState에서 getPriority()를 호출하여 현재 thread의 priority를 반환한다.
- getPriority(), getThreadState등은 PriorityScheduler에서 추가한 메소드이며 아래 절에서 다룬다.

### getEffectivePriority(KThread thread)
```java
public int getEffectivePriority(KThread thread) {
	Lib.assertTrue(Machine.interrupt().disabled());
	
	return getThreadState(thread).getEffectivePriority();
}
```
- 추후 정의되는 ThreadState 클래스의 getEffectivePriority() 메소드를 사용하여 파라미터로 전달받은 thread의 effectivePriority를 반환한다.

### setPriority(KThread thread, int priority)
```java
public void setPriority(KThread thread, int priority) {
	Lib.assertTrue(Machine.interrupt().disabled());
	Lib.assertTrue(priority >= priorityMinimum &&
	priority <= priorityMaximum);
	
	getThreadState(thread).setPriority(priority);
}
```
- 가능할 경우(maximum, minimum priority체크) 파라미터로 전달받은 thread의 priority를 파라미터로 전달받은 priority로 변경한다.
- 이때, 우선순위의 변경은 ThreadState 클래스의 setPriority 메소드를 이용한다.

### increasePriority()
```java
public boolean increasePriority() {
	boolean intStatus = Machine.interrupt().disable();
	
	KThread thread = KThread.currentThread();
	int priority = getPriority(thread);
	if (priority == priorityMaximum) return false;
	setPriority(thread, priority+1);
	
	Machine.interrupt().restore(intStatus);
	return true;
}
```
- 현재 thread의 priority를 1만큼 증가시킨다.
- 이때 setPriority 메소드를 활용한다.
- 제한 조건에 해당되지 않는다면(정상적으로 priority increase가 일어났다면) true를 반환한다.
- 그렇지 않은 경우 false를 반환한다.

### decreasePriority()
```java
public boolean decreasePriority() {
	boolean intStatus = Machine.interrupt().disable();
	
	KThread thread = KThread.currentThread();
	int priority = getPriority(thread);
	if (priority == priorityMinimum)
	return false;
	setPriority(thread, priority-1);
	
	Machine.interrupt().restore(intStatus);
	return true;
}
```
- increasePriority()와 비슷하게 동작하지만, 현재 thread의 priority를 1만큼 감소시키는 동작을 한다.

### getThreadState(KThread thread)
```java
protected ThreadState getThreadState(KThread thread) {
	if (thread.schedulingState == null)
		thread.schedulingState = new ThreadState(thread);
	
	return (ThreadState) thread.schedulingState;
}
```
- 현재 thread의 schedulingState를 반환한다.
- schedulingState는 ThreadState 클래스의 멤버 변수이며, 현재 thread의 상태를 나타낸다.

## PriorityQueue
---
- PriorityQueue클래스 내부에 protected로 선언된 클래스이다.
- ThreadQueue를 상속하여 구현하였다.

### Member Variables
```java
protected final List<ThreadState> threadsWaiting;
protected ThreadState resourceHolder = null;
protected int effectivePriority = priorityMinimum;
protected boolean priorityChange;
public boolean transferPriority;
```
- threadsWaiting
	- 현재 waiting 상태인 threads를 저장하는 list이다.
	- 이를 위해 PriorityScheduler.java에서 java.util.List의 선언이 필요하다.
- resourceHolder
	- 현재 자원을 점유하고 있는 thread의 reference이다.
	- 초기값은 null로 초기화된다.
- effectivePriority
	- queue의 effectivePriority를 저장한다.
	- 초기값은 priorityMinimum으로 초기화된다.
- priorityChange
	- 현재 effectivePriority가 유효하지 않은 경우 true 값을 가진다.
- transferPriority
	- Queue에서 대기중인 다른 thread로 priority transfer가 일어나야 하는 경우 true값을 가진다.

### PriorityQueue(boolean transferPriority)
```java
PriorityQueue(boolean transferPriority) {
	this.transferPriority = transferPriority;
	this.threadsWaiting = new LinkedList<ThreadState>();
}
```
- PriorityQueue의 생성자이다.
- 본 코드에서는 threadsWaiting을 LinkedList를 사용하여 구현했다.
	- 이를 위해 java.util.LinkedList를 선언해 줘야 한다.

### waitForAccess(KThread thread)
```java
public void waitForAccess(KThread thread) {
	Lib.assertTrue(Machine.interrupt().disabled());
	final ThreadState ts = getThreadState(thread);
	this.threadsWaiting.add(ts);
	ts.waitForAccess(this);
}
```
- ThreadState(PriorityQueue클래스와 마찬가지로 PriorityScheduler에 선언된 클래스이다. 아래 절에서 다룬다.) 타입의 ts변수를 선언하여 현재 thread의 상태를 저장한다.
- threadsWaiting에 ts를 추가한다.
- ts에 대해 waitForAccess를 호출한다.(마찬가지로 ThreadState의 메소드이다.)

### acquire(KThread thread)
```java
public void acquire(KThread thread) {
	Lib.assertTrue(Machine.interrupt().disabled());
	
	final ThreadState ts = getThreadState(thread);
	if(this.resourceHolder != null) {
		this.resourceHolder.release(this);
	}
	this.resourceHolder = ts;
	ts.acquire(this);
}
```
- waitForAccess와 같은 방식으로 동작한다.
- resourceHolder가 null이 아니라면 현재 resourceHolder(ThreadState 객체이다.)를 Queue에서 remove 한다.
- resourceHolder의 값을 ts로 갱신하고, ts에 대해서 acquire동작을 수행한다.

### nextThread()
```java
public KThread nextThread() {
	Lib.assertTrue(Machine.interrupt().disabled());
	
	final ThreadState nextThread = this.pickNextThread();
	if(nextThread == null) return null;
	this.threadsWaiting.remove(nextThread);
	this.acquire(nextThread.getThread());
	return nextThread.getThread();
}
```
- 다음에 실행될 thread를 반환하는 메소드이다.
- 다음에 실행될 thread의 정보를 얻기 위해 pickNextThread메소드를 이용한다.
- 다음에 실행될 thread가 존재하지 않는다면 null을 반환한다.
- 다음에 실행될 thread에 대해서 threadsWaiting에서 제거하고, acquire를 수행한다.

### pickNextThread()
```java
protected ThreadState pickNextThread() {
	int nextPriority = priorityMinimum;
	ThreadState next = null;
	
	for (final ThreadState currThread : this.threadsWaiting) {
		int currPriority = currThread.getEffectivePriority();
		if(next == null || (currPriority > nextPriority)) {	
				next = currThread;
				nextPriority = currPriority;
			}
	}
	return next;
}
```
- nextPriority변수를 설정하여 threadsWaiting리스트를 순회한다.
- 가장 priority가 높은 thread를 next로 설정하며, 이때의 priority를 nextPriority로 갱신한다.
- threadsWaiting의 순회가 끝났을 때 가장 우선순위가 높은 thread를 반환한다.

### getEffectivePriority()
```java
public int getEffectivePriority() {
	if(!this.transferPriority) return priorityMinimum;
	else if(this.priorityChange) {
		this.effectivePriority = priorityMinimum;
		for(final ThreadState curr : this.threadsWaiting) {
			this.effectivePriority =
			Math.max(this.effectivePriority, curr.getEffectivePriority());
		}
		this.priorityChange = false;
	}
	return effectivePriority;
}
```
- threadsWaiting을 순회하면서 가장 높은 priority를 갖는 thread의 priority로 effectivePriority값을 갱신하고, 이를 반환한다.)
- effectivePriority가 갱신되었으므로 priorityChange는 false로 설정한다.(유효한 effectivePriority)

### invalidateCachedPriority()
```java
private void invalidateCachedPriority() {
	if(!this.transferPriority) return;
	this.priorityChange = true;
	if(this.resourceHolder != null) resourceHolder.invalidateCachedPriority();
}
```
- Priority가 변경되어야 할 경우, resourceHolder에 대해서 ThreadState.invalidateCachedPriority()를 수행한다.

## ThreadState
---
- PriorityQueue클래스 내부에 protected로 선언된 클래스이다.

### Member Variables
```java
protected KThread thread;
protected int priority;
protected boolean priorityChange = false;
protected int effectivePriority = priorityMinimum;
protected final List<PriorityQueue> resourcesIHave;
protected final List<PriorityQueue> resourcesIWant;
```
- thread
	- 현재 thread를 저장한다.
- prioirty
	- priority를 저장한다.
- priorityChange
	- 현재 ThreadState의 effective priority가 유효하지 않다면 true값을 가진다.
- effectivePriority
	- 본 thread의 effective priority값을 가진다.
- resourceIHave
	- 현재 resourceHolder가 가지고 있는 queue의 리스트
- resourceIWant
	- 현재 resourceHolder가 기다리는 queue의 리스트

### ThreadState(KThread thread)
```java
public ThreadState(KThread thread) {
	this.thread = thread;
	this.resourcesIHave = new LinkedList<PriorityQueue>();
	this.resourcesIWant = new LinkedList<PriorityQueue>();
	setPriority(priorityDefault);
}
```
- ThreadState의 생성자이다.
- resourcesIHave, resourcesIWant의 리스트로 Linked list를 사용한다.

### getPriority()
```java
public int getPriority() {
	return priority;
}
```
- 현재 thread의 priority를 반환한다.

### getEffectivePriority()
```java
public int getEffectivePriority() {
	if(this.resourcesIHave.isEmpty()) return this.getPriority();
	else if(this.priorityChange) {
		this.effectivePriority = this.getPriority();
		for(final PriorityQueue pq : this.resourcesIHave) {
			this.effectivePriority =
			Math.max(this.effectivePriority, pq. getEffectivePriority());
		}
		this.priorityChange = false;
	}
	return this.effectivePriority;
}
```
- resourcesIHave를 순회하면서 effectivepriority를 값을 갱신한다.

### setPriority(int priority)
```java
public void setPriority(int priority) {
	if (this.priority == priority) return;
	this.priority = priority;
	for(final PriorityQueue pq : resourcesIWant) {
		 q.invalidateCachedPriority();
	}
}
```
- resourcesIWant의 이전 상태의 Priority에 대해 invalidate처리를 진행한다.
- 이떄 PriorityQueue의 invalidateCachedPriority()메소드를 호출한다.

### waitForAccess(PriorityQueue waitQueue)
```java
public void waitForAccess(PriorityQueue waitQueue) {
	this.resourcesIWant.add(waitQueue);
	this.resourcesIHave.remove(waitQueue);
	waitQueue.invalidateCachedPriority();
}
```
- Access요청이 들어온 queue를 resourcesIWant에 추가한다.
- 해당 큐를 resourcesIHave에서 제거한다.
- 해당 큐에 대해서 PriorityQueu.invalidateCachedPriority()를 호출한다.

### acquire(PriorityQueue waitQueue)
```java
public void acquire(PriorityQueue waitQueue) {
	this.resourcesIHave.add(waitQueue);	
	this.resourcesIWant.remove(waitQueue);	
	this.invalidateCachedPriority();
}
```
- acquire요청이 들어온 queue에 대해서 처리한다.
- 해당 큐를 resourcesIHave에 추가하고, resourcesIWant에서는 제거한다.
- 해당 큐에 대해서 PriorityQueue.invalidateCachedPriority()를 호출한다.

### release(PriorityQueue waitQueue)
```java
public void release(PriorityQueue waitQueue) {
	this.resourcesIHave.remove(waitQueue);
	this.invalidateCachedPriority();
}
```
- resourcesIHave에서 파라미터로 전달받은 waitQueue를 제거한다.
- 해당 큐에 대해서 PriorityQueue.invalidateCachedPriority()를 호출한다.

### getThread()
```java
public KThread getThread() {
	return thread;
}
```
- member variable thread에 대한 getter이다.

### invalidateCachedPriority()
```java
private void invalidateCachedPriority() {
	if(this.priorityChange) return;
	this.priorityChange = true;
	for(final PriorityQueue pq : this.resourcesIWant) {
		pq.invalidateCachedPriority();
	}
}
```
- resourcesIWant에 대해서 invalidateCachedPriority()를 호출한다.

## reference
- priority scheduler의 구현에 있어 아래 깃허브 저장소를 참고했습니다.
	- [reference github repo](https://github.com/jeremyrios/CS162-Nachos-OperatingSystem)