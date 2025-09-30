class my_driver extends uvm_driver #(my_transaction);

  `uvm_component_utils(my_driver)

  virtual dut_if dut_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", dut_vif)) begin
      `uvm_error("", "uvm_config_db::get failed")
    end
  endfunction 

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      // Drive pins based on transaction
      dut_vif.reset  = req.reset;
      dut_vif.enable = req.enable;
      //wait one clock to see result
      seq_item_port.item_done();
      @(posedge dut_vif.clock);
    end
  endtask

endclass: my_driver


