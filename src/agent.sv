class wagent extends uvm_agent;
        `uvm_component_utils(wagent)
        wdriver wdrv;
        wmonitor wmon;
        wsequencer wsqr;
        function new(string name,uvm_component parent);
                super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(get_is_active==UVM_ACTIVE)begin
                        wdrv=wdriver::type_id::create("wdrv",this);
                        wsqr=wsequencer ::type_id::create("wsqr",this);
                end
                wmon=wmonitor::type_id::create("wmon",this);
        endfunction
        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                wdrv.seq_item_port.connect(wsqr.seq_item_export);
//              wmon.wmon_port.connect(
        endfunction

endclass
class ragent extends uvm_agent;
        `uvm_component_utils(ragent)
        rdriver rdrv;
        rmonitor rmon;
        rsequencer rsqr;
        function new(string name,uvm_component parent);
                super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(get_is_active==UVM_ACTIVE)begin
                        rdrv=rdriver::type_id::create("rdrv",this);
                        rsqr=rsequencer ::type_id::create("rsqr",this);
                end
                rmon=rmonitor::type_id::create("rmon",this);
        endfunction
        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                rdrv.seq_item_port.connect(rsqr.seq_item_export);
        endfunction

endclass
