function add_pulse(start_ampl, pulse_ampl, start_time, duration, start_node, end_node)
% This function adds a pulsed voltage source and writes the respective
% information into the sources-list
% See input description in MAIN script

% Initalizing global variables as defined in the MAIN script
global num_parts; 
global num_nodes;
global parts;
global num_steps;
global sources;

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

% Writing in parts vector
parts(new_row,1) = 0;
parts(new_row,2) = 0;
parts(new_row,3) = 0;
parts(new_row,4) = 0;
parts(new_row,5) = start_node;
parts(new_row,6) = end_node;
parts(new_row,7) = 0;
parts(new_row,8) = 0;
parts(new_row,9) = 0;


% Writing in sources-list
for k = 0:1:start_time-1
   sources(new_row_s,k+1) = start_ampl;
end
for k = start_time:1:start_time+duration-1
    sources(new_row_s,k+1) = pulse_ampl;
end
for k = start_time+duration:1:num_steps-1
   sources(new_row_s,k+1) = start_ampl;
end

% end of function
end


