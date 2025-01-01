`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/31 09:57:11
// Design Name: 
// Module Name: tb_dds_programmable_set
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_dds_streaming_set();

reg aclk;
reg aresetn;
reg s_axis_phase_tvalid;
reg [15 : 0] s_axis_phase_tdata;
wire m_axis_data_tvalid;
wire [15 : 0] m_axis_data_tdata;

// 신호 초기화 및 출력 파일 열기
initial begin
    aresetn = 1;
    s_axis_phase_tvalid = 0;
    s_axis_phase_tdata = 0;
    
    @(posedge aclk);
    aresetn = 0; // 리셋 신호 활성화
    @(posedge aclk);
    aresetn = 1; // 리셋 신호 비활성화
end

// 클록 생성: 100 MHz 클록
initial begin
    aclk = 0;
    forever #6.25 aclk = ~aclk; // 6.25ns마다 클록 토글
end

// 설정 신호 생성 및 데이터 수집 완료 대기
initial begin
    #100; // 초기 지연
    @(posedge aclk);
    s_axis_phase_tvalid = 1;
    s_axis_phase_tdata = 16'd819; // 1 MHz 출력 주파수 설정
    #1000;
    @(posedge aclk);
    s_axis_phase_tdata = 16'd12288; // 15 MHz 출력 주파수 설정
    #1000;
    @(posedge aclk);
    s_axis_phase_tdata = 16'd24576; // 30 MHz 출력 주파수 설정
    #1000;
    @(posedge aclk);
    s_axis_phase_tvalid = 0; // 유효 신호 비활성화
    #10;    
    $finish; // 시뮬레이션 종료
end


// DDS Compiler 모듈 인스턴스화
dds_compiler_0 tb_dds_streaming_set (
  .aclk(aclk),                                  // input wire aclk
  .aresetn(aresetn),                            // input wire aresetn
  .s_axis_phase_tvalid(s_axis_phase_tvalid),  // input wire s_axis_phase_tvalid
  .s_axis_phase_tdata(s_axis_phase_tdata),    // input wire [15 : 0] s_axis_phase_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid),      // output wire m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata)         // output wire [15 : 0] m_axis_data_tdata
);

endmodule

