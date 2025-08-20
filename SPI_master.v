module SPI_master (‬
‭ input sclk, //serial clock from master‬
‭ input [7:0] data_in,//data to be transmitted from master‬
‭ output reg [7:0] data_out, // Output for transmitted data from the slave‬
‭ input miso, // master in slave out‬
‭ output reg ss, //slave select active low‬
‭ input ss_initiate, // transmission signal from master‬
‭ output reg mosi // master out slave in‬
‭ );‬
‭ reg [7:0] i;‬
‭ reg [7:0] j;‬
‭ initial begin‬
‭ i<=0;‬
‭ j<=0;‬
‭ ss<=1'b1;//deselect slave‬
‭ end‬
‭ always @(posedge sclk ) begin‬
‭ if (ss_initiate==1 && i<8 && j<8) begin‬
‭ // Shift out data bit by bit (if the transmission is ongoing)‬
‭ //Increment‬
‭ ss<=1'b0; // select slave‬
‭ mosi<=data_in[i]; // shifting data on MOSI line‬
‭ data_out[j]<=miso; // shifting via MISO line‬
‭ i<=i+1;‬
‭ j<=j+1;‬
‭ end else begin‬
‭ // Transmission complete‬
‭ i<=0;‬
‭ j<=0;‬
‭ ss<=1'b1; //deselect slave‬
‭ // Set to high impedance‬
‭ mosi <= 1'bZ;‬
‭ data_out<= 1'bZ;‬
‭ end‬
‭ end‬
‭ endmodule‬
‭
