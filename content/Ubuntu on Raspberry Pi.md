+++
title = "Ubuntu on Raspberry pi 4"
date = 2023-06-22
[taxonomies]
tags = ["env setting"]
[extra]
author = "JS970"
+++
> 본 글에서는 Raspberry Pi 4(4GB)에 Ubuntu 20.02 LTS를 설치하는 과정에 대해 다룬다.
> SD카드에 우분투 이미지를 굽는 과정은 Windows 11에서 진행했다.
- Hardware prerequisites
	- SD카드
	- SD카드 리더기(USB)
	- 라즈베리 파이
	- mini HDMI(optional)
- Software prerequisites
	- Ubuntu 20.04 LTS 이미지
	- HP USB Disk Storage Format
	- Win32 Disk Imager

### SD 카드 포멧
- 라즈베리파이의 부트로더는 FAT16, FAT32의 파일 시스템을 사용하기 때문에 SD카드의 포멧이 FAT 16 또는FAT32가 아닐 경우 포멧을 진행해야 한다.                                             ![exFAT](/image/Enviromnent_Settings/ubuntu_on_raspberry/exFAT.png)
- [여기](https://filehippo.com/download_hp-usb-disk-storage-format-tool/) 에서 HP USB Disk Storage Format Tool 프로그램을 다운로드 받을 수 있다. 
- HP USB Disk Storage Format Tool은 관리자 권한으로 실행해야 한다. 
- SD카드의 파일 시스템을 FAT 32로 설정한 후 포멧을 진행한다.![FAT 32 Format](/image/Enviromnent_Settings/ubuntu_on_raspberry/DiskStorageFormatTool.png)
- 포멧을 진행한 후 SD카드의 파일 시스템이 FAT 32로 변경된 것을 확인할 수 있다.![FAT 32](/image/Enviromnent_Settings/ubuntu_on_raspberry/FAT32.png)

### Ubuntu 이미지 파일 SD카드에 굽기
- (2023-06-22)까지는 [여기](https://cdimage.ubuntu.com/releases/focal/release/)에서 우분투 20.04 LTS for Raspberry pi의 다운로드가 가능하다.
- preinstalled server image를 다운받은 후 GUI를 이후에 설치 가능하다.
- Win32 Disk Imager는 [여기](https://sourceforge.net/projects/win32diskimager/)에서 다운로드 가능하다. 
- Win32 Disk Imager를 사용하여 포멧을 진행한 SD카드에 다운로드한 우분투 이미지를 굽는다.![Win32 Disk Imager](/image/Enviromnent_Settings/ubuntu_on_raspberry/win32Disk.png)

### 부팅하기
- 라즈베리파이에 이미지가 구워진 SD카드를 삽입하고 mini HDMI를 이용해 모니터에 연결하면 부팅된다. ![Raspberry pi connected](/image/Enviromnent_Settings/ubuntu_on_raspberry/raspberry.png)
- 초기 ID와 PW는 ubuntu이다. 첫 로그인 이후 비밀번호를 바로 변경하면 된다.![booted](/image/Enviromnent_Settings/ubuntu_on_raspberry/booted.png)

- 네트워크 설정을 위해 /etc/netplan/50-cloud-init.yaml파일을 아래와 같이 수정해 줘야 한다. 파일 수정 시에는 반드시 sudo를 사용하여 WRITE가 가능한 상태로 수정하도록 하자.![network setting](/image/Enviromnent_Settings/ubuntu_on_raspberry/network.png)
	```yaml
	network:
	    ethernets:
	        eth0:
	            dhcp4: true
	            optional: true
		version: 2
	
		wifis:
			wlan0:
				dhcp4: true
				optional: true
				access-points:
					"wifi-name":
						password: "password"
	```
- 인덴트 간격에 유의해서 파일 수정을 마쳤다면 아래와 같이 입력하여 변경 사항을 적용시킨다.
	```bash
	sudo netplan generate # 들여쓰기 및 문법 확인
	sudo netplan apply # 적용
	```
- 이제 아래와 같이 입력해서 GUI를 다운로드한다. 시간이 제법 걸린다.![GUI-download](/image/Enviromnent_Settings/ubuntu_on_raspberry/ubuntu-desktop.png)
- 다운로드가 끝난 후 재부팅하면 아래와 같이 GUI가 설치된 우분투를 볼 수 있다.![GUI Ubuntu](/image/Enviromnent_Settings/ubuntu_on_raspberry/gui.png)

### Reference
- [라즈베리파이에 Ubuntu 20.04 LTS 설치하기](https://blog.may-i.io/tech-7/)