module tb_top;
    import uvm_pkg::*;
    import test_pkg::*;


    dut u_dut();
    bind dut harness u_harness(.*);

    // initial begin
    //     $dumpfile("dump.vcd");
    //     $dumpvars(0, u_dut);
    // end

    initial begin
        run_test("base_test");
    end

    initial begin
        uvm_config_db#(virtual harness)::set(null, "*", "vif", u_dut.u_harness);
    end

    initial begin
    end
endmodule