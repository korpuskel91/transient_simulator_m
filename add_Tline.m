function add_Tline(length, L_pl, C_pl, start_node, end_node)
% This function adds a lossless transmission line 
% See input description in MAIN script

% Initalizing global variables as defined in the MAIN script
global num_lines;
global tau;
global parts;
global part_line_map;
global num_parts;
global num_nodes;

% Calulation of line parameters
Z0 = sqrt(L_pl/C_pl);
c = sqrt(1/(L_pl*C_pl));
Twp = length / c;

% Relation propagation time to tau
kappa = Twp / tau;

% Show error message if choosen time step size is to big
if tau > Twp 
    error('Time step size to big to simulate TLine Wave')
end

% Increment number of lines
num_lines = num_lines + 1;

% New row for parts list
if size(parts,1) == 1 && num_parts == 0
    new_row = 1;
else
    new_row = size(parts,1)+ 1;
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

% Write in parts-list
parts(new_row,1) = 5;
parts(new_row,2) = 0;
parts(new_row,3) = 0;
parts(new_row,4) = 1/Z0;
parts(new_row,5) = start_node;
parts(new_row,6) = end_node;
parts(new_row,7) = kappa;
parts(new_row,8) = 0;
parts(new_row,9) = 0;

% Map line number to part number
part_line_map(num_parts) = num_lines;

% end of function
end
