+++
title = "Nachos(1)"
date = 2023-03-30
[taxonomies]
tags = ["Operating System"]
[extra]
author = "JS970"
katex= true
+++
# #1
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

## 실행 결과
![nachos practice execution1](/image/OS/nachos_practice1_1.png)

# #2
## KThread.fork()
### 코드
```java
    public void fork() {
		Lib.assertTrue(status == statusNew);
		Lib.assertTrue(target != null);
		
		Lib.debug(dbgThread,
			  "Forking thread: " + toString() + " Runnable: " + target);
	
		boolean intStatus = Machine.interrupt().disable();
	
		tcb.start(new Runnable() {
			public void run() {
			    runThread();
			}
		    });
	
		ready();
		
		Machine.interrupt().restore(intStatus);
    }
```

### 동작 개요
fork()메소드는 두 개의 thread가 병렬적으로 실행되도록 동작한다. TCB에 Runnable객체를 추가하여 ready queue에 삽입하고, ready상태로 만든다.

### 조건 확인
- Lib.assertTrue() method를 사용하여 조건의 상황을 만족시키지 않는다면 assert를 발생시킨다.
	- status가 statusNew가 아닌 상황이라면 assert
	- target 이 null인 상황이라면 assert

### 디버깅 메시지 출력
- Lib.debug() method를 사용하여 디버깅 메시지를 출력한다. 이때 파라미터로 전달되는 dbgThread의 값은 KThread.java파일에서 static final로 선언된 `t`값을 가진다.
	- debug메소드에서 파라미터로 사용되는 toString()메소드는 KThread클래스의  이름 및 id값을 string으로 반환하는 역할을 한다.

### 지역 변수 선언
- intStatus 지역 변수를 선언한다.
	- 이 과정에서 Machine.interrupt().disable()메소드를 호출하고 그 반환값으로 insStatus를 초기화한다.
	- Machine.interrupt().disable()메소드는 현재 상태를 interrupt = false로 설정하고, 이전 상태를 반환한다.

### Thread ready
- tcb.start() 메소드를 통해 본 객체가 가리키는 thread의 실행을 준비한다. 이때 파라미터로 전달되는 Runnable 객체는 abstract method인 run()메소드에서 runThread()메소드를 수행하도록 구현된다.
- ready() 메소드를 통해 객체가 가리키는 thread를 ready상태로 전이시키고 readyQueue에 추가한다.

### 이전 상태 복원
- 지역 변수 선언 단계에서 Machine.interrupt().disable()메소드를 호출했다. 이때 intStatus 지역 변수를 통해 이전 상태를 저장해 두었는데, fork()메소드를 종료하기 전 Machine.interrupt().restore() 메소드를 사용하여 다시 intStatus상태(이전 상태)로 되돌린다.

## KThread.runThread()
### 코드
```java
    private void runThread() {
		begin();
		target.run();
		finish();
    }
```

### 동작 개요
KThread클래스 내부에서 사용되는 private method이다. 바로 직전에 다룬 Kthread.fork()메소드에서 호출하는 것을 확인한 바 있다. 현재 thread의 실행 준비, 실행, 실행 종료 과정을 순서대로 수행하도록 동작한다.

### begin() 호출(실행 준비)
- begin()메소드에서는 Lib.debug(), Lib.assertTrue()메소드를 호출하여 디버깅 메시지 출력 및 조건 검사를 수행한다.
- 이때 KThread가 currentThread가 아니라면 assert한다.
- 조건 검사가 끝난 후 현재 thread가 실행되도록 restoreState() 메소드를 사용하여 준비한다.
- restoreState()가 끝나면 Machine.interrupt().enable()메소드를 호출하여 Machine이 interrupt enable 상태가 되도록 변경한다.

### thread 실행
- KThread클래스에서 선언한 run메소드를 실행시킨다.
- 본 과제의 1번 문항에서 5회 실행되었던 thread를 10회 실행시키도록 바꾸었던 그 부분이다.

