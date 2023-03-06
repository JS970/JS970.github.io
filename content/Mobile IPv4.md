+++
title = "Mobile IPv4"
date = 2022-11-08
[taxonomies]
tags = ["Computer Network"]
[extra]
author = "JS970"
+++

## Mobile IPv4 issue

![Untitled](/Mobile_IPv4/Untitled.png)

- Host #1과 Host #2가 Network #1에 속해있을 때는 둘 사이에 통신이 가능하다.
- Host #1이 Network #2로 이동하였을 경우 Host #2는 Host #1에게 라우터를 거쳐서만 통신할 수 있다.
- 문제는 Host #1이 Network #2로 이동하였을 때의 IP를 Host #2가 알 방법이 없다는 것이다…
- IPv4는 고정 노드 대상의 유선 네트워크로 설계되었다. Mobility에 대해 고려되지 않았다.

![Untitled](/Mobile_IPv4/Untitled%201.png)

- 위 그림과 같은 상황에서 R1라우터의 라우팅 테이블에 R2, R3의 Net/Subnet ID가 모두 있다고 하더라도 A는 B의 이동해 대해 알 방법이 없다는 것이 문제이다.

## Solution?

![Untitled](/Mobile_IPv4/Untitled%202.png)

- 3rd party server를 이용하는 경우에는 A가 Net #1 에서 #2로 이동해도 서버가 사용자를 기억하기 때문에 always on connectivity(seamless connection)가 가능하다.

## HA(Home Agent), FA(Foregin Agent)

### CoA(Care of Address)

- 이동한 모바일 노드의 현재 위치
- CoA는 일반적으로 FA의 주소와 동일하다.

### HA

- 모바일 노드(MN)의 홈 주소와 같은 서브넷에 속한 라우터
- 원격 호스트가 MN에 패킷을 보낼 때 MN을 대신하여 작동한다.
- 원격 호스트로부터 패킷을 전송받으면 MN으로 향하는 패킷을 IP터널링을 통해 MN의 현재 위치로 전송한다.

### FA

- Host가 HA를 떠나 이동한 네트워크의 라우터
- HA에서 보낸 패킷을 수신하여 모바일 호스트에게 다시 전달하는 역할을 한다.

## Solution

- 구현에 관한 부분은 구현하는 개발자에게 달려 있다.
- MN의 상태(location, foreign network등)를 관리하는 것은 DB를 사용해도 되고 table을 사용해도 된다. 전적으로 “implementation issue”이다.

![Untitled](/Mobile_IPv4/Untitled%203.png)

### registration process

1. MN이 네트워크를 변경한다. HA → FA
    1. 이때 MN은 HA의 주소를 알고 있어야 한다.
2. MN은 FA로부터의 주기적인 advertisement messages를 listen한다.
3. 모바일 노드는 FA(이동한 네트워크의 라우터)에게 정보를 전송한다. (reply)
    1. FA에게 MN의 IP주소와 MAC주소를 알린다.
4. FA는 HA에게 CoA를 알린다.

### packet transmission (Host to HA)

1. MN으로 패킷을 보내려는 모든 호스트는 해당 노드의 홈 주소와 동일한 대상 주소로 패킷을 보낸다.
2. 정상적으로 IP 포워딩이 이루어진다면 해당 패킷을 HA로 도착한다.

### packet transmission (HA to MN)

1. HA는 proxy ARP기술을 이용하여 다른 노드가 MN으로 인식하도록 한다.
    1. HA는 ARP메시지에 자신의 IP주소가 아닌 MN의 IP주소를 삽입한다.
    2. 같은 네트워크의 다른 노드들은 MN의 IP와 HA의 MAC을 대응시킨다.
    3. 위의 과정을 통해 HA는 MN으로 향하는 패킷을 인터셉트한다.
2. HA는 IP터널링 기술을 이용하여 FA로 Host로부터 전송받은 패킷을 전송한다.
3. FA는 HA로부터 전송받은 패킷의 IP터널링용 헤더를 제거한다.
4. MN이 FA의 네트워크로 들어왔을 때 전송한 IP주소와 MAC주소를 바탕으로 HA로부터 전송받은 패킷을 MN으로 전송한다.

### IPv6?

- Mobile IPv6의 경우 FA의 동작 없이도 동작한다.