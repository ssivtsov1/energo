INSERT INTO eqi_cable_tbl (id, "type", normative, voltage_nom, amperage_nom, voltage_max, amperage_max, cords, cover, ro, xo, dpo, s_nom,show_def) VALUES (999999, '_Невизначений', NULL,NULL,NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL,1);
INSERT INTO eqi_corde_tbl (id, "type", normative, voltage_nom, amperage_nom, voltage_max, amperage_max, materal, calc_diam, cord_diam, cord_qn, s_nom, dpo, xo, ro, show_def) VALUES (999999, '_Невизначений', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);

INSERT INTO eqi_meter_tbl (id, "type", normative, voltage_nom, amperage_nom, voltage_max, amperage_max, kind_meter, kind_count, phase, carry, schema_inst, hook_up, amperage_nom_s, voltage_nom_s, zones, zone_time_min, term_control,show_def)	VALUES (999999, '_Невизначений', NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1);
INSERT INTO eqi_meter_energy_tbl (id_type_eqp, kind_energy) VALUES (999999, 1);
INSERT INTO eqi_meter_energy_tbl (id_type_eqp, kind_energy) VALUES (999999, 2);
INSERT INTO eqi_meter_energy_tbl (id_type_eqp, kind_energy) VALUES (999999, 3);
INSERT INTO eqi_meter_energy_tbl (id_type_eqp, kind_energy) VALUES (999999, 4);
INSERT INTO eqi_meter_prec_tbl (id_type_eqp, cl, kind_load, amperage_load, error) VALUES (999999, '0', 0.00, 0.00, NULL);

INSERT INTO eqi_compensator_tbl (id, "type", normative, voltage_nom, amperage_nom, voltage_max, amperage_max, voltage2_nom, amperage2_nom, phase, swathe, hook_up, power_nom_old, amperage_no_load, power_nom, show_def) VALUES (999999, '_Невизначений', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, 1);
INSERT INTO eqi_compensator_2_tbl (id_type_eqp, voltage_short_circuit, iron, copper) VALUES (999999, NULL, NULL, NULL);

INSERT INTO eqi_compensator_i_tbl (id, "type", normative, voltage_nom, amperage_nom, voltage_max, amperage_max, voltage2_nom, amperage2_nom, "conversion", phase, swathe, hook_up, power_nom, amperage_no_load, accuracy) VALUES (999999, '_Невизначений', NULL, NULL, 1, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL);


INSERT INTO eqi_fuse_tbl (id, "type", normative, voltage_nom, amperage_nom, voltage_max, amperage_max, power_nom) VALUES (999999, '_Невизначений', NULL,NULL, NULL, NULL, NULL, NULL);


 =еякх(C7-C15>0; еякх(C22-C15>0;0;еякх(C22-C14>0;нйпсцк((C15-C22)*C31;0);нйпсцк((C15-C14)*C31;0)));еякх(C7-C14>0;еякх(C7-C22>0;C5-C43-C39-C35;0);0))