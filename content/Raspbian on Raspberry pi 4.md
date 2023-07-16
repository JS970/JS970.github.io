+++
title = "Raspbian on Raspberry pi 4"
date = 2023-07-16
[taxonomies]
tags = ["env setting"]
[extra]
author = "JS970"
+++
> 본 글에서는 Raspberry Pi 4(4GB)에 Raspbian운영체제를 설치하는 과정에 대해 다룬다.
> SD 카드에 Rsapbian 운영체제 이미지를 굽는 과정은 Windows 11에서 진행했다.
- Hardware prerequisites
	- SD Card
	- SD Card reader(USB)
	- Raspberry Pi Model B (4GB)
	- mini HDMI(optional)
- Software prerequisites
	- SD Card Formatter
	- Raspberry Pi imager

### SD Card Format
---
![SD Card Format](/image/Environment_Settings/Raspbian_on_raspberry/format.png)
- 라즈비안을 설치하기 위해 SD카드를 포멧해야 한다.
- [SD Card Formatter](https://www.sdcard.org/downloads/formatter/sd-memory-card-formatter-for-windows-download/)를 이용하여 SD카드 포멧을 진행할 수 있다.
- Overwrite format을 선택하여 확실하게 포멧을 진행한다.
- Volume label은 원하는 이름을 기입한다.

### Raspberry Pi Imager를 사용해 이미지 굽기
---
- Raspberry Pi Imager 실행 모습![Raspberry Pi Imager](/image/Environment_Settings/Raspbian_on_raspberry/iamger.png)
- 설치할 운영체제 선택![Raspberry Pi OS Full 32bit](/image/Environment_Settings/Raspbian_on_raspberry/os_select.png)
- 설치할 저장소 선택![storage select](/image/Environment_Settings/Raspbian_on_raspberry/storage_select.png)
- 저장소에 이미지 굽기![download image](/image/Environment_Settings/Raspbian_on_raspberry/image_install.png)
- 이미지 다운로드 완료![download complete](/image/Environment_Settings/Raspbian_on_raspberry/download_complete.png)
- 이미지 설치 완료 후 첫 부팅![booted](/image/Environment_Settings/Raspbian_on_raspberry/installed.png)
- 설정 및 업데이트 완료![Complete](/image/Environment_Settings/Raspbian_on_raspberry/complete.png)

### Reference
- [천보기의 IT 학습마당](https://zifmfmphantom.tistory.com/113)