### finish() 호출(실행 종료)
- finish()메소드에서는 Lib.debug() 메소드를 호출하여 디버깅 메시지를 출력한다.
- begin()메소드에서 설정한 Machine의 interrupt enable상태를 Machine.interrupt().disable()메소드를 사용하여 interrupt disable상태로 변경한다.
- Machine.autoGrader().finishingCurrentThread()메소드를 호출하여 현재 thread를 종료한다.
	- 이때 autoGrader객체의 finishingCurrentThread()메소드는 privilege.tcb.authorizeDestroy()메소드를 이용하여 현재 thread가 종료되었다는 것을 autograder에게 명시한다.
	- 이로써 현재 thread는 적절한 시기에 delete된다.
- Lib.assertTrue() 메소드를 사용하여 수행 조건을 확인한다.
	- toBeDestroyed != null이라면 assert한다.
- toBeDestroyed = currentThread로 값을 초기화한다.
	- 이를 통해 현재 thread가 적절한 때에 Destroy될 수 있도록 한다.
- 현재 thread의 status를 Finished로 설정한다.
- sleep()을 호출하여 현재 thread가 다음 scheduled thread에 의해 destroy되도록 한다.

## KThread.yield()
### 코드
```java
public static void yield() {
	Lib.debug(dbgThread, "Yielding thread: " + currentThread.toString());
	Lib.assertTrue(currentThread.status == statusRunning);
	boolean intStatus = Machine.interrupt().disable();
	currentThread.ready();
	runNextThread();
	Machine.interrupt().restore(intStatus);
}
```

### 동작 개요
현재 thread가 ready 상태인 다른 thread가 있을 경우 cpu점유권을 양보하도록 한다. 이때 현재 thread는 destroy되는 것이 아닌 ready상태로 전이하며, readyQueue에 삽입되어 다시 스케줄링 될 수 있도록 한다.

### 디버깅 메시지 출력 및 조건 확인
- Lib.debug()메소드를 호출하여 디버깅 메시지를 출력한다.
- Lib.assertTrue()메소드를 호출하여 currentThread의 상태가 running상태가 아니라면 assert를 발생시킨다.
	- yeild()메소드 자체가 동작 개요에서 설명했듯이 현재 thread의 cpu사용권을 양보하는 개념으로 구현되었기 때문에 현재 thread가 running이 아니라면 assert

### 지역 변수 선언
- fork()메소드에서와 마찬가지로 지역 변수 intStatus에 Machine.interrupt().disable()메소드를 사용하여 이전 상태를 저장하고, interrupt disable상태로 설정한다.

### 현재 thread 상태 전이(running -> ready)
- ready()메소드를 사용하여 현재 thread를 ready상태로 전이시키고 readyQueue에 삽입한다.

### 다음 thread 실행
- runNextThread()메소드를 호출하여 readyQueue의 다음 thread를 실행시킨다.

### 이전 상태 복원
- yeild()메소드를 종료하기 전에 Machine.interrupt().restore()메소드를 사용하여 다시 intStatus상태로 복원시킨다.

## KThread.sleep()
### 코드
```java
public static void sleep() {
	Lib.debug(dbgThread, "Sleeping thread: " + currentThread.toString());
	Lib.assertTrue(Machine.interrupt().disabled());

	if (currentThread.status != statusFinished)
		currentThread.status = statusBlocked;

	runNextThread();
}
```

### 동작 개요
이전에 알아본 runThread()메소드 내부에서 호출한 finish()메소드에서 사용한 적 있는 메소드이다.
sleep()메소드는 현재 thread가 finish 또는 block되었을 경우 현재 thread를 sleep시켜 readyQueue에 삽입되도록 하거나 destroy되도록 하는 역할을 한다.

### 디버깅 메시지 출력 및 조건 확인
- Lib.debug(), Lib.assertTrue()메소드를 사용하여 디버깅 메시지를 출력하고, 실행 조건을 확인한다.
	- interrupt disabled상태가 아니라면 assert를 발생시킨다.

### 상황 판단
- 동작 개요의 설명과 같이, sleep()메소드는 현재 메소드가 finished thread라면 destroy하고, block된 thread라면 readyQueue로 삽입한다.
- 조건문을 통해 현재 thread가 finised 상태인지 아닌지를 판단한다.
- 현재 thread가 finished상태가 아니라면 blocked 상태로 판단하고 currentThread의 status를 Blocked로 설정한다.

