# DDS Tutorial

DDS Compiler는 Direct Digital Synthesis (DDS) 기술을 FPGA에서 구현하기 위해 제공되는 Xilinx의 IP 코어입니다. DDS는 신호 생성 방식으로, 특정한 주파수와 위상의 디지털 신호를 계산적으로 빠르고 효율적으로 생성할 수 있습니다. 

[DDS Compiler v6.0에 대한 Xilinx의 공식 문서 참고.](https://docs.amd.com/r/en-US/pg141-dds-compiler)



## Phase Increment Programmability 옵션

이 옵션은 DDS의 **Phase Increment** 값을 어떻게 제공할지 결정하는 옵션 입니다. Phase Increment 값은 출력 주파수를 결정하는 데 중요한 파라미터이며, DDS의 출력 주파수는 아래 공식을 따릅니다:


$$
f_{\text{out}} = \frac{\text{(Phase Increment Value)} \times f_{\text{clk}}}{2^N}
$$

$$
\text{Phase Increment Value} = \frac{f_{\text{out}} \times 2^N}{f_{\text{clk}}}
$$

**Fixed**: 고정된 Phase Increment 값을 사용.

**Programmable**: 동적으로 Phase Increment 값을 설정할 수 있음.

**Streaming**: 스트리밍 데이터로 Phase Increment 값을 실시간으로 제공.



### Programmable

**programmable**을 선택하면 DDS가 **S_AXIS_CONFIG** 포트를 통해 Phase Increment 값을 동적으로 설정 할 수 있다. 이 옵션의 특징은 아래와 같다

- **S_AXIS_CONFIG 포트 기능**:

  - AXI4-Stream 인터페이스를 사용하여 Phase Increment 값을 설정.

  - 새로운 Phase Increment 값을 적용하면, DDS의 출력 주파수가 변경됨.

  - 동적으로 주파수를 변경할 필요가 있을 때 유용 (예: 주파수 스위칭).

- **구조**:
  - **S_AXIS_CONFIG 데이터 구조**는 일반적으로 Phase Increment 값과 다른 설정을 포함할 수 있다. 데이터의 폭(bit-width)은 DDS 설정에 따라 달라진다. 

- **사용 예**:
- 하나의 DDS 출력으로 여러 주파수를 생성해야 하는 경우.
  
- 실시간으로 동작 주파수를 조정해야 하는 RF 또는 통신 시스템.



### Streaming

**Streaming**을 선택하면 DDS가 **S_AXIS_PHASE** 포트를 통해 **실시간 Phase Increment** 값을 스트리밍 데이터로 받아온다. 이 옵션은 Programmable과 몇 가지 중요한 차이점이 있다:

- **S_AXIS_PHASE 포트 기능**:
  - 매 클럭마다 새로운 Phase Increment 값을 제공할 수 있음.
  - 완전 실시간 스트리밍 동작이 가능.
  - 동적으로 변하는 Phase Increment 값을 적용할 수 있어 **FM(주파수 변조)** 또는 **FSK(주파수 천이 변조)** 같은 응용에 적합.
- **구조**:
  - **S_AXIS_PHASE 데이터 구조**는 Programmable에서 사용하는 S_AXIS_CONFIG보다 간단하며, 주로 Phase Increment 값 자체를 전달.
  - 데이터는 지속적으로 클럭에 따라 업데이트되며, 시스템의 동기화가 중요함.
- **사용 예**:
  - 신호 합성에서 주파수가 시간에 따라 지속적으로 변하는 경우.
  - 디지털 통신에서 빠르게 변조된 신호를 생성할 때.



