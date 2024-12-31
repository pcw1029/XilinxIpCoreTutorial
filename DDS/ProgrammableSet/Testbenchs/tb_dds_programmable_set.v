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

module tb_dds_programmable_set();

reg aclk;
reg aresetn;
reg s_axis_config_tvalid;
reg [15 : 0] s_axis_config_tdata;
wire m_axis_data_tvalid;
wire [15 : 0] m_axis_data_tdata;

integer data_file;
integer data_count;
integer latency_counter; // DDS의 안정적인 출력을 위한 지연 카운터


// 신호 초기화 및 출력 파일 열기
initial begin
    aresetn = 1;
    s_axis_config_tvalid = 0;
    s_axis_config_tdata = 0;
    data_count = 0;
    latency_counter = 0;

    // 데이터를 기록할 파일 열기
    data_file = $fopen("dds_output_data.txt", "w");
    if (data_file == 0) begin
        $display("Error: 파일 열기에 실패했습니다.");
        $finish;
    end

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
    s_axis_config_tvalid = 1;
    s_axis_config_tdata = 16'd819; // 1 MHz 출력 주파수 설정
//    s_axis_config_tdata = 16'd12288; // 15 MHz 출력 주파수 설정
//    s_axis_config_tdata = 16'd24576; // 30 MHz 출력 주파수 설정
    @(posedge aclk);
    // 데이터 수집 완료 대기
    wait(data_count == 65536);
    s_axis_config_tvalid = 0; // 유효 신호 비활성화
    $fclose(data_file); // 파일 닫기
    $finish; // 시뮬레이션 종료
end

// 데이터 로깅: 안정적인 출력 후 데이터를 파일에 기록
always @(posedge aclk) begin
    if (m_axis_data_tvalid) begin
        // 안정적인 출력까지 대기 (latency 7 이후부터 기록)
        if (latency_counter < 7) begin
            latency_counter = latency_counter + 1;
        end else begin
            $fwrite(data_file, "%d\n", m_axis_data_tdata); // 데이터를 파일에 기록
            data_count = data_count + 1;

            // 65536개의 데이터 포인트가 수집되었는지 확인
            if (data_count == 65536) begin
                $display("데이터 수집 완료. 총 데이터 포인트: %d", data_count);
            end
        end
    end
end


// DDS Compiler 모듈 인스턴스화
dds_compiler_0 tb_dds_programmable_set (
  .aclk(aclk),                                  // input wire aclk
  .aresetn(aresetn),                            // input wire aresetn
  .s_axis_config_tvalid(s_axis_config_tvalid),  // input wire s_axis_config_tvalid
  .s_axis_config_tdata(s_axis_config_tdata),    // input wire [15 : 0] s_axis_config_tdata
  .m_axis_data_tvalid(m_axis_data_tvalid),      // output wire m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata)         // output wire [15 : 0] m_axis_data_tdata
);

endmodule

