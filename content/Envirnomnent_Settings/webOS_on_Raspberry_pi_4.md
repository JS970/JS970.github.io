+++
title = "webOS on Raspberry pi 4"
date = 2023-03-03
[taxonomies]
tags = ["일시 중단", "라즈베리 파이", "webOS"]
[extra]
author = "JS970"
+++

# webOS OSE(open source eddition)

- webOS의 오픈 소스 버전이다.
- 필요에 따라 커스텀 빌드가 가능하다.
- 빌드 시스템으로는 **yocto**를 사용하며, 이는 18.04이전 버전의 Ubuntu에서 동작한다.
- 본 글에서는 라즈베리파이4에 설치할 운영체제인 **webOS OSE**를 빌드하는 과정을 설명한다.

# 준비물

- 18.04 이하 버전의 ubuntu(VM 안됨)
    - 이후 버전으로 빌드를 시도하면 **yocto**가 에러뜬다.
    - 본 빌드에서는 **Ubuntu 18.04.6 LTS**를 사용하였다.
    - 개인 서버는 **Ubuntu 22.02 LTS**를 사용중이고, 여기서 빌드를 시도할 경우 **yocto**설치 파일을 제대로 다운로드하지 못하는 문제가 있었다. 그냥 맘편히 VMWARE에서 **Ubuntu 18.04.6 LTS** 로 설치했다. ⇒ 진짜 이틀을 날린 희대의 실수가 되었다… VM은 쓰지 말 것..
- 빌드 시스템(**yocto**)
    - **yocto** 에 대해서 자세하게 조사하지는 않았으며, 그냥 webOS를 빌드하기 위한 빌드 시스템 정도로 파악하고 넘어갔다.
    - webOS OSE는 yocto를 통한 빌드 시 webOS image를 수정하여 빌드하는 것이 가능하다.
    - 본 빌드에서는 따로 webOS image를 수정 또는 변경하지 않고 기본 상태 그대로 빌드했다.
- **gcc**(8.2버전 이상)
    - **Ubuntu18.04.6**설치 후 빌드를 시도하였으나 g++컴파일러가 헤더를 charconv헤더를 인식하지 못해 빌드에 실패했다는 에러가 발생했다. 해당 에러에 대해 검색해 보니 8.2버전 이상의 g++컴파일러를 필요로 했다.
    - **Ubuntu18.04.6**의 기본 설치된 gcc의 버전은 7.4였다.
    - gcc의 버전 업데이트를 위해 다음과 같은 커멘드를 입력하였다.
    
    ```powershell
    sudo add-apt-repository ppa:ubuntu-toolchain-r/test
    sudo apt-get update
    sudo apt-get install gcc-11 g++-11
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 110 --slave /usr/bin/g++ g++ /usr/bin/g++-11
    sudo update-alternatives --config gcc
    ```
    
    - 다음은 gcc11을 설치하는 과정이다.
        - gcc의 최신 버전이 올라오는 **PPA**(Personal Package Archive)를 추가한다.(1행)
        - gcc-11을 설치한다.(3행)
        - 실행 시 버전을 명시하지 않고도 바로 사용할 수 있도록 gcc에 매핑시킨다.(4행)
    
    [[gcc] Ubuntu 20.04에서 최신 버전 gcc설치하기](https://kukuta.tistory.com/394)
    
- Raspberry pi 4
    - Target machine으로 Raspberry pi 4, 4GB모델을 사용했다.
- sd card
    - webOS OSE의 image가 올라갈 저장 공간으로 sd card가 있어야 한다.
    - 64GB sd card를 사용하였다.

# Build

- 아래 페이지의 README.md를 참고하여 빌드한다.

[https://github.com/webosose/build-webos](https://github.com/webosose/build-webos)

- `절대로` VM을 사용해서 빌드를 시도하지 말자… 애초에 README.md에서도 VM을 사용하지 말라고 명시했다.
1. 빌드 시스템(yocto)설치

```bash
git clone https://github.com/webosose/build-webos.git
cd build-webos
sudo scripts/prerequisites.sh
```

1. 빌드 환경의 총 cpu코어 수 조사, 두 값을 곱한 값이 총 코어 수이다.

```bash
# Pyhsical CPU
cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l
# Pyhsical CPU cores
cat /proc/cpuinfo | grep "cpu cores" | uniq
```

1. 빌드 시작 전 configure

```bash
./mcf -p <cpu core> -b <cpu core> raspberrypi4
```

1. 빌드 시작

```bash
make webos-build
```

(23/02/16 기준으로 아래와 같은 에러가 발생하며 더 이상 진행하지 못하고 있다.

![Screenshot from 2023-02-16 22-23-01.png](Screenshot_from_2023-02-16_22-23-01.png)