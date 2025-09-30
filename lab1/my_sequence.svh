class my_transaction extends uvm_sequence_item;

  `uvm_object_utils(my_transaction)

  rand bit reset;
  rand bit enable;

  function new (string name = "");
    super.new(name);
  endfunction

endclass: my_transaction


class my_sequence extends uvm_sequence#(my_transaction);

  `uvm_object_utils(my_sequence)

  function new (string name = "");
    super.new(name);
  endfunction

  task body;
    // 1- Test reset
    req = my_transaction::type_id::create("reset_test");
    start_item(req);
    req.reset  = 1;
    req.enable = 0;
    finish_item(req);

    req = my_transaction::type_id::create("reset_release");
    start_item(req);
    req.reset  = 0;
    req.enable = 1;
    finish_item(req);

    // 2- Test counting and overflow
    repeat (11) begin
      req = my_transaction::type_id::create("count_test");
      start_item(req);
      req.reset  = 0;
      req.enable = 1;
      finish_item(req);
    end

    // 3- Test disable (hold value)
    repeat (2) begin
      req = my_transaction::type_id::create("disable_test");
      start_item(req);
      req.reset  = 0;
      req.enable = 0;
      finish_item(req);
    end


    req = my_transaction::type_id::create("resume_after_disable");
    start_item(req);
    req.reset  = 0;
    req.enable = 1;
    finish_item(req);

    // Continue counting few more cycles
    repeat (8) begin
      req = my_transaction::type_id::create("count_resume");
      start_item(req);
      req.reset  = 0;
      req.enable = 1;
      finish_item(req);
    end
    
        // 4- Test reset again in middle
    req = my_transaction::type_id::create("mid_reset");
    start_item(req);
    req.reset  = 1;
    req.enable = 0;
    finish_item(req);
    
    repeat(8) begin
    req = my_transaction::type_id::create("resume_after_reset");
    start_item(req);
    req.reset  = 0;
    req.enable = 1;
    finish_item(req);
    end

  endtask: body

endclass: my_sequence
