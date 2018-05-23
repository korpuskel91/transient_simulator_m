function add_v_source(ampl, freq, phase, start_node, end_node)
% This function adds a cosinal voltage source and adds the respective
% values into the sources vector
% See input description in MAIN script

% Initalizing global variables as defined in the MAIN script
global tau;
global num_parts; 
global num_nodes;
global parts;
global num_steps;
global sources;

% New row in parts-list
if size(parts,1) == 1 && num_parts == 0
    new_row = 1;
else
    new_row = size(parts,1)+ 1;
end

% New row in sources list
if size(parts,1) == 1 && num_parts == 0
    new_row_s = 1;
else
    new_row_s = size(parts,1) + 1;
end

% Increment number of parts
num_parts = num_parts + 1;

% Increment number of nodes
if start_node > num_nodes 
    num_nodes = start_node;
end
if end_node > num_nodes
    num_nodes = end_node;
end

% Write in parts list
parts(new_row,2) = 0;
parts(new_row,2) = 0;
parts(new_row,3) = 0;
parts(new_row,4) = 0;
parts(new_row,5) = start_node;
parts(new_row,6) = end_node;
parts(new_row,7) = 0;
parts(new_row,8) = 0;
parts(new_row,9) = 0;

% Write in sources-list
for k = 0:1:num_steps-1
   sources(new_row_s,k+1) = ampl * exp(1i*(freq * 2 * pi  * k * tau + phase));
end

% End of function
end

