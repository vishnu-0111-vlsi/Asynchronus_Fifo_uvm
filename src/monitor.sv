class rmonitor extends uvm_monitor;
        `uvm_component_utils(rmonitor)
        uvm_analysis_port#(read_item) rmon_port;
        virtual intf vif;
        function new(string name,uvm_component parent);
                super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                rmon_port=new("rmon_port",this);
                if(uvm_config_db#(virtual intf)::get(this,"","vif",vif));
                else `uvm_fatal(get_type_name(),"Read monitor not recieved interface handle");
        endfunction
        task run_phase(uvm_phase phase);
                read_item ritem;
                @(vif.rmonitor_cb);
                 ritem=read_item::type_id::create("ritem");
                forever begin
                        @(vif.rmonitor_cb);
                        ritem.rdata=vif.rdata;
                        ritem.rinc=vif.rinc;
                        ritem.rrst_n=vif.rrst_n;
                        ritem.rempty=vif.rempty;
                        rmon_port.write(ritem);
                `uvm_info("READ_MON", $sformatf("READ_DATA : %0d | RINC : %0d | RRST_n : %0d  EMPTY  :  %0d",ritem.rdata, ritem.rinc, ritem.rrst_n,ritem.rempty), UVM_NONE)
        end
        endtask
endclass
class wmonitor extends uvm_monitor;
        `uvm_component_utils(wmonitor)
        uvm_analysis_port#(write_item) wmon_port;
        virtual intf vif;
        function new(string name,uvm_component parent);
                super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                wmon_port=new("wmon_port",this);
                if(uvm_config_db#(virtual intf)::get(this,"","vif",vif));
                else `uvm_fatal(get_type_name,"Read monitor not recieved interface handle");
        endfunction
        task run_phase(uvm_phase phase);
                write_item req;
          		@(vif.wmonitor_cb);
                //req=write_item::type_id::create("req");
                 forever begin
                        req=write_item::type_id::create("req");
                        @(vif.wmonitor_cb);
                        req.wdata=vif.wdata;
                        req.winc=vif.winc;
                        req.wrst_n=vif.wrst_n;
                        req.wfull=vif.wfull;
                        wmon_port.write(req);
                        $display("");
                `uvm_info("WRITE_MON", $sformatf("WRITE_DATA : %0d | WINC : %0d | WRST_n : %0d  FULL  :  %0d",req.wdata, req.winc, req.wrst_n,vif.wfull), UVM_NONE)
        end
        endtask
endclass
