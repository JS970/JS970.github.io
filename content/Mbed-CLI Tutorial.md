+++
title = "Mbed-CLI Tutorial"
date = 2023-06-25
[taxonomies]
tags = ["TinyML"]
[extra]
author = "JS970"
katex= true
+++
## Mbed-CLI Tutorial
---
> Mbed-CLI 환경 구축이 완료되었다면 간단한 예제 프로젝트를 진행하면서 사용법을 익혀 보자.

### 1. 프로젝트 생성
- 아래 명령어를 입력하면 "project name" 디렉토리가 생성되며 프로젝트 디렉토리로 설정된다. 
	```bash
	mbed new "project_name" --mbedlib
	```
	- `--mbedlib`옵션은 Mbed library를 사용하는 Mbed OS 2 프로젝트로 생성하는 옵션이다.
	- [STM32F746G-disco Tutorial](https://js970.github.io/stm32f746g-disco-tutorial/)은 Mbed library를 사용하므로 이 옵션으로 생성해야 한다.
	- 이외의 자세한 명령어 및 옵션은 [Mbed CLI 1 Create](https://os.mbed.com/docs/mbed-os/v6.16/build-tools/create.html)에서 정보를 얻을 수 있다.
- 라이브러리를 추가할 때는 아래의 명령어를 사용하면 된다.
	```bash
	mbed add http://os.mbed.com/teams/ST/code/LCD_DISCO_F746NG/
	```
	- `mbed add`뒤에 라이브러리를 입력하면 된다.
	- 위에서 추가한 라이브러리는 [STM32F746G-disco Tutorial](https://js970.github.io/stm32f746g-disco-tutorial/)에서 사용되는 LCD 라이브러리이다.

### 프로젝트 생성 Issue
- [Github Issue](https://github.com/ARMmbed/mbed-cli/issues/968)
- 프로젝트 생성 명령어를 입력했음에도 아래의 진행상황에서 진행이 되지 않을 수 있다.
	```bash
	mbed new simple_test --mbedlib 
	[mbed] Working path "/home/arvoelke/git/..." (program)
	[mbed] Creating new program "simple_test" (git)
	[mbed] Adding library "mbed" from "https://mbed.org/users/mbed_official/code/mbed/builds" at branch/tag "tip"
	[mbed] Downloading library build "65be27845400" (might take a while)
	```
- 이건 mbed 문제이므로 아래의 순서로 해결해야 한다.(2023-06-25)
	1.  mbed-cli 삭제 후 재설치
		```bash
		pip uninstall mbed-cli
		git clone https://github.com/ARMmbed/mbed-cli.git
		cd mbed-cli
		pip install --editable .
		```
		- 어디에 클론하든 상관은 없다.(본 글에서는 홈 디렉토리에 했다.)
	 2. 클론한 디렉토리의 `mbed/mbed.py` 의 397행 수정
		 ```python
		 while data != b'':
		```
