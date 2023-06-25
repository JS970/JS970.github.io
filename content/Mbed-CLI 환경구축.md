+++
title = "Mbed-CLI"
date = 2023-06-25
[taxonomies]
tags = ["env setting", "TinyML"]
[extra]
author = "JS970"
katex= true
+++
## Mbed-CLI 환경 구축
---
> STM32F746G-disco보드의 실습을 위해 STM32CubeIDE를 설치했지만, TinyML(한빛미디어, 2020.8)책에서는 Mbed-CLI를 이용하여 빌드를 진행했다. 우선은 책의 내용을 따라가기 위해 Mbed-CLI환경을 구축해 보았다.
### prerequisites
- python3.x 이상
- git
- Mercurial 2.2.2 이상(분산 버전 관리 시스템)

### Mbed CLI 설치하기
> ARM Mbed tool로는 `Keil Studio Cloud`, `Mbed Studio`, `Mbed-CLI`가 있다. 세 tool 모두 Mbed OS source를 Github또는 mbed.com으로부터 dependency를 고려하여 가져오는 역할을 하고, Mbed OS 위에서 동작하는 코드를 컴파일하여 보드에서 실행시킬 하나의 플래시 파일을 생성한다. 어떤 툴을 사용하던지 상관은 없지만 책에서 사용하는 Mbed CLI를 설치하여 사용해 보기로 했다.
- `pip`을 이용해 설치할 수 있다.
	```bash
	python3 -m pip install mbed-cli
	```
- Mbed CLI의 업데이트는 아래와 같은 명령어를 통해 진행할 수 있다.
	```bash
	python3 -m pip install -U mbed-cli
	```

### 컴파일러 설치하기
> 컴파일러로는 `ARM Compiler 6.16`또는 `GNU ARM Embedded version 10`을 사용할 수 있다. 어떤 것을 사용하든 상관은 없다고 한다. 본 글에서는 `ARM Compiler`를... 사용하려고 하였으나 Windows 및 Linux설치 파일은 제공하지만 Mac OS X설치파일은 제공하지 않아 `GNU ARM Embedded version 10`으로 진행했다.
- download
	- [ARM Compiler](https://os.mbed.com/docs/mbed-os/v6.16/build-tools/index.html#compiler-versions)다운로드
	- [GNU ARM Embedded version 10](https://developer.arm.com/downloads/-/gnu-rm) 다운로드
- `GNU ARM embedded version 10`을 다운로드 한 뒤에 설치를 원하는 폴더에서 아래 명령어를 입력하여 압축 해제한다.
	```bash
	tar xjf gcc-arm-none-eabi-10.3-2021.10-mac.tar.bz2
	```
	- 다운로드 받은 파일에 대해서 압축해제 한 것이니 버전이 다른 경우 이름 변경 해야함
- 그리고 아래와 같이 `~/.zshrc`(또는 `~/.bashrc`)에 환경 변수 설정을 추가해 주면 된다.
	```bash
	export PATH=$PATH:${install_dir}/gcc-arm-none-eabi-10.3-2021.10/bin
	```
- `~/.zshrc`파일 로드 후 아래 명령어를 실행시켜 보면 제대로 컴파일러가 설치된 것을 확인할 수 있다.
	```bash
	arm-none-eabi-gcc --version
	```
	- 설치 확인 && 버전 확인![GNU ARM Embedded version 10](/image/Environment_Settings/Mbed-CLI/compiler.png)
	- 확인되지 않은 개발자에 의한 애플리케이션이라 실행할 수 없다는 팝업이 발생하면 Mac의 시스템 설정의 개인정보 보호 및 보안 탭 에서 직접 arm-none-eabi-gcc를 허용해 주어야 한다.
- 더 자세한 정보는 다운로드 파일을 압축 해제했을 때의 루트에서 /share/doc/gcc-arm-none-eabi폴더에 있는 readme.txt에서 확인할 수 있다.

### 컴파일러 위치 설정하기
- 프로젝트 빌드를 위해서 Mbed CLI는 컴파일러가 설치된 경로를 알아야 한다.
- 아래 순서로 configuration option을 체크한다.
	1. Mbed CLI config(local first, then global)
	2. Environment variables
	3. System path
- 아래 명령어를 입력해서 Mbed CLI configuration을 진행할 수 있다.
	```bash
	mbed config -G MBED_GCC_ARM_PATH ${install_dir/..}
	```
	- 설치 폴더의 부모 디렉토리를 입력해야 하는 것에 주의하자
	- `-G`옵션을 통해 Mbed project의 로컬 경로 설정이 없다면, 위의 경로를 default 컴파일러 경로로 인식할 것이다.(G : global)