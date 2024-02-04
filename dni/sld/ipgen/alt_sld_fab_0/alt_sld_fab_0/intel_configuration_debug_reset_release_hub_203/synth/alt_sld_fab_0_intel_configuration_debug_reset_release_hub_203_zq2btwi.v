module alt_sld_fab_0_intel_configuration_debug_reset_release_hub_203_zq2btwi
#(
    parameter SOURCE_PROVIDED = 0,
    parameter DEVICE_FAMILY_ID = 2
) (
    input reset_in,
    output reset_out_0,
    output reset_out_1,
    output reset_out_2
);
    wire reset_src;
    if (SOURCE_PROVIDED == 0) begin
        intel_configuration_reset_release_for_debug #(.DEVICE_FAMILY_ID(DEVICE_FAMILY_ID)) conf_reset_src (.conf_reset(reset_src));
    end else begin
        assign reset_src = reset_in;
    end

    assign reset_out_0 = reset_src;
    assign reset_out_1 = reset_src;
    assign reset_out_2 = reset_src;
endmodule
