function add_semi_cond(type, g_on, g_off, v_th, start_node, end_node, init_v, init_i)
% This function adds a semi-conductor with none-linear behaviour
% So far implemented: diode
% See input description in MAIN script

% Initalizing global variables as defined in the MAIN script
global num_parts; 
global num_nodes;
global parts;
global num_steps;
global sources;

% New row for parts list
if size(parts,1) == 1 && num_parts == 0
    new_row = 1;
else
    new_row = size(parts,1)+ 1;
end

% New row for sources list
if size(parts,1) == 1 && num_parts == 0
    new_row_s = 1;
else
    new_row_s = size(parts,1) + 1;
end

% Incrementing parts counter
num_parts = num_parts + 1;

% Incrementing number of nodes
if start_node > num_nodes 
    num_nodes = start_node;
end
if end_node > num_nodes
    num_nodes = end_node;
end

% Initalizing with switched off-state
G_loc = g_off;

% Writing in  parts-list
parts(new_row,1) = type;
parts(new_row,2) = init_v;
parts(new_row,3) = init_i;
parts(new_row,4) = G_loc;
parts(new_row,5) = start_node;
parts(new_row,6) = end_node;
parts(new_row,7) = g_on;
parts(new_row,8) = g_off;
parts(new_row,9) = v_th;

% Creating empty line in source list
for k = 0:1:num_steps
   sources(new_row_s,k+1) = 0;
end

% end of function
end

