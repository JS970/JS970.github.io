+++
title = "Special IP & NAT"
date = 2022-10-20
[taxonomies]
tags = ["Computer Network"]
[extra]
author = "JS970"
+++
## 4 special IP address

- Multicast IP address → class D
- Broadcast IP address
    - 255.255.255.255(broadcast on LAN)
    - 164.125.255.255(broadcast on distance network)

<aside>
⚠️ **broadcast 는 L2 broadcast와 L3 broadcast가 있다**
- L2 broadcast : destination MAC address가 ff:ff:ff:ff:ff:ff
→ 로컬 네트워크의 모든 노드에게 이 프레임을 전송한다. 스위치는 이 프레임을 보는 즉시 모든 인터페이스를 통해 이 프레임을 흘려보낸다.(flood)
- L3 broadcast : destination IP address가 특별한 값을 가진다.
→ 255.255.255.255의 IP주소를 목적지 IP주소로 설정한다면 LAN의 라우터를 포함한 모든 노드로 패킷을 전송한다. 또한, 이 경우에는 dst MAC address가 ff:ff:ff:ff:ff:ff임을 확인할 수 있다. 이는 L2 broadcast가 동시에 진행됨을 의미한다.

</aside>

<aside>
⚠️ **direct broadcast**
10.11.22.0/24 네트워크에서 direct broadcast를 위한 IP 주소는 10.11.22.255이다.
이 주소로 broadcast를 시도하면 위의 255.255.255.255(local broadcast)와 같은 동작을 한다.
마찬가지로 이 경우에도 destination MAC은 ff:ff:ff:ff:ff:ff이다. 
하지만 위의 경우와 다르게, 이렇게 direct broadcast를 시도하면 와이어샤크 등 패킷 캡쳐 프로그램은 이를 broadcast로 인식하지 못한다.(/24 mask가 있는 네트워크인지 알 방법이 없으므로)
같은 역할을 하는 것 처럼 보이지만, direct broadcast를 사용할 경우 local뿐만이 아닌 broadcast on distance network가 가능하다.
direct broadcast를 이용한 distance network로의 broadcast는 해당 네트워크의 netmask를 아는 라우터를 제외하고는 unicast로 인식되어 패킷이 전송된다. broadcast할 네트워크에서 netmask를 통해 broadcast되기 전까지는 unicast규칙을 따른다.

</aside>

[Local Broadcast vs Directed Broadcast - Practical Networking .net](https://www.practicalnetworking.net/stand-alone/local-broadcast-vs-directed-broadcast/)

- Loopback IP address
    - destination IP address : 127.0.0.1
    - destination IP address가 위와 같은 주소를 가진다면 loopback IP address이다.
    - 네트워크 계층에서는 데이터링크 계층 및 물리 계층으로 해당 패킷을 내려보내지 않고, 마치 자신이 다시 수신한 것 처럼 상위 계층(전송 계층, L4)으로 올려보낸다.
    - 서버/클라이언트 프로그램이 네트워크에 연결되지 않은 상태에서 디버깅하는 용도로 사용된다.
    - 시스템 자신을 의미하는 표현으로 내부적으로만 사용된다.
- Private/Public IP address
    - private IP :
        - 10.XX.YY.ZZ - class A
        - 192.168.XX.YY - class B
    - public IP :
        - 모두에게 열려 있다.
        - 동일한 IP주소가 존재할 수 없다.
    - 일반 사용자의 경우 하나의 public IP를 ISP(Internet Service Provider)로부터 구매한다.
    - public IP를 이용해 subnet을 구축하고, DHCP를 이용하여 private IP를 분배한다.
        
         ⇒ 라우터는 private IP로는 절대 포워딩하지 않는다.
        
         ⇒ 그렇다면 어떻게 private IP에 연결된 device에서 인터넷을 이용할 수 있는 것인가??
        
         ⇒ NAT(Network Address Translation)을 이용하여 가능하다.
        

## NAT(Network Address Translation)

![Untitled](/image/Special_IP&NAT/Untitled.png)

- ipv4는 $2^{32}$개의 주소 할당이 가능하다.
- 하지만 IoT의 시대로 접어들면서 이는 사실상 불가능해졌다.
- 이를 해결하기 위해 IPv6가 나왔으나 모든 기기에서 ipv4를 ipv6로 한번에 교체하는 것 역시 불가능하다.
- 이를 위해 NAT을 사용한다.
- NAT를 사용하여 다수의 private IP address를 하나의 public IP address로 변환하는 것이 가능.
- 내부망을 사용하는 PC에는 사설 IP를 부여하고, 외부망을 사용할 경우 하나의 public IP를 사용하는 형태로 운영 가능하다.
- NAT은 IP address 와 Port로 구성된 NAT forwarding table을 이용하여 이에 맞게 주소 변환 서비스를 제공한다.
- 동작 과정은 아래와 같다.
    1. outgoing packet이 NAT box를 거칠 때, packet의 original source ip address는 public ip address로 교체된다.
    2. TCP port는 65,536($2^{16}$)개의 NAT index로 replace된다. 이 과정은 서로 다른 호스트가 같은 포트를 사용할 수 있기 때문에 필수적이다. 이때 NAT index로 mapping되는 original ip address, original source port를 NAT테이블에 저장한다.
    3. ip, TCP header의 checksum을 다시 계산한다.
    4. ISP로부터의 packet이 NAT box로 돌아오면 헤더의 port를 읽어서 NAT box의 mapping table의 index로 사용한다.
    5. NAT box의 index를 통해 찾은 original IP address, original port number로 packet을 변경한다.
    6. ip, TCP header의 checksum을 다시 계산한다.
    7. 라우터를 통해 실제 서비스 요청 노드로 packet을 전송한다.

![Untitled](/image/Special_IP&NAT/Untitled%201.png)

### NAT 단점

- IP 는 connectionless한 특성을 가지지만 NAT는 connection oriented이다.
    
    → 복잡성을 증가시킨다.
    
- PORT를 사용하므로 TCP & UDP만 사용 가능하다.
- Maximum connection의 개수가 65535개로 제한된다(16 bits)
- 성능 감소(레이턴시)