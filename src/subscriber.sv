`uvm_analysis_imp_decl(_wmon)
`uvm_analysis_imp_decl(_rmon)
class fifo_subscriber extends uvm_subscriber;
  `uvm_component_utils(fifo_subscriber)
  uvm_analysis_imp_wmon#(write_item,fifo_subscriber)wsub;
  uvm_analysis_imp_rmon#(read_item,fifo_subscriber)rsub;
  real write_mon_cov_results,read_mon_cov_results ;
  write_item witem;
  read_item ritem;
  covergroup write_coverage;
    option.per_instance=1;
    WRITE_RESET:coverpoint witem.wrst_n {bins wr_rst[]={0,1};}
    WRITE_ENABLE:coverpoint witem.winc {bins wr_inc[]={0,1};}
    WRITE_DATA: coverpoint witem.wdata {bins wr_data={[0:255]};}
    WRITE_FULL: coverpoint witem.wfull {bins wr_full[]={0,1};}
  endgroup
  covergroup read_coverage;
    option.per_instance=1;
    READ_RESET  : coverpoint ritem.rrst_n   { bins rd_rst[]   = { 0 , 1 } ; }
	READ_INC : coverpoint ritem.rinc    { bins rd_en[]    = { 0 , 1 } ; }
	READ_DATA   : coverpoint ritem.rdata  { bins rd_data    = { [ 0 : 255 ] } ; }
	READ_EMPTY  : coverpoint ritem.rempty { bins rd_empty[] = { 0 , 1 } ; }
	READ_RESETXREAD_ENABLE : cross READ_RESET , READ_INC  ; 
  endgroup
//    write_coverage wcover;
//     read_coverage rcover;
  function new(string name="fifo_subscriber",uvm_component parent=null);
    super.new(name,parent);
    write_coverage=new();
    read_coverage =new();
    wsub=new("wsub",this);
    rsub=new("rsub",this);
  endfunction
  function void write_wmon(write_item wr_seq);
		witem = wr_seq;
		write_coverage.sample();
	endfunction

	function void write_rmon(read_item rd_seq);
		ritem = rd_seq;
		read_coverage.sample();
	endfunction

  function void extract_phase(uvm_phase phase);
		super.extract_phase(phase);
		write_mon_cov_results  = write_coverage.get_coverage();
		read_mon_cov_results   = read_coverage.get_coverage();                 
	endfunction
	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name, $sformatf("[WRITE_MONITOR]  Coverage ------> %0.2f%%", write_mon_cov_results ), UVM_MEDIUM);
		`uvm_info(get_type_name, $sformatf("[READ_MONITOR]   Coverage ------> %0.2f%%", read_mon_cov_results  ), UVM_MEDIUM);
	endfunction
endclass
