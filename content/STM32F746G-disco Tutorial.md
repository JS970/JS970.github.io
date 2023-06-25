+++
title = "STM32F746G-disco Tutorial"
date = 2023-06-24
[taxonomies]
tags = ["TinyML"]
[extra]
author = "JS970"
katex= true
+++
> 본 글에서는 STM32F746G-disco 개발 보드를 이용하여 O'REILLY의 TinyML도서의 예제를 실행해 볼 것이다.

![TinyML Book](/image/TinyML/book.png)
### 준비물
- STM32F746G-disco(마이크로컨트롤러 개발보드)
- Make(builder) 3.8.2이상
- mercurial(파이썬 버전 에러(python@3.11) 발생 시 버전 5.9.3을 명시하면 해결됨)
- [Mbed CLI](https://os.mbed.com/docs/mbed-os/v6.16/introduction/index.html) - 운영 체제에 맞게 설치할 것, [macOS X](https://github.com/ARMmbed/mbed-cli-osx-installer/releases/tag/v0.0.10)
	- 아니면 `pip`을 통해 설치할 수도 있다.
		```bash
		pip install mbed-cli
		```
- ~~[STM32CubeIDE](https://www.st.com/en/development-tools/stm32-software-development-tools/products.html)(이클립스 베이스의 통합개발환경)~~
	- 본 책의 예제 실습에서는 사용되지 않는다.

### 개발 보드 테스트
- 새로운 프로젝트를 생성한 뒤 board select에서 STM32F746G-disco보드를 선택하고 Hello World예제를 실행시켜 보았다.![Hello World](/image/TinyML/helloWorld.png)

## 사인파 예측 모델 생성(Chapter 4)
---
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

## 애플리케이션 구축(Chapter 5)
---
### 모델 테스트
- [책의 코드](https://github.com/yunho0130/tensorflow-lite/tree/master/tensorflow/lite/micro/examples/hello_world)를 클론하여 진행했다.
- 아래는 책의 내용을 바탕으로 앞서 생성한 모델에 대해 테스트를 수행하는 코드를 분석한 것이다.
	```C, linenos
	#include "tensorflow/lite/micro/examples/hello_world/sine_model_data.h"
	#include "tensorflow/lite/micro/kernels/all_ops_resolver.h"
	#include "tensorflow/lite/micro/micro_error_reporter.h"
	#include "tensorflow/lite/micro/micro_interpreter.h"
	#include "tensorflow/lite/micro/testing/micro_test.h"
	#include "tensorflow/lite/schema/schema_generated.h"
	#include "tensorflow/lite/version.h"
	
	TF_LITE_MICRO_TESTS_BEGIN
	
	TF_LITE_MICRO_TEST(LoadModelAndPerformInference) {
	  // 로깅(logging)을 위한 객체 생성
	  tflite::MicroErrorReporter micro_error_reporter;
	  tflite::ErrorReporter* error_reporter = &micro_error_reporter;
	
	  // 모델을 사용 가능한 데이터 구조에 매핑한다.
	  // 복사, 파싱을 포함하지 않는 가벼운 작업이다.
	  const tflite::Model* model = ::tflite::GetModel(g_sine_model_data);
	  // 현재 사용중인 텐서플로 라이트 라이브러리의 버전과 
	  // 모델의 텐서플로 라이트 라이브러리의 버전에 대해 검사를 수행한다. 
	  // 버전이 일치하지 않아도 진행은 되지만 아래의 에러 메시지를 출력한다.
	  if (model->version() != TFLITE_SCHEMA_VERSION) {
	    TF_LITE_REPORT_ERROR(error_reporter,
	                         "Model provided is schema version %d not equal "
	                         "to supported version %d.\n",
	                         model->version(), TFLITE_SCHEMA_VERSION);
	  }
	
	  // 필요한 모든 operation 구현을 가져온다.
	  tflite::ops::micro::AllOpsResolver resolver;
	
	  // 입력, 출력, 중간 배열에 사용할 메모리 영역을 생성한다.
	  // 모델 최솟값을 찾으려면 시행착오가 필요하다.
	  // 이 메모리 영역은 모델의 입력, 출력, 중간 텐서를 저장하는 데 사용된다.
	  // 이 영역을 텐서 아레나(tensor_arena) 라고 부른다.
	  // 본 예제에서는 크기가 2048바이트인 배열을 할당했다.
	  const int tensor_arena_size = 2 * 1024;
	  uint8_t tensor_arena[tensor_arena_size];
	
	  // 모델을 실행하기 위한 인터프리터를 빌드한다. 
	  // 앞서 선언한 인스턴스가 파라미터로 사용되는 것을 확인할 수 있다.
	  tflite::MicroInterpreter interpreter(model, resolver, tensor_arena,
	                                       tensor_arena_size, error_reporter);
	
	  // 모델의 텐서에 대한 tensor_arena의 메모리를 할당한다.
	  TF_LITE_MICRO_EXPECT_EQ(interpreter.AllocateTensors(), kTfLiteOk);
	
	  // 모델의 입력 텐서에 대한 포인터 얻기
	  TfLiteTensor* input = interpreter.input(0);
	
	  // 입력이 예상하는 속성을 갖는지 확인
	  TF_LITE_MICRO_EXPECT_NE(nullptr, input);
	  // dims 속성은 텐서 모양을 알려준다. 각 차원마다 원소는 하나다.
	  // 입력은 한 개의 요소를 포함하는 2D 텐서이므로 dims의 크기는 2다.
	  TF_LITE_MICRO_EXPECT_EQ(2, input->dims->size);
	  // 각 원소의 값은 해당 텐서의 길이를 제공한다.
	  // 두 개의 단일 원소 텐서(하나가 다른 하나에 포함됨)를 갖는지 확인한다.
	  TF_LITE_MICRO_EXPECT_EQ(1, input->dims->data[0]);
	  TF_LITE_MICRO_EXPECT_EQ(1, input->dims->data[1]);
	  // 입력은 32비트 부동소수점 값이다.
	  TF_LITE_MICRO_EXPECT_EQ(kTfLiteFloat32, input->type);
	
	  // 입력값 텐서 제공
	  input->data.f[0] = 0.;
	
	  // 입력값으로 모델을 실행하고 성공 여부를 확인한다.
	  TfLiteStatus invoke_status = interpreter.Invoke();
	  TF_LITE_MICRO_EXPECT_EQ(kTfLiteOk, invoke_status);
	
	  // 모델의 출력 텐서에 대한 포인터를 얻는다.
	  // 입력 텐서의 경우와 마찬가지로 예상되는 속성을 갖는지 확인한다.
	  TfLiteTensor* output = interpreter.output(0);
	  TF_LITE_MICRO_EXPECT_EQ(2, output->dims->size);
	  TF_LITE_MICRO_EXPECT_EQ(1, input->dims->data[0]);
	  TF_LITE_MICRO_EXPECT_EQ(1, input->dims->data[1]);
	  TF_LITE_MICRO_EXPECT_EQ(kTfLiteFloat32, output->type);
	
	  // 텐서의 출력값을 획득
	  float value = output->data.f[0];
	  // 출력값과 예상 값의 차이가 0.05범위에 있는지 확인
	  TF_LITE_MICRO_EXPECT_NEAR(0., value, 0.05);
	
	  // 모델이 작동하고 있음을 추가로 검증하기 위해 3회의 추론을 더 실행한다.
	  // 추론 - 1
	  input->data.f[0] = 1.;
	  invoke_status = interpreter.Invoke();
	  TF_LITE_MICRO_EXPECT_EQ(kTfLiteOk, invoke_status);
	
	  value = output->data.f[0];
	  TF_LITE_MICRO_EXPECT_NEAR(0.841, value, 0.05);
	
	  // 추론 - 2
	  input->data.f[0] = 3.;
	  invoke_status = interpreter.Invoke();
	  TF_LITE_MICRO_EXPECT_EQ(kTfLiteOk, invoke_status);
	
	  value = output->data.f[0];
	  TF_LITE_MICRO_EXPECT_NEAR(0.141, value, 0.05);
	
	  // 추론 - 3
	  input->data.f[0] = 5.;
	  invoke_status = interpreter.Invoke();
	  TF_LITE_MICRO_EXPECT_EQ(kTfLiteOk, invoke_status);
	
	  value = output->data.f[0];
	  TF_LITE_MICRO_EXPECT_NEAR(-0.959, value, 0.05);
	}
	
	TF_LITE_MICRO_TESTS_END
	```
- 이 코드는 결국 마이크로컨트롤러에서 실행되도록 설계되었지만 개발 시스템에서 테스트를 빌드하고 실행하는 것 역시 가능하다.
	- 이를 통해 코드 작성과 디버깅이 훨씬 쉬워진다.
	- PC는 마이크로컨트롤러와 비교하여 출력을 로깅하고 코드를 검토하기에 훨씬 편리하므로 효율이 좋다.
- Make를 사용하여 테스트를 실행한 결과는 아래와 같다.![test](/image/TinyML/test.png)

### 모델 적용하기
> 프로젝트 파일 구조는 아래와 같다.
- `constants.h`, `constants.cc` : 프로그램 동작을 정의하는 데 중요한 영향을 미치는 다양한 상수를 포함하는 파일
- `main.cc` : 애플리케이션의 메인 함수
	```C, linenos
	#include "tensorflow/lite/micro/examples/hello_world/main_functions.h"
	// standard C entry point를 준수하는 시스템의 default main 함수이다.
	// FreeRTOS, ESP32등 다른 requirements를 요구하는 기기의 경우 그에 맞게 구조를 변경해야 한다.
	int main(int argc, char* argv[]) {
	  setup();
	  while (true) {
	    loop();
	  }
	}
	```
- `main_functions.h`, `main_functions.cc` : 프로그램에 필요한 모든 초기화를 수행하는 `setup()`함수와 프로그램의 핵심 로직을 포함하고 루프를 순회하면서 상태 머신을 구동하도록 설계된 `loop()`함수를 정의하는 파일 쌍이다. 이 함수들은 프로그램이 시작될 때 `main.cc`에 의해 호출된다.
	```C, linenos
	#include "tensorflow/lite/micro/examples/hello_world/main_functions.h"
	#include "tensorflow/lite/micro/examples/hello_world/constants.h"
	#include "tensorflow/lite/micro/examples/hello_world/output_handler.h"
	#include "tensorflow/lite/micro/examples/hello_world/sine_model_data.h"
	#include "tensorflow/lite/micro/kernels/all_ops_resolver.h"
	#include "tensorflow/lite/micro/micro_error_reporter.h"
	#include "tensorflow/lite/micro/micro_interpreter.h"
	#include "tensorflow/lite/schema/schema_generated.h"
	#include "tensorflow/lite/version.h"
	
	// main_functions.cc 내에서 사용할 전역 변수를 설정한다.
	// main_functions.cc 내에서는 어느 곳에서나 접근할 수 있다.
	// 프로젝트 내의 다른 파일에서는 접근할 수 없다.
	// 이러한 선언을 통해 두 개의 서로 다른 파일이 동일한 이름의 변수를 정의하여
	// 발생 가능한 문제를 방지할 수 있다.
	namespace {
	tflite::ErrorReporter* error_reporter = nullptr;
	const tflite::Model* model = nullptr;
	tflite::MicroInterpreter* interpreter = nullptr;
	TfLiteTensor* input = nullptr;
	TfLiteTensor* output = nullptr;
	int inference_count = 0;
	
	// 입력, 출력, 중간 배열에 사용할 메모리 영역을 생성한다.(텐서 아레나)
	constexpr int kTensorArenaSize = 2 * 1024;
	uint8_t tensor_arena[kTensorArenaSize];
	}  // namespace
	
	// 프로그램이 처음 시작될 때 호출되고 그 이후로는 호출되지 않는다.
	// 추론을 시작하기 전에 수행해야 하는 모든 일회성 작업을 수행하기 위해 필요하다.
	// 로깅을 설정하고, 모델을 로드하며, 인터프리터를 설정하고 메모리를 할당한다.
	void setup() {
	  // 로깅(logging) 설정
	  static tflite::MicroErrorReporter micro_error_reporter;
	  error_reporter = &micro_error_reporter;
	
	  // 모델을 사용 가능한 데이터 구조에 매핑한다.
	  model = tflite::GetModel(g_sine_model_data);
	  if (model->version() != TFLITE_SCHEMA_VERSION) {
	    TF_LITE_REPORT_ERROR(error_reporter,
	                         "Model provided is schema version %d not equal "
	                         "to supported version %d.",
	                         model->version(), TFLITE_SCHEMA_VERSION);
	    return;
	  }
	
	  // 필요한 모든 Operator(Op)구현을 가져온다.
	  static tflite::ops::micro::AllOpsResolver resolver;
	
	  // 모델을 실행할 인터프리터를 빌드한다.
	  static tflite::MicroInterpreter static_interpreter(
	      model, resolver, tensor_arena, kTensorArenaSize, error_reporter);
	  interpreter = &static_interpreter;
	
	  // 모델 텐서를 텐서 아레나의 메모리에 할당한다.
	  TfLiteStatus allocate_status = interpreter->AllocateTensors();
	  if (allocate_status != kTfLiteOk) {
	    TF_LITE_REPORT_ERROR(error_reporter, "AllocateTensors() failed");
	    return;
	  }
	
	  // 입력 텐서, 출력 텐서에 대한 포인터를 획득한다.
	  // 아직 출력이 작성되지 않았지만 메모리 영역 자체는 존재하기 때문에 이런 식의 초기화도 문제없다. 
	  input = interpreter->input(0);
	  output = interpreter->output(0);
	
	  // 추론을 실행할 횟수를 기록하기 위한 변수
	  inference_count = 0;
	}
	
	// 애플리케이션 로직이 구현된 부분이다. 
	void loop() {
	  // 모델에 공급할 x값을 계산한다.
	  // 현재 inference_count를 주기당 추론 횟수와 비교하여
	  // 모델이 학습된 지정 가능한 x값 범위 내에서 위치를 결정하고
	  // 이를 사용하여 값을 계산한다.
	  float position = static_cast<float>(inference_count) /
	                   static_cast<float>(kInferencesPerCycle);
	  float x_val = position * kXrange;
	
	  // 계산한 x값을 모델의 입력 텐서에 넣기
	  input->data.f[0] = x_val;
	
	  // 추론을 실행하고 오류가 있다면 error report를 발생시킨다.
	  TfLiteStatus invoke_status = interpreter->Invoke();
	  if (invoke_status != kTfLiteOk) {
	    TF_LITE_REPORT_ERROR(error_reporter, "Invoke failed on x_val: %f\n",
	                         static_cast<double>(x_val));
	    return;
	  }
	
	  // 모델의 출력 텐서가 예상한 y값 읽기
	  float y_val = output->data.f[0];
	
	  // 결과를 출력한다. 개발 보드에 맞춰 HandleOutput 함수를 커스텀 구현할 수 있다.
	  HandleOutput(error_reporter, x_val, y_val);
	
	  // Inference_counter를 증가시키고 사이클당 최대 추론 수에 도달하면 리셋
	  inference_count += 1;
	  if (inference_count >= kInferencesPerCycle) inference_count = 0;
	}
	```
- `output_handler.h`, `output_handler.cc` : 추론이 실행될 때마다 출력을 표시하는 데 사용할 수 있는 함수를 정의하는 파일, 기본 구현은 결과를 화면에 출력한다. 이 구현을 재정의하면 다른 장치에서 다른 작업을 수행할 수 있다.
- `sine_model_data.h`, `sine_model_data.cc` : Tensorflow Lite for Microcontroller를 통해 변환된 기계학습 모델이다.

## STM32F746G-disco에 배포하기(Chapter 6)
---
> LCD를 사용할 예정이므로 output_hanlder를 수정해 주어야 한다.
- `LCD_DISCO_F746NG.h`, `LCD_DISCO_F746NG.cc`가 필요하다. [여기](https://os.mbed.com/teams/ST/code/LCD_DISCO_F746NG/)에서 다운로드 받을 수 있다.
	- 제공되는 파일은 `.cpp`파일이긴 하지만 본질적으로 `.cc`와 `.cpp` 는 아무 차이가 없다.
- 본 예제는 Makefile을 제공하여 Mbed 프로젝트를 자동으로 생성할 수 있다.
	```bash
	make -f tensorflow/lite/micro/tools/make/Makefile \ TARGET=mbed TAGS="CMSIS disco_f746ng" generate_hello_world_mbed_project
	```
- 아래 폴더로 이동한다.
	```bash
	cd tensorflow/lite/micro/tools/make/gen/mbed_cortex-m4/prj/hello_world/mbed
	```
- `mbed`명령어를 프로그램의 루트 디렉터리를 설정한다.
	```bash
	mbed config root .
	```
- 종속성을 다운로드한다.
	```bash
	mbed deploy
	```
- 기본적으로 Mbed는 C++98을 사용하여 프로젝트를 빌드한다. 그러나 텐서플로 라이트에는 C++11이 필요하므로 아래의 코드를 실행하여 C++11을 사용하도록 Mbed 설정 파일을 수정해야 한다.
	```bash
	python -c 'import fileinput, glob;
		for filename in glob.glob("mbed-os/tools/profiles/*.json"):
			for line in fileinput.input(filename, inplace=True):
			    print(line.replace("\"-std=gnu++98\"","\"-std=c++11\", \"-fpermissive\""))'
	```
- 아래 명령을 실행하여 컴파일을 수행한다.
	```bash
	mbed compile -m DISCO_F746NG -t GCC_ARM
	```
	- 파이썬 버전 문제(계속 homebrew의 python@3.11이 인식되어 에러가 발생했다, 삭제하여 해결함), 각종 dependency문제, 허가되지 않은 개발자 문제 등등 다양한 이슈가 있어 매끄럽게 진행되지는 못했다.
		- 이유는 모르겠지만 계속 brew의 python을 가져온다... 이를 확인하는 명령어는 아래와 같다.
			```bash
			brew list | grep python
			```
		- 확인 결과 `python@3.11`이 설치되어 있다면... 잠시 삭제하자(vim등 다른 프로그램에 영향이 가지만 나중에 다시 깔면 된다.)
			```bash
			brew uninstall --ignore-dependencies python@3.11
			```
	- 아래 에러는 다음 markupsafe의 버전 문제로 발생하는 에러이다. 버전에 맞게 에러 이미지 아래의 명령어를 입력하면 해결된다.![ImportError](/image/TinyML/importerror.png)
		```bash
		pip install markupsafe==2.0.1
		```
- 아래는 컴파일이 완료된 화면이다.![Compile Complete](/image/TinyML/compile.png)
- 컴파일되어 생성된 바이너리 파일은 ./BUILD/DISCO_F746NG/GCC_ARM/mbed.bin에 있다.
- 아래 명령어를 입력하여 보드에 배포한다.(그냥 복사하면 된다)
	```bash
	cp ./mbed.bin /Volumes/DIS_F746NG
	```
- 아래는 바이너리 파일을 보드에 배포한 후 프로그램이 실행되는 모습이다.[![sine example](https://www.youtube.com/watch?v=yCAvoseXeo8)](https://www.youtube.com/watch?v=yCAvoseXeo8)
