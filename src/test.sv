
class fifo_test extends uvm_test;
        `uvm_component_utils(fifo_test)
        environment env;
        write_seq wseq;
        //read_seq rseq;
        virtual_seq vseq;
        function new(string name="fifo_test",uvm_component parent=null);
                super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                env=environment::type_id::create("env",this);
        endfunction
        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                wseq=write_seq::type_id::create("wseq");
                //rseq=read_seq::type_id::create("rseq");
                //vseq=virtual_seq::type_id::create("vseq");
                //vseq.start(env.vsqr);
                wseq.start(env.wa.wsqr);
                phase.drop_objection(this);
        endtask

endclass
