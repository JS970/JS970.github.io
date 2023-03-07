+++
title = "VPN & Subnet"
date = 2022-10-25
[taxonomies]
tags = ["Computer Network"]
[extra]
author = "JS970"
+++
## VPN : Virtual Private Network

- “가상” 사설 네트워크이다.
- “가상” 이라는 것은 결국 물리적인 사설 네트워크가 아닌 공용 네트워크를 사용한다는 것을 의미

<aside>
💡 L2TP, PPTP, IPSEC VPN… 많은 VPN 솔루션이 존재한다.

</aside>

- 수업 시간에 설명한 VPN 도식, IP turneling을 통해 동작한다.

![Untitled](/image/VPN&Subnet/Untitled.png)

## Subnetting

- 인터넷은 라우팅 확장성 문제와 라우팅 시스템의 공간 사용률 이슈가 있다.
- 라우팅 확장성 - 라우팅 프로토콜에서 전송하고, 라우팅 테이블에 저장되는 network numbers의 수를 최소화 해야 한다. ⇒ Hieracrchy를 통해 해결
- 라우터 시스템의 공간 사용률 ⇒ “Subnet”을 통해 주소와 공간의 사용률을 확보한다.
- 사실, “Subnet을 통해 주소와 공간의 효율적인 사용 뿐만 아니라 IP주소의 Hierarchy도 확보할 수 있다.
- 아래는 IPv4의 Subnetting이다.

![Untitled](/image/VPN&Subnet/Untitled%201.png)

- C 클래스 사설 IP 대역은 192.168.XXX.YYY, A 클래스 사설 IP 대역은 10.XXX.YYY.ZZZ이다.
- IPv4의 클래스 개념은 매우 비효율적이다.
- 2대의 Host가 있을 경우 C클래스 네트워크를 사용해야 한다.
    
    ⇒ 2/255, 사용률이 0.78%에 불과하다.
    
- 마찬가지로 256대의 Host 가 있을 경우 B클래스 네트워크가 필요하다.
    
    ⇒ 256/65535 = 0.39% ⇒ IP의 낭비가 매우 심각하다.
    
- 다음은 부산대학교 네트워크를 예시로 Subnet을 나타낸 그림이다.

![Untitled](/image/VPN&Subnet/Untitled%202.png)

- 부산대학교는 ISP에게 B클래스 IP주소를 공급받는다.
- 부산대학교의 각 Subnet은 ISP에게 직접 C클래스 IP주소를 공급받는 것이 아닌, 부산대학교가 ISP로부터 공급받은 B클래스 IP 주소를 C클래스 IP로 변환하고, 서브넷 마스크를 255.255.255.0으로 설정하여 virtually partitioning된다.
- ISP는 classless IP address assignment를 사용한다.
- ISP에서는 소비자에게 필요한 만큼 IP address를 할당할 수 있다. ⇒ 주소 공간의 낭비를 줄인다.

<aside>
💡 CIDR(Classless InterDomain Routing)을 사용한다.

</aside>

## IPv4 Decimal Notation

- 8bit.8bit.8bit.8bit가 기본적인 형식이지만…
- 8bit.8bit.10bit.6bit 이런 식으로 설정할 수도 있다.
- 위 경우 subnet mask는 255.255.255.192(11111111.11111111.11111111.11000000)이다.
- subnet mask를 이용해서 가능한 host의 수를 알 수 있다.
- 예를 들어 subnet mask가 255.255.255.224인 경우 host의 표현을 위해 5비트를 사용하므로 최대 $2^{5}-1$명의 host를 나타낼 수 있다. ( possible host = $2^{n}-1$)
- 이러한 subnet mask의 설정을 사용률을 늘일 수 있다. 하지만 보통은 네트워크 관리자가 이렇게까지 설정하기 귀찮으므로 255.255.255.0 처럼 관습적인 subnet mask를 사용한다.

![Untitled](/image/VPN&Subnet/Untitled%203.png)

- Host #1에서 Host #2로 datagram을 전송한다고 했을 때 Next hop은 R1이다(en0).
- Host #1에서 Host #3로 datagram을 전송한다고 했을 때 Next hop 은 R2이다.

## reference

[https://www.youtube.com/watch?v=Q0EgiHhw-E4](https://www.youtube.com/watch?v=Q0EgiHhw-E4)

[CIDR - 비클래스형 IP주소할당 체계](https://securitymax.tistory.com/133)