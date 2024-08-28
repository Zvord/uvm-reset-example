package my_env_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import my_pkg::*;
    import reset_agent_pkg::*;

    `include "my_env_cfg.sv"
    `include "my_env.sv"
endpackage : my_env_pkg