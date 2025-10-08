
class read_item extends uvm_sequence_item;
        rand logic [7:0] rdata;
        rand logic rrst_n;
        rand logic rinc;
        logic rempty;
        `uvm_object_utils_begin(read_item)
                `uvm_field_int(rdata,UVM_ALL_ON);
                `uvm_field_int(rrst_n,UVM_ALL_ON);
                `uvm_field_int(rinc,UVM_ALL_ON);
                `uvm_field_int(rempty,UVM_ALL_ON);
        `uvm_object_utils_end
        function new(string name="read_item");
                super.new(name);
        endfunction
endclass
class write_item extends uvm_sequence_item;
        rand logic [7:0] wdata;
        rand logic wrst_n;
        rand logic winc;
        logic wfull;
        `uvm_object_utils_begin(write_item)
                `uvm_field_int(wdata,UVM_ALL_ON);
                `uvm_field_int(wrst_n,UVM_ALL_ON);
                `uvm_field_int(winc,UVM_ALL_ON);
                `uvm_field_int(wfull,UVM_ALL_ON);
        `uvm_object_utils_end
        function new(string name="write_item");
                super.new(name);
        endfunction
endclass
