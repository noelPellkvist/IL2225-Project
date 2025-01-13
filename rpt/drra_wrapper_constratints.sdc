Information: Building the design 'DW_div_pipe' instantiated from design 'divider_pipe_0' with
	the parameters "a_width=32,b_width=32,tc_mode=1,rem_mode=1,num_stages=4,stall_mode=0,rst_mode=1,op_iso_mode=4". (HDL-193)
Warning: Cannot find the design 'DW_div_pipe' in the library 'WORK'. (LBR-1)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_0'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_15'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_14'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_13'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_12'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_11'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_10'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_9'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_8'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_7'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_6'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_5'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_4'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_3'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_2'. (LINK-5)
Warning: Unable to resolve reference 'DW_div_pipe' in 'divider_pipe_1'. (LINK-5)
Information: Updating design information... (UID-85)
Warning: Design 'drra_wrapper' contains 6 high-fanout nets. A fanout number of 1000 will be used for delay calculations involving these nets. (TIM-134)
 
****************************************
Report : constraint
Design : drra_wrapper
Version: V-2023.12-SP4
Date   : Tue Dec 17 12:05:29 2024
****************************************


                                                   Weighted
    Group (max_delay/setup)      Cost     Weight     Cost
    -----------------------------------------------------
    clk                          0.00      1.00      0.00
    default                      0.00      1.00      0.00
    -----------------------------------------------------
    max_delay/setup                                  0.00

                              Total Neg  Critical
    Group (critical_range)      Slack    Endpoints   Cost
    -----------------------------------------------------
    clk                          0.00         0      0.00
    default                      0.00         0      0.00
    -----------------------------------------------------
    critical_range                                   0.00

                                                   Weighted
    Group (min_delay/hold)       Cost     Weight     Cost
    -----------------------------------------------------
    clk (no fix_hold)            0.00      1.00      0.00
    default                      0.00      1.00      0.00
    -----------------------------------------------------
    min_delay/hold                                   0.00


    Constraint                                       Cost
    -----------------------------------------------------
    max_transition                                   0.00 (MET)
    max_capacitance                                  0.00 (MET)
    max_delay/setup                                  0.00 (MET)
    sequential_clock_pulse_width                     0.00 (MET)
    critical_range                                   0.00 (MET)


1
