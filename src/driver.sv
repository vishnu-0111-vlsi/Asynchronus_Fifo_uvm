class  rdriver extends uvm_driver#(read_item);
        `uvm_component_utils(rdriver)
        virtual intf vif;
        read_item req;
        function new(string name,uvm_component parent);
                super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
                $error("In rdriver interface not recieved");
        endfunction
        task run_phase(uvm_phase phase);
                req=read_item::type_id::create("req");
                forever begin
                seq_item_port.get_next_item(req);
                read_drive();
                seq_item_port.item_done();
                end
        endtask
        task read_drive();
                @(vif.rdriver_cb);
                vif.rinc<=req.rinc;
                vif.rrst_n<=req.rrst_n;
        endtask
endclass
class  wdriver extends uvm_driver#(write_item);
        `uvm_component_utils(wdriver)
        virtual intf vif;
        write_item wreq;
        function new(string name,uvm_component parent);
                super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
                $error("In wdriver interface not recieved");
        endfunction
        task run_phase(uvm_phase phase);
                wreq=write_item::type_id::create("wreq");
                forever begin
                seq_item_port.get_next_item(wreq);
                write_drive();
                seq_item_port.item_done();
                end
        endtask
        task write_drive();
          		@(vif.wdriver_cb);
                vif.winc<=wreq.winc;
                vif.wrst_n<=wreq.wrst_n;
                vif.wdata<=wreq.wdata;
        endtask

endclass
