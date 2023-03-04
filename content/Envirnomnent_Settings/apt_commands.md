+++
title = "apt commands"
date = 2023-02-14
[taxonomies]
tags = ["env setting"]
[extra]
author = "JS970"
+++

<aside>
💡 아래 커멘드 중 install을 빼고 사용할 곳이 얼마나 있나 싶지만… 멍청하게도 /bin에서 다짜고짜 삭제를 감행하는 짓을 벌이고 난 후에 아래 apt purge를 사용해서 완전 삭제가 가능했다. 이런 특수한 경우에 꽤나 유용하게 사용할 수 있다.

</aside>

# APT Usage

- 패키지 목록 갱신

```bash
apt update
```

- 패키지 업그레이드

```bash
apt upgrade
```

- 패키지 설치(+dependency)

```bash
apt install <package>
```

- 패키지 삭제(설정 파일 제외)

```bash
apt remove <package>
```

- 설정 파일을 포함한 패키지 삭제

```bash
apt purge <package>
```

- 관련 패키지 검색

```bash
apt search <package>
```

- 패키지 정보 출력

```bash
apt show <package>
```

- 패키직 목록 출력

```bash
apt list
```

- 설치된 패키지 목록 출력

```bash
apt list --installed
```

- 업그레이드 가능 패키지 목록 출력

```bash
apt list --upgradable
```

- 도움말

```bash
apt --help
```

# ref

[Ubuntu Server / apt / 패키지 설치, 삭제, 업그레이드하는 명령어](https://www.manualfactory.net/11953)