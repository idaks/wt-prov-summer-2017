#!/usr/bin/env bash

file=$1
ProvidedDataName=$2

xsb --quietload --noprompt --nofeedback --nobanner << END_XSB_STDIN

set_prolog_flag(unknown, fail).

['$VIEWS_DIR/${file}'].
['$RULES_DIR/yw_rules.P'].
['$RULES_DIR/gv_rules.P'].
['$RULES_DIR/yw_graph_rules.P'].

[user].
graph :-

    yw_workflow_script(W, WorkflowName, _, _),
    yw_data(D, $ProvidedDataName, W, _),

    gv_graph('yw_data_view', WorkflowName, 'TB'),

        gv_cluster('workflow', 'black'),
            gv_nodestyle__atomic_step,
            gv_nodes__atomic_steps__downstream_of_data(W,D),
            gv_nodestyle__subworkflow,
            gv_nodes__subworkflows__downstream_of_data(W,D),
            gv_node_style__data,
            gv_nodes__data__downstream_of_data(W,D),
            gv_node_style__param,
            gv_nodes__params__downstream_of_data(W,D),
        gv_cluster_end,

        gv_cluster('inflows', 'white'),
            gv_node_style__workflow_port,
            gv_node__inflow_for_data(W,D),
        gv_cluster_end,

        gv_cluster('outflows', 'white'),
        gv_node_style__workflow_port,
        gv_nodes__outflows__downstream_of_data(W,D),
        gv_cluster_end,

        gv_edges__step_to_data__downstream_of_data(W,D),
        gv_edges__data_to_step__downstream_of_data(W,D),
        gv_edges__inflow_to_data__downstream_of_data(W,D),
        gv_edges__data_to_outflow__downstream_of_data(W,D),

    gv_graph_end.

end_of_file.

graph.

END_XSB_STDIN