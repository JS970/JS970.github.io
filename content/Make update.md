+++
title = "Make update"
date = 2023-06-25
[taxonomies]
tags = ["env setting"]
[extra]
author = "JS970"
katex= true
+++
## Make update
---
TinyML의 예제 실습 중 make 3.8.2를 써야 하는 상황이 발생했다.

그런데... macOS X에서는 기본적으로 제공되는 make 버전에 대해 더 이상 업데이트 해 주지 않는다.

즉, Homebrew를 사용하여 최신 버전의 make를 설치하는 방법으로는 업데이트가 불가능하다.
### update
- GNU make 소스 코드를 직접 [다운로드](https://ftp.gnu.org/gnu/make/)하여 컴파일 및 설치를 진행해야 한다.
- 다운로드 받은 뒤에는 압축을 해제한 폴더에서 아래 명령어들을 입력하면 설치가 완료된다.
	```bash
	./configure
	make
	sudo make install
	```
- 이후 터미널을 종료 후 재실행하여 make버전을 확인해 보면 업데이트 된 것을 볼 수 있다.