+++
title = "Mobile IPv4"
date = 2022-12-07
[taxonomies]
tags = ["Computer Network"]
[extra]
author = "JS970"
+++
# RARP, BOOTP, DHCP

정리: Done
정리일: 2022년 12월 7일

# RARP : Reverse Address Resolution Protocol - RFC903

- 시스템이 booting될 때, 보통은 IP address를 저장해 놓은 파일로부터 IP주소를 얻는다.
- 그렇다면 저장 장치가 없는 시스템에서는 어떻게 IP주소를 얻을 수 있을까?
    - MAC주소(하드웨어 주소) 는 고유하기 때문에 MAC에 대응하는 IP주소를 lookup을 통해 얻을 수 있다.(lookup table??)
    - MAC주소의 경우 시스템에 내장된 이더넷 칩셋에 저장되어 있으므로 이 정보를 이용해 서버로부터 IP주소를 획득할 수 있다.
- RARP는 TCP/IP specification이다.

## Determining an IP Address at Startup

- Network를 이용하여 remote server로부터 IP주소를 획득한다.
- MAC주소를 이용해 통신한다.
- IP테이블을 관리하는 서버로부터 IP주소를 요청한다.
    - 만약 서버의 주소를 모른다면 ??
    - Broadcast를 이용한다.
- RARP는 ARP처럼 작동한다.
1. 요청자는 RARP request를 broadcast한다.
2. 서버는 요청자에게 응답한다(unicast)
3. 요청자는 첫 번째 응답자로부터 받은 IP주소를 저장한다.
4. 요청자는 IP주소를 얻을 때까지 계속해서 요청을 보낸다.

## Alternatives to RARP

- RARP를 구현하기 위해서는 물리 계층을 이용해야 한다.
- 상위 계층에서 이를 구현할 수 있다면 개발이 더 쉬울 것이다.
    
    ⇒ **BOOTP**
    

# BOOTP : BOOTstrap Protocol (BOOTP)

- RARP 대체 가능
- 네트워크 계층에서 동작한다.
- UDP/IP 패킷을 이용해서 메시지를 전달한다.
- Host는 여전히 MAC Address를 통해 식별된다.
- 어떻게??
    - 255.255.255.255(limited broadcast ip address)를 이용한다.
        - 라우터에 의해 포워딩되지 않는다.
    - Host(요청자)가 IP주소를 획득하기 전까지 LAN을 통해 broadcast된다.
    - BOOTP 서버는 limited broadcast를 사용하여 응답한다.

# Dynamic Host Configuration Protocol

- DHCP는 BOOTP의 확장이다.
- 여전히 static allocation을 지원한다.
- DHCP에 의해 영구적인 주소를 부여하는 automatic configuration을 제공한다.
- 일시적 할당을 지원한다. (Supports temporary allocation)

## Dynamic Configuration

- BOOTP는 lookup table(static)의 MAC에 대응하는 IP주소를 반환한다.
- DHCP의 경우 IP테이블의 빈 공간을 Dynamic allocation을 통해 IP주소를 반환한다.

## DHCP 동작 절차

1. Host가 INITIALIZE 상태로 boot한다.
2. DHCP서버에 연결하기 위해 client는 DHCPDISCOVER message를 255.255.255.255를 이용해서 broadcast한다. 그리고 SELECT state로 전이한다.
    1. Unique header format, variable length option field
    2. UDP packet은 67번 포트를 이용한다.
3. 서버가 DHCPOFFER message를 통해 응답한다.
    1. Host는 하나 이상의 응답을 수신할 수 있으며, 그 중 하나에 대해 응답한다.
4. Client가 REQUEST state로 전이하고 1대의 서버로부터 IP를 받는다(lease, 임대)
    1. DHCPREQUEST 메시지를 서버로 보낸다. (서버는 DHCPACK 으로 응답한다.)
5. Client는 BOUND state(IDLE)로 전이한다.

출처 : [https://commons.wikimedia.org/wiki/File:Dhcp-client-state-diagram.svg](https://commons.wikimedia.org/wiki/File:Dhcp-client-state-diagram.svg)