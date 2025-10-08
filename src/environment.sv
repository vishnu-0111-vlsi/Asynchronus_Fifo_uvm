class environment extends uvm_env;
        `uvm_component_utils(environment)
        wagent wa;
        ragent ra;
        fifo_scoreboard sc;
        fifo_sequencer vsqr;
  		fifo_subscriber sub;
        function new(string name="environment",uvm_component parent=null);
                super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                wa=wagent::type_id::create("wa",this);
                ra=ragent::type_id::create("ra",this);
                sc=fifo_scoreboard::type_id::create("sc",this);
                vsqr=fifo_sequencer::type_id::create("vsqr",this);
         		sub=fifo_subscriber::type_id::create("sub",this);
        endfunction
        function void connect_phase(uvm_phase phase);
                wa.wmon.wmon_port.connect(sc.swport.analysis_export);
                ra.rmon.rmon_port.connect(sc.srport.analysis_export);
          		wa.wmon.wmon_port.connect(sub.wsub.analysis_export);
          		ra.rmon.rmon_port.connect(sub.rsub.analysis_export);
                //vsqr.wsqr=wa.wsqr;
                //vsqr.rsqr=ra.rsqr;
        endfunction
   		virtual function void write( t);
    		`uvm_info("SUBSCRIBER", $sformatf("Received transaction:\n%s", t.sprint()), UVM_LOW)
  		endfunction
endclass
