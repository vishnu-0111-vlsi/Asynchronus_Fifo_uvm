class fifo_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(fifo_scoreboard)
        uvm_tlm_analysis_fifo#(read_item) srport;
        uvm_tlm_analysis_fifo#(write_item)swport;
        //read_item ritem_a,ritem_ref;
        //write_item witem_a,witem_ref;
        static bit full,empty;
        static int wptr,rptr;
        int q[$:16];
        function new(string name,uvm_component parent);
                super.new(name,parent);
                srport=new("srport",this);
                swport=new("swport",this);
        endfunction
        task run_phase(uvm_phase phase);
        read_item ritem,rref;
        write_item witem,wref;
//         ritem_a=read_item::type_id::create("ritem");
//         witem_a=write_item::type_id::create("witem");
//         ritem_ref=read_item::type_id::create("ritem_ref");
//         witem_ref=write_item::type_id::create("witem_ref");
          fork
            begin
            forever begin
           witem = write_item::type_id::create("witem");
          swport.get(witem);               // blocking until a write arrives
          wref = write_item::type_id::create("wref");
          wcopy(witem, wref);
              write_do(q, wref, witem);
        end
      end
      begin : READ_TASK
        forever begin
          ritem = read_item::type_id::create("ritem");
          srport.get(ritem);               // blocking until a read arrives
          rref = read_item::type_id::create("rref");
          rcopy(ritem, rref);
          read_do(q, rref, ritem);
        end
      end
          join_none
        endtask
        task wcopy(write_item aitem,write_item refitem);
                refitem.wdata=aitem.wdata;
                refitem.wrst_n=aitem.wrst_n;
                refitem.winc=aitem.winc;
//                 `uvm_info(get_type_name(), $sformatf("ref WRITE_DATA : %0d | WINC : %0d | WRST_N  :  %0d",refitem.wdata, refitem.winc, refitem.wrst_n), UVM_NONE)
//                 `uvm_info(get_type_name(), $sformatf("actual WRITE_DATA : %0d | WINC : %0d | WRST_N :  %0d",aitem.wdata, aitem.winc, aitem.wrst_n), UVM_NONE)

        endtask
        task rcopy(read_item aitem,read_item refitem);
                refitem.rrst_n=aitem.rrst_n;
                refitem.rinc=aitem.rinc;
                //`uvm_info(get_type_name(), $sformatf("ref  RINC : %0d | RRST_n : %0d", refitem.rinc, refitem.rrst_n), UVM_NONE)
        //`uvm_info(get_type_name(), $sformatf("actual RINC : %0d | RRST_n : %0d ", aitem.rinc, aitem.rrst_n), UVM_NONE)

        endtask

        task write_do(ref int q[$:16], write_item item, write_item aitem);
          if(q.size()==16)item.wfull=1;
           else item.wfull=0;
                if (!item.wfull && item.winc && !item.wrst_n)begin
                        q.push_back(item.wdata);
                        wptr++;
                        $display("wptr=%0d size=%0d",wptr,q.size());
                end
          if(item.wfull==aitem.wfull)begin
              `uvm_info(get_type_name(),"Matched",UVM_DEBUG);
          end
          `uvm_info(get_type_name(), $sformatf("ref WRITE_DATA : %0d | WINC : %0d | WRST_N  :  %0d  | WFULL:%0d",item.wdata, item.winc, item.wrst_n,item.wfull), UVM_NONE);
          `uvm_info(get_type_name(), $sformatf("actual WRITE_DATA : %0d | WINC : %0d | WRST_N :  %0d  | WFULL:%0d",aitem.wdata, aitem.winc, aitem.wrst_n, aitem.wfull), UVM_NONE);
        endtask
        task read_do(ref int q[$:16],read_item item,read_item aitem);
                if(q.size()==0)item.rempty=1;
                else begin
                        item.rempty=0;
                end
                if (!item.rempty && item.rinc && !item.rrst_n)begin
                        item.rdata=q.pop_front();
                        rptr++;
                        $display("rptr=%0d size=%0d",rptr,q.size());
                end
                if(item.rempty==aitem.rempty)
                        `uvm_info(get_type_name(),"rempty Matched",UVM_DEBUG);
                if(item.rdata==aitem.rdata)
                       `uvm_info(get_type_name(),"rdata Matched",UVM_DEBUG);

        endtask
endclass