### 다음 thread실행
- runNextThread()메소드를 수행하여 readyQueue의 다음 thread을 실행시킨다.

## KThread.join()
### 코드
본 실습에서 제공된 join()메소드의 코드는 조건 검사를 제외한 아무런 동작도 하지 않아 이상함을 느끼고 직접 nachos프로젝트의 저장소를 찾아가 join()구현부를 따로 찾아보았다. join()메소드의 동작 과정과 소스 코드 분석은 github의 코드를 바탕으로 수행하였다.
- 과제 제시 코드
```java
public void join() {
	Lib.debug(dbgThread, "Joining to thread: " + toString());
	Lib.assertTrue(this != currentThread);
}
```
- nachos github 코드([nachos - KThread.java](https://github.com/kanrourou/nachos/blob/master/threads/KThread.java))
```java
public void join() {
	Lib.debug(dbgThread, "Joining to thread: " + toString());
	Lib.assertTrue(this != currentThread);
	
	if(this.status==statusFinished){
		return;
	}
	
	boolean inStatus=Machine.interrupt().disable();
	
	if(KThread.currentThread.isJoined);
	else{
		joinQueue.waitForAccess(currentThread);
		isJoined=true;
		sleep();
	}
	
	Machine.interrupt().restore(inStatus);
}
```

### 동작 개요
join()메소드는 현재 객체의 thread를 다른 thread에서 기다리도록 하는 method이다. 당연하지만 현재 객체의 thread는 현재 실행 중인 thread일 수 없다. 

### 디버깅 메시지 출력 및 조건 확인
- Lib.debug()메소드를 이용하여 디버깅 메시지를 출력한다.
- 동작 개요에서 설명한 것처럼 현재 실행중인 thread에서는 join()메소드를 호출할 수 없으므로 이에 대해 Lib.assertTrue()메소드를 확인하여 실행 조건을 확인한다.

### 본 객체의 thread가 이미 finished 상태인 경우에 대한 처리
- 본 객체의 thread가 이미 finished상태인 경우 join을 위해 대기할 필요가 없으므로 바로 return 한다.

### 지역 변수 선언
- 지역 변수 inStatus를 이용하여 이전 상태를 저장한다. 이때 호출하는 Machine.interrupt().disable()메소드에 의해 interrupt disable된다.

### join여부 확인
- 조건문을 사용하여 join여부를 확인한다.
- isJoined == false인 경우 joinQueue의 waitForAccess() 메소드를 호출한다.
	- 이때 waitForAccess()메소드의 파라미터로는 currentThread가 들어간다.
- isJoined를 true로 초기화한다.
- sleep()을 호출하여 대기한다.

### 이전 상태 복원
- inStatus를 이용하여 이전 state로 복원한다.

## KThread.runNextThread()
### 코드
```java
private static void runNextThread() {
	KThread nextThread = readyQueue.nextThread();
	if (nextThread == null)
		nextThread = idleThread;
	
	nextThread.run();
}
```

### 동작 개요
readyQueue의 다음 thread를 실행시킨다.

### 다음 thread load
- local variable nextThread를 선언한다. nextThread에는 readyQueue의 다음 thread가 할당된다.
- 만약 loadThread가 null이라면(queue가 비어 있는 상황 등) nextThread로 idleThread를 할당한다.

### load된 nextThread실행
- load된 다음 실행될 thread인 nextThread를 run()메소드를 사용하여 실행시킨다.

## KThread.run()
### 코드
```java
private void run() {
	Lib.assertTrue(Machine.interrupt().disabled());
	Machine.yield();
	currentThread.saveState();
	
	Lib.debug(dbgThread, "Switching from: " + currentThread.toString()
		  + " to: " + toString());
	currentThread = this;
	tcb.contextSwitch();
	currentThread.restoreState();
}
```

### 동작 개요
현재 실행중인 thread를 yeild하고 새로운 thread를 실행시킨다. currentThread를 run()메소드를 호출한 객체의 thread로 갱신한다. 이후 context switching을 수행하고 새로운 thread를 실행시킨다.

### 실행 조건 확인
- Lib.assertTrue()메소드를 통해 interrupt disabled상태가 아니라면 assert시킨다.

### run() 수행 준비
- 현재 실행되고 있는 thread에 대해서 yield를 수행한다.
- saveState()메소드를 호출하여 currentTHread가 프로세스 점유를 포기하도록 한다.
	- 바로 직전 라인에서 yield()를 수행하였지만, currentThread에 대한 갱신은 아직 이루어지지 않았으므로, 이전에 실행되고 있던 thread에 대해 수행되는 구문이다.

### 디버깅 메시지 출력
- Lib.debug()메소드를 호출하여 디버깅 메시지를 출력한다.

### context switching
- currentThread를 yiled()의 호출로 실행되고 있는 thread로 갱신한다.
- tcb.contextSwitch()메소드를 호출하여 context switching 이 일어나도록 한다.
	- current TCB를 이전 thread의 tcb에서 새롭게 갱신된 thread의 tcb로 갱신한다.

### thread실행 준비
- context switching까지 끝났으므로 cureentThread에 대해 restoreState() 메소드를 호출하여 thread를 실행시킨다.

## KThread.restoreState()
### 코드
```java
protected void restoreState() {
	Lib.debug(dbgThread, "Running thread: " + currentThread.toString());
	
	Lib.assertTrue(Machine.interrupt().disabled());
	Lib.assertTrue(this == currentThread);
	Lib.assertTrue(tcb == TCB.currentTCB());

	Machine.autoGrader().runningThread(this);
	
	status = statusRunning;

	if (toBeDestroyed != null) {
		toBeDestroyed.tcb.destroy();
		toBeDestroyed.tcb = null;
		toBeDestroyed = null;
	}
}
```

### 동작 개요
현재 thread가 실행될 준비를 하고, 상태를 running으로 전이시킨다. 이전 thread의 종료로 인한 tcb의 destroy리스트가 남아 있다면 destroy를 수행한다.

### 디버깅 메시지 출력
- Lib.debug()메소드를 호출하여 디버깅 메시지를 출력한다.

### 실행 조건 확인
- Lib.assertTrue()메소드를 호출하여 실행 조건을 검사한다.
	- interrupt disabled 상태가 아니라면 assert한다.
	- 현재 thread가 실행 중인(currentThread)thread가 아니라면 assert한다.
	- 현재 tcb가 실행 중인(TCB.currentTCB()메소드를 이용해 확인)TCB가 아니라면 assert 한다.
- 위의 실행 조건들은 run()메소드에서 restoreState()메소드를 호출하기 전에 했던 일련의 과정들과 일치함을 알 수 있다.

### 현재 thread실행
- Machine.autoGrader().runningThread()메소드에 this(현재 thread)를 파라미터로 입력하여 autoGrader에 현재 thread 정보를 명시한다.
	- runningThread()메소드에서는 파라미터로 전달받은 thread객체에 대해 tcb를 매칭하고, currentThread를 갱신한다.
- status를 running상태로 갱신한다.

### toBeDestroyed 확인
- thread를 가리키는 지역 변수인 toBeDestroyed를 검사하여 null인 경우에는 destroy할 thread가 없음을 의미하므로 별도의 동작 없이 restoreState()를 마친다.
- toBeDestroyed가 null이 아닌 경우 toBeDestroyed thread에 대해 destroy를 수행한다.
	- toBeDestroyed.tcb.destroy()를 수행하여 destroy한다.
	- destroy가 끝나면 toBeDestroyed.tcb, toBedestroyed는 null로 초기화한다.

## KThread.saveState()
### 코드
```java
/**
* Prepare this thread to give up the processor. Kernel threads do not
* need to do anything here.
*/
protected void saveState() {
	Lib.assertTrue(Machine.interrupt().disabled());
	Lib.assertTrue(this == currentThread);
}
```

### 동작 개요
현재 thread가 프로세스 점유를 넘기는 것을 준비하는 메소드이다. 주석의 내용에 따르면, 커널 메소드는 이 부분에서 아무 것도 구현할 필요가 없다고 되어 있어 메소드의 구현부에는 조건 검사밖에 없는 상황이다.

### 실행 조건 확인
- interrupt disabled 되어 있지 않은 상태라면 Lib.assertTrue()메소드를 이용하여 assert한다.
- 동작 개요에서 설명한 대로, 본 메소드는 프로세스 점유를 넘길 준비를 하는 메소드이다. 따라서 currentThread가 현재 thread라면 말이 되지 않는다. -> assert

### 추측
커널 메소드가 아닌 경우에서 svaeState()메소드를 호출한 경우를 가정해 보자. saveState라는 메소드 명에 맞게, 본 메소드는 현재 thread의 context정보를 다시 불러올 수 있도록 저장하는 역할을 할 것이다. 저장된 context는 TCB 자료 구조로 메모리에 저장될 것이다.

# #3
- KThread는 new, ready, running, blocked, finished의 5가지 상태 중 하나의 값을 가진다. (null인 경우는 생각하지 않는다.)
- PingTest클래스에서 구현된 run()메소드는 반복문을 10번 순회하면서 각 순회마다 yield()를 호출하는 구조이다.
- PingTest클래스를 추가하고 이를 실행시키기 위해 ThreadedKernal.java의 selfTest()메소드에 추가한 new KThread(new PingTest(1)).setName("forked thread").fork()는 이 자체만으로는 아무런 결과도 출력할 수 없다. 해당 객체의 run()을 수행하는 child process를 ready queue에 올리기만 하고 running상태로 만들지는 못하기 때문이다. 즉 ready상태이지 running상태가 아니므로 이 자체만으로는 실행될 수 없다.
- new KThread(new PingTest(1)).setName("forked thread").fork(); 코드를 통해 ready queue에 올라간 thread를 실행시키기 위해서는 KThread의 private method인 runNextThread()를 호출해야 한다. private method 이므로 직접 호출이 불가능하기 때문에 runNextThread()를 호출하는 public method를 찾아보았고, 그 결과 yeild(), sleep()에서 runNextThread()를 호출하는 것을 확인했다.
- mainThread라는 Runnable 구현체를 하나 만들어서, PingTest와 비슷한 구조를 갖지만 출력은 하지 않도록 run()을 작성하였다. 아래는 mainThread 클래스의 코드이다. forked thread의 run()메소드의 반복문과 구별하기 위해 반복문의 반복자로 j를 사용하였다.
```java
private static class mainThread implements Runnable {
	mainThread(){}

	public void run() {
		for (int j = 0; j < 10; j++) {
			KThread.currentThread().yield();
		}
	}
}
```
- 그리고 ThreadedKernel.java의 selfTest()메소드에 아래와 같이 코드를 추가했다.
```java
public void selfTest() {
	mainThread mt = new mainThread();
	new KThread(new PingTest(1)).setName("forked thread").fork();
	mt.run();
}
```
- 이때 selfTest()메소드에서 mt.run()이 fork()를 호출한 이후에 와야 한다. fork()메소드 호출 이전에 mt.run()이 위치하면 mt thread 중간에 yeild()를 호출하더라도 ready queue는 빈 상황이고, mainThread는 곧바로 다시 실행된다. 결국 mainThread가 종료된 후에 fork()가 일어나게 되므로 \#3의 초기 상황과 마찬가지로 ready상태에서 running상태로 전이하지 못해 출력 코드가 실행되지 않는다.
- #3 초기 코드 도식![original code abstraction](/image/OS/nachos_practice01_1.png)
- #3 코드 추가 이후 도식 ![original code abstraction](/image/OS/nachos_practice01_2.png)
- 다음은 nachos를 실행하여 확인한 결과이다.
![실행결과](/image/OS/nachos_practice1_3.png)
- mainThread의 반복 횟수를 10회로 설정한 이유는 PingTest의 run() 메소드에서 10번 yield()를 호출하기 때문이다. mainThread의 반복 횟수가 10회 이상이라면 ready queue에서 PingTest가 10번 yield를 실행해도 10번 모두 실행된다. 하지만 10회 미만이라면 mainThread가 모두 실행된 이후 yeild()가 호출되지 않고 thread가 종료되어 forked thread가 실행되지 못해 10번 모두 실행하지 않고 끝나는 결과로 출력된다.
