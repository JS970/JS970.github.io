+++
title = "Mbed-CLI"
date = 2023-07-16
[taxonomies]
tags = ["TinyML"]
[extra]
author = "JS970"
katex= true
+++
## Digital Camera Interface(DCMI)란?
---
> The digital camera is a synchronous parallel interface able to receive a high-speed data flow from an external 8, 10, 12 or 14 bit CMOS camera module. It supports different data formats(YCbCr4:2:2/RGB565 progressive video, JPEG). This interface is for use with black & white cameras(also X24, X5) and it is assumed that all preprocessing like resizing is performed in the camera module.
- 디지털 카메라는 외장 8, 10, 12, 14비트 CMOS Camera module로부터 high-speed data flow를 수신 가능한 동기식 병렬 인터페이스이다.
- YCbCr4:2:2/RGB565 progressive video, JPEG포멧을 지원한다.
- 이 인터페이스는 흑백 카메라, X24, X5등의 카메라에 사용되며, 크기 조정과 같은 모든 전처리 과정은 카메라 모듈에서 수행된다고 가정한다.

### 추가 정보
- `CMOS` : Complementary Metal-Oxide-Semiconductor, 일반적으로 디지털 카메라 센서, 메모리 칩, 마이크로프로세서 등에서 널리 사용된다. 빛을 전기 신호로 변환하는 기능을 가지고 있으며, 이 신호는 카메라 사용자가 사진이나 동영상을 볼 수 있도록 한다. 즉 그냥 디지털 카메라의 이미지 센서를 의미한다고 생각하면 된다.
- STM32보드에서는 2017년에 DCMI인터페이스가 소개되기 전까지 카메라 사용에 문제가 있었지만, Aruducam에서 제공하는 SPI카메라 모듈을 이용하여 카메라의 사용이 가능하기는 하다.
	- [SPI camera](https://www.arducam.com/spi-camera-modules-for-all-stm32-boards/)

## DCMI functional overview
---
> The digital camera interface is a synchronous parallel interface that can receive high-speed(up to 54 Mbytes/s) data flows. It consists of up to 14 data lines and a pixel clock line. The pixel clock has a programmable polarity, so that data can be captured on either the rising or the falling edge of the pixel clock.
> The data are packed into a 32-bit data register(DCMI_DR) and then transferred through a general-purpose DMA channel. The image buffer is managed by the DMA, not by the camera interface.
> The data received from the camera can be organized in lines/frames or can be a sequence of JPEG images. To enable JPEG image reception, the JPEG bit must be set.
> The data flow is synchronized either by hardware using the optional DCMI_HSYNC and DCMI_VSYNC signals or by synchronization codes embedded in the data flow.