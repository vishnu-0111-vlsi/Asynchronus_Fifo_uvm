
interface intf(input bit wclk,rclk);
        logic[7:0] wdata;
        logic winc;
        logic wfull,wrst_n;
        logic[7:0] rdata;
        logic rinc,rrst_n;
        logic rempty;
        bit [3:0]wptr,rptr;
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
        property p1;
                @(posedge wclk or posedge rclk)
                 ##7 !( $isunknown(wrst_n) || $isunknown(rrst_n) || $isunknown(winc) || $isunknown(rinc) ||
                           $isunknown(wdata) || $isunknown(rdata) || $isunknown(wfull) || $isunknown(rempty) );
        endproperty

        isunknown_signal_check_1:
        assert property(p1)
        $info("all the signals are known - Assertion 1 passed");
        else
        $error("Assertion 1 failed - all the signals are unknown");

        property p2;
                @(posedge wclk)
                  (!wrst_n && !winc) |-> !wfull ;
        endproperty

        write_reset_check_2:
        assert property(p2)
        $info("write_reset is valid - Assertion 2 passed");
        else
        $error("Assertion 2 failed - write_reset is invlaid");

        property p3;
                @(posedge rclk)
                  (!rrst_n && !rinc) |-> rempty ;
        endproperty

        read_reset_check_3:
        assert property(p3)
        $info("read_reset is valid - Assertion 3 passed");
        else
        $error("Assertion 3 failed - read_reset is invlaid");

        property p4;
                @(posedge wclk)
                 ##1 ( wrst_n && !winc) |-> ( wfull == $past(wfull,1)) ;
        endproperty

        wfull_stable_check_4:
        assert property(p4)
        $info("wfull is stable - Assertion 4 passed");
        else
        $error("Assertion 4 failed - wfull is unstable");

        property p5;
                @(posedge rclk)
         ##5 ( rrst_n && !rinc) |-> (( rdata == $past(rdata,1)));
        endproperty

        read_latch_check_5:
        assert property(p5)
        $info("read_latch is valid - Assertion 5 passed");
        else
        $error("Assertion 5 failed - read_latch is invlaid");

        property p6;
                @(posedge rclk)
         ( rrst_n && rinc) |-> ( rdata );
        endproperty

        data_valid_check_6:
        assert property(p6)
        $info(" rdata is valid - Assertion 6 passed");
        else
        $error("Assertion 6 failed - rdata is invlaid");

        property p7;
                @(posedge rclk)
         ##3 ( rrst_n && !rinc) |-> ( ( rempty == $past(rempty,1) ) );
        endproperty

        rempty_stable_check_7:
        assert property(p7)
        $info("rempty is stable - Assertion 7 passed");
        else
        $error("Assertion 7 failed - rempty is unstable");

        property p8;
                @(posedge wclk)
                //( ( ~write_ptr[3] == read_ptr[3] ) && ( write_ptr[2:0] == read_ptr[2:0] ) ) |-> ( wfull )  ;
                  ( write_ptr == `FIFO_DEPTH - 1 ) |-> ( wfull );
        endproperty

        is_wfull_check_8:
        assert property(p8)
        $info(" wfull is valid - Assertion 8 passed");
        else
        $error("Assertion 8 failed - wfull is invlaid");

        property p9;
                @(posedge rclk)
           ( write_ptr[3:0] == read_ptr[3:0] ) |-> ( rempty );
        endproperty

        is_rempty_check_9:
        assert property(p9)
        $info("rempty is valid - Assertion 9 passed");
        else
        $error("Assertion 9 failed - rempty is invlaid");

endinterface
