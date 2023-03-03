+++
title = "ANACONDA 환경설정"
date = 2023-01-25
[taxonomies]
tags = ["env setting", "ANACONDA"]
[extra]
author = "JS970"
+++

<aside>
⚠️ 본 글은 Windows 11 기준으로 작성되었음

</aside>
⚠️ Ubuntu 22.04환경에서의 설정도 별첨했음

# ANACONDA란?

---

ANACONDA는 Python 과 R에서 패키지 개발 및 관리를 용이하게 하기 위한 가상 환경을 제공한다.

다음과 같은 경우 ANACONDA가 매우 효율적이다.

- 파이썬의 버전을 자주 바꿔야 하는 경우
- 패키지 이름이 중복되는 경우

아나콘다는 컨테이너로 작동하며 환경 설정 후 사용 가능하다. 이때 파이썬 버전을 설정 가능하며 이 환경에서의 pip명령 등은 다른 컨테이너에 영향을 주지 않는다.

# ANACONDA 설치

---

터미널에서 패키지 매니저를 활용하여 설치할 수도 있지만 그냥 설치 파일을 다운로드 하여 설치를 진행하는 것이 깔끔하다.

[Anaconda | Anaconda Distribution](https://www.anaconda.com/products/distribution)

# ANACONDA 사용

---

## Anaconda Prompt

ANACONDA의 설치가 완료되면 Anaconda Prompt를 사용할 수 있다. 

Anaconda Prompt는 기본적으로 터미널과 다를 것이 없다. 

Anaconda Prompt는 ANACONDA에서 제공하는 conda 명령어들의 사용을 확실히 보장한다.

ANACONDA 설치 시에 환경 변수를 설정해 주면 Anaconda Prompt에서와 똑같이 CMD에서도 conda 명령어를 사용 가능하다.

Anaconda Prompt를 사용한다면 이런 설정 없이도 conda명령어가 작동됨을 보장받을 수 있다.

ANACONDA업데이트 이후 conda 명령어가 인식이 되지 않는다면 아래의 명령어를 입력해서 Anaconda Prompt를 업데이트 한 후 정상적으로 사용이 가능하다.

```powershell
conda update conda
```

## 컨테이너 생성

```powershell
conda create -n <env_name> python=<version>
```

- example
    
    ```powershell
    conda create -n yolo python=3.10
    ```
    

## 컨테이너 리스트 나열

```powershell
conda env list
```

## 컨테이너 활성화

```powershell
activate <env_name>
```

혹시 위의 명령어가 인식되지 않을 경우 아래와 같이 입력

```powershell
source activate <env_name>
```

## 컨테이너 비활성화

```powershell
deactivate
```

마찬가지로 위의 명령어가 인식되지 않을 경우 아래와 같이 입력

```powershell
source deactivate
```

# 참고 사이트

---

[[Anaconda]아나콘다 설치하는법과 사용법](https://kamang-it.tistory.com/entry/Anaconda%EC%95%84%EB%82%98%EC%BD%98%EB%8B%A4-%EC%84%A4%EC%B9%98%ED%95%98%EB%8A%94%EB%B2%95%EA%B3%BC-%EC%82%AC%EC%9A%A9%EB%B2%95)

[difference between command prompt and anaconda prompt](https://stackoverflow.com/questions/37993175/difference-between-command-prompt-and-anaconda-prompt)