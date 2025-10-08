
interface intf(input bit wclk,rclk);
        logic[7:0] wdata;
        logic winc;
        logic wfull,wrst_n;
        logic[7:0] rdata;
        logic rinc,rrst_n;
        logic rempty;
        clocking wmonitor_cb@(posedge wclk);
                default input#0 output#0;
                input wdata;
                input winc;
                input wrst_n;
                input wfull;
        endclocking
        clocking wdriver_cb@(posedge wclk);
                default input#0 output#0;
                output wdata;
                output winc;
                output wrst_n;
        endclocking
        clocking rmonitor_cb@(posedge rclk);
                default input#0 output#0;
                input rdata;
                input rinc;
                input rrst_n;
                input rempty;
        endclocking
        clocking rdriver_cb@(posedge rclk);
                default input#0 output#0;
                output rinc;
                output rrst_n;
        endclocking
endinterface
