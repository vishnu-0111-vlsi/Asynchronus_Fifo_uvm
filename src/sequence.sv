class write_seq extends uvm_sequence;
        `uvm_object_utils(write_seq)
        write_item witem;
        function new(string name="write_seq");
                super.new(name);
        endfunction
        task body();
                witem=write_item::type_id::create("witem");
          repeat(30)begin
                wait_for_grant();
                assert(witem.randomize() with{ wrst_n==0;winc==1;});
                send_request(witem);
                wait_for_item_done();
                end
        endtask
endclass
class read_seq extends uvm_sequence;
        `uvm_object_utils(read_seq)
        read_item ritem;
        function new(string name="read_seq");
                super.new(name);
        endfunction
        task body();
                ritem=read_item::type_id::create("ritem");
                repeat(10)begin
                wait_for_grant();
                        assert(ritem.randomize()with {rrst_n==0;rinc==1;});
                send_request(ritem);
                wait_for_item_done();
                end
        endtask
endclass
class virtual_seq extends uvm_sequence;
        `uvm_object_utils(virtual_seq)
        `uvm_declare_p_sequencer(fifo_sequencer)
        read_seq rseq;
        write_seq wseq;
        fifo_sequencer vsqr;
        function new(string name="virtual_seq");
                super.new(name);
        endfunction
        task body();
                rseq=read_seq::type_id::create("rseq");
                wseq=write_seq::type_id::create("wseq");
                fork
                        rseq.start(p_sequencer.rsqr);
                        wseq.start(p_sequencer.wsqr);
                join
        endtask
endclass
