function add_conductance(type, value, start_node, end_node, init_v, init_i)
% This function adds the information of a conductance (Resistor, capacitor
% or inductor into the parts list.
% See input description in MAIN script

% Initalizing global variables as defined in the MAIN script
global tau;
global num_parts; 
global num_nodes;
global parts;
global num_steps;
global sources;
global simulation_method;

% New row for parts-list
if size(parts,1) == 1 && num_parts == 0
    new_row = 1;
else
    new_row = size(parts,1)+ 1;
end

% New row for sources-list
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

% Calculating respective conductance based on simulation method
G_loc = value;

% Trapezoidal
if simulation_method == 1 
    % Inductor
    if type == 2 
        G_loc = tau/(2*value);
    end
    % Conductor
    if type == 3 
        G_loc = (2*value)/tau;
    end
end

% Backward Euler
if simulation_method == 2
    % Inductor
    if type == 2 
        G_loc = tau/value;
    end
    % Capacitor
    if type == 3 
        G_loc = value/tau;
    end
end

% Writing in parts-list
parts(new_row,1) = type;
parts(new_row,2) = init_v;
parts(new_row,3) = init_i;
parts(new_row,4) = G_loc;
parts(new_row,5) = start_node;
parts(new_row,6) = end_node;
parts(new_row,7) = 0;
parts(new_row,8) = 0;
parts(new_row,9) = 0;

% Creating empty line in sources-list
for k = 0:1:num_steps
   sources(new_row_s,k+1) = 0;
end

% end of function
end

