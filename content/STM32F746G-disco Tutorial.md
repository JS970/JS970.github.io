+++
title = "STM32F746G-disco Tutorial"
date = 2023-06-24
[taxonomies]
tags = ["env setting", "TinyML"]
[extra]
author = "JS970"
katex= true
+++
> 본 글에서는 STM32F746G-disco 개발 보드를 이용하여 O'REILLY의 TinyML도서의 예제를 실행해 볼 것이다.

![TinyML Book](/image/TinyML/book.png)
### 준비물
- STM32F746G-disco(마이크로컨트롤러 개발보드)
- [STM32CubeIDE](https://www.st.com/en/development-tools/stm32-software-development-tools/products.html)(이클립스 베이스의 통합개발환경)

### 개발 보드 테스트
- 새로운 프로젝트를 생성한 뒤 board select에서 STM32F746G-disco보드를 선택하고 Hello World예제를 실행시켜 보았다.![Hello World](/image/TinyML/helloWorld.png)

### 사인파 예측 모델 생성
- [책의 코드](https://colab.research.google.com/github/yunho0130/tensorflow-lite/blob/master/tensorflow/lite/micro/examples/hello_world/create_sine_model_ko.ipynb)를 직접 쳐 보면서 익혔다.
- 그래프를 그리는 코드, 양자화 모델을 검증하기 위한 코드, 파일 크기 측정을 위한 코드는 생략했다.
	```Python, linenos
	## 종속성 로드
	# TensorFlow는 오픈소스 라이브러리다.
	# 참조: 아래의 코드는 텐서플로우 2버전을 사용함.
	import tensorflow as tf
	print(tf.__version__)
	
	# 수학 연산에 필요한 Numpy
	import numpy as np
	
	# 그래프 생성에 필요한 Matplotlib
	import matplotlib.pyplot as plt
	
	# 파이썬의 수학 라이브러리
	import math
	
	## 데이터 생성하기
	
	# 아래의 값만큼 데이터 샘플을 생성한다.
	SAMPLES = 1000
	
	# 시드 값을 지정하여 이 노트북에서 실행할 때마다 다른 랜덤 값을 얻게 한다.
	# 어떤 숫자든 사용할 수 있다.
	np.random.seed(9730)
	
	# 사인파 진폭의 범위인 0-2π 내에서 균일하게 분포된 난수 집합을 생성한다.
	x_values = np.random.uniform(low=0, high=2*math.pi, size=SAMPLES)
	
	# 값을 섞어서 생성된 값들이 순서를 따르지 않도록 한다.
	np.random.shuffle(x_values)
	
	# 해당 사인값을 계산한다.
	y_values = np.sin(x_values)
	
	## 노이즈 추가
	# 사인 함수에 의해 직접 생성되었으므로 부드러운 곡선으로 나타난다. 
	# 그러나 머신 러닝 모델은 보다 복잡한 실제 데이터에서 패턴을 알아낼 수 있다. 
	# 이를 위해 데이터에 약간의 노이즈를 추가하여 보다 실제와 비슷한 데이터를 만들어 보자.
	# 본 단에서는 각 값에 임의의 노이즈를 추가한 다음 새 그래프를 그린다.
	
	# 각 y값에 임의의 작은 숫자를 추가한다.
	y_values += 0.1 * np.random.randn(*y_values.shape)
	
	## 데이터 분할
	# 실제 데이터와 비슷한 노이즈가 추가된 데이터 세트가 생성되었다.
	# 이 데이터는 모델의 훈련에 사용할 것이다.
	# 평가에 사용할 데이터를 확보하기 위해 훈련을 시작하기 전에 데이터를 분할하자.
	# vaildation data로 20%, test data로 20%, 나머지 60%은 training data로 분할하자.
	
	# 각 항목의 인덱스를 계산한다.
	TRAIN_SPLIT = int(0.6 * SAMPLES)
	TEST_SPLIT = int(0.2 * SAMPLES + TRAIN_SPLIT)
	
	# np.split을 사용하여 데이터를 세 부분으로 자른다.
	# np.split의 두 번째 인수는 데이터가 분할되는 인덱스 배열이며, 
	# 두 개의 인덱스를 사용하므로 데이터는 총 세 개의 덩어리로 나뉠 것이다.
	x_train, x_test, x_validate = np.split(x_values, (TRAIN_SPLIT, TEST_SPLIT))
	y_train, y_test, y_validate = np.split(y_values, (TRAIN_SPLIT, TEST_SPLIT))
	
	# 분할한 데이터를 합쳤을 때 원래의 사이즈와 같은지 재확인한다.
	assert(x_train.size + x_validate.size + x_test.size) == SAMPLES
	
	## 모델 설계
	# 입력값 x를 받아 출력값 sin(x)를 예측하는 모델을 만든다.
	# regression(회귀)을 사용하는 모델이다.
	# 먼저 두 개의 레이어를 정의하자. 
	# 첫 번째 레이어는 단일 입력(x값)을 가져와 16개의 뉴런을 통해 활성화된다.
	# 이 입력에 따라 각 뉴런은 내부 상태에 따라 어느 정도까지 활성화 된다.
	# 뉴런의 활성화 정도는 숫자로 표현된다.
	# 첫 번째 레이어의 활성화 정도는 두 번째 레이어에 입력으로 공급된다.
	# 이 입력에 자체 가중치와 바이어스를 적용하고 활성화 정도를 계산하여 y값으로 출력한다.
	
	# 간단한 모델 구조를 만들기 위해 케라스를 사용한다.
	from tensorflow.keras import layers
	model_2 = tf.keras.Sequential()
	
	# 첫 번째 레이어는 스칼라 입력을 받아 16개의 뉴런을 통해 전달하고,
	# 뉴런은 'relu' 활성화 함수에 따라 활성화 여부를 결정한다.
	model_2.add(layers.Dense(16, activation='relu', input_shape=(1,)))
	
	# 새로운 두 번째 레이어는 네트워크가 더 복잡한 표현을 배우는 데 도움을 준다.
	model_2.add(layers.Dense(16, activation='relu'))
	
	# 단일 값을 출력해야 하기 때문에 최종 레이어는 단일 뉴런으로 구성된다.
	model_2.add(layers.Dense(1))
	
	# 표준 옵티마이저 및 손실 함수를 사용하여 회귀 모델을 컴파일한다.
	model_2.compile(optimizer='rmsprop', loss='mse', metrics=['mae'])
	
	# 모델 훈련
	history_2 = model_2.fit(x_train, y_train, epochs=600, batch_size=16,
	                        validation_data=(x_validate, y_validate))
	
	# 테스트 데이터셋의 손실 계산 및 출력
	loss = model_2.evaluate(x_test, y_test)
	
	# 테스트 데이터셋 기반으로 예측
	predictions = model_2.predict(x_test)
	
	# 실제값에 대한 예측 그래프
	plt.clf()
	plt.title('Comparison of predictions and actual values')
	plt.plot(x_test, y_test, 'b.', label='Actual')
	plt.plot(x_test, predictions, 'r.', label='Predicted')
	plt.legend()
	plt.show()
	
	## TensorFlow Lite로 변환
	# 앞서 생성한 모델을 마이크로컨트롤러에 배포하기 위해 양자화를 수행한다.
	# 양자화를 통해 모델 가중치의 정밀도를 낮추어 정확도에 큰 영향을 미치지
	# 않으면서 메모리를 절약할 수 있다.
	# 양자화를 통해 모델 추론에 필요한 계산이 더 간단해지기 때문에 경량화 뿐만 아니라
	# 실행속도 역시 빨라진다.
	
	# 양자화하여 모델을 텐서플로우 라이트 형식으로 변환
	converter = tf.lite.TFLiteConverter.from_keras_model(model_2)
	converter.optimizations = [tf.lite.Optimize.OPTIMIZE_FOR_SIZE]
	tflite_model = converter.convert()
	
	# 모델 저장
	open("sine_model_quantized.tflite", "wb").write(tflite_model)
	```
- 위 프로그램을 실행시키면 tflite파일이 생성된다. 이를 마이크로컨트롤러에서 사용할 수 있도록 c언어로 변환해야 한다. 
- 아래 명령어를 입력하여 학습 모델을 cc파일로 변환한다.
	```bash
	xxd -i sine_modelquantized.tflite > sine_model_quantized.cc
	```
- c언어로 변환된 파일은 다음과 같다.![converted model](/image/TinyML/convertedModel.png)

