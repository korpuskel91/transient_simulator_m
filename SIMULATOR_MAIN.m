%% Intitial Variable Definiton
% NO USER-CHANGES HERE
%
% Declaration of global variables
clear all

global tau; % Time Step Size of Simulation
global tmax; % Duration of simulation (in s)
global simulation_method; %Integer for choosing simulation method
global num_steps; % Number of simulation steps / iterations

% Information on the Parts in the Circuit are safed in here
global parts;
        type = 1;       % Voltage Source, G, L or C
        init_v = 2;     % Inital voltage
        init_i = 3;     % Initial current
        p_con = 4;      % (passive) conductance of the part
        p_start = 5;    % Start node
        p_end = 6;      % End node
        p_g_on = 7;     % On conductance of Diode
        p_g_off = 8;    % Off conductance of Diode
        v_th = 9;       % Thershold Voltage of Diode
       

global sources; % Safes information on voltage and current injectionsMAIN

global num_lines; % Number of Transmission lines in circuit
global num_parts; % Number of parts in circuit (including lines and sources)
global num_nodes; % Number of nodes in the circuit (including ground)

global l_voltage_memory; % Memory for voltages at beginning and end of lines
global l_current_memory; % Memory for currents at beginning and end of lines
global part_line_map; % Maps part-number to line-number
global ground;  % ground node

global num_plots; % Number of plots
global num_subplots; % NUmber of subplots
global plot_info; % Saves information on the plots
    p_num = 1;  % Plot Number
    p_type = 2; % Plot Type (Voltages or currents)
    node_1 = 3; % Start Node (for type voltages) or part number (for type currents)
    node_2 = 4; % End node (for type voltages) or zero (for type currents)

 
% Assign and initialize System Variables
num_parts = 0; 
num_nodes = 0; 
parts = 0; 
sources = 0; 
num_plots = 0; 
plot_info = 0;
num_subplots = 0;
num_lines = 0;


%% Global Simulator Settings

tau = 1e-6;
tmax = 25e-3;
simulation_method = 2;
% Trapezoidal = 1
% Backward Euler = 3
num_steps = ceil(tmax/tau); %Number of needed iteration steps

%% Functions to set-up circuit

% add_v_source(ampl, freq, phase, start_node, end_node)
%   Creates a COSINE Voltage Source
%   ampl... peak amplitude of voltage 
%   freq... siganl frequency (in Hertz)
%   phase... phase shift (in radian)
%   start_node... first connection node
%   end_node... second connection node

% add_pulse(start_ampl, pulse_ampl, start_time, duration, start_node, end_node)
%   Creates a PULSED voltage source 
%   start_ampl... amplitude before and after the pulse
%   pulse_ampl... amplitude of the pulse
%   start_time... TIMESTEP when pulse starts
%   end_time... number of TIMESTEPS the puls is on

% add_conductance(type, value, start_node, end_node,inital_voltage, inital_current)
%   Adds a passive component (Resistor, Capacitor, Inductor)
%   type... 1 = Passive Conductance               
%           2 = Inductor
%           3 = Capacitor
%   value... Depending on the type of the part value is G, L or C (in S, H or F)
%   inital_voltage... inital voltage over Capacitor or Inductor (zero for resistors)
%   inital_current... inital current through Capacitor or Inductor (zero for resistors)
                     
% add_semi_cond(type, g_on, g_off, v_th, start_node, end_node, init_v, init_i)
%   Adds a semi-doncucting component
%   type... 4 = normal Diode
%   g_on... conductance when switched on 
%   g_off... conductance when switched off
%   v_th... threshold voltage for switiching diode on
%   start_node... node for connection to the ANODE
%   end_node... node for connection to the CATHODE
%   init_v... inital voltage over diode
%   init_i... inital current through diode

% add_Tline(length, L_pl, C_pl, start_node, end_node);
%   Adds a lossless transmisson line in the circuit
%   lenght... length of line (in KILOMETERS)
%   L_pl... inductance per length (in H/km)
%   C_pl... capacitance per length (in C/km)

%% Functions to define plots

% add_plot(p_num,p_type,node_1,node_2)
%   Adds a plot  
%   p_num... Plot number, use the same number up two three times two plot different curves in the same plot
%   p_type... 1 = Voltage 
%             2 = Current
%             For two curves in one plot the plot types must agree
%             3 = Currents through line, automatically creates a plot with two curves, one for the current at the beginning and on at the end for of a transmisson line; works only for TLines
%   node_1, node_2... for voltage plot potential between nodes (type voltages), part number at node_1, node_2 = zero (for type currents)


%% Circuit Definiton
circuit_num = menu('Choose Circuit', '1: SANDBOX', '2: Lossless Line - 10km', '3: Lossy Line - 3 Splits', '4: Lossy Line - 5 Splits','5: Rectifier without line', '6: Rectifier with TLine', '7: Rectifier with faulty Diode', '8: 3-Phase-System', '9: 6-Pulse Rectifier');

%% 1
%  SANDBOX - Space for experiments.
%  Own circuits can be implemented here, below are the already set up
%  circuits for most of our testing. 

if circuit_num == 1

% Simulator Settings for this circuit    
simulation_method = 2;    
tau = 5e-5;
tmax = 100e-3;
num_steps = ceil(tmax/tau);




end

%% 2 
%  Lossless Line (10km Lossless line with load)

if circuit_num == 2

%Simulator settings
simulation_method = 2;    
tau = 1e-6;
tmax = 1e-3;
num_steps = ceil(tmax/tau);
    
% Circuit Definiton
add_pulse(0,500,floor(0.1*num_steps),floor(0.2*num_steps),1,4);

length = 10;

add_conductance(1,100,1,2,0,0);

add_Tline(length,1e-3,10e-9,2,3);

add_conductance(1,1/100,3,4,0,0);

ground = 4;

%Plot Set-Up
add_plot(1,1,2,4,0,num_steps);
add_plot(1,1,3,4,0,num_steps);
add_plot(2,2,3,0,0,num_steps); %Currents through line
end

%% 3
%  Lossy Line Aproximation (Three Splits)
if circuit_num == 3

%Simulator Settings
simulation_method = 2;    
tau = 1e-6;
tmax = 1e-3;
num_steps = ceil(tmax/tau);

% Circuit Definiton    
add_pulse(0,500,floor(0.1*num_steps),floor(0.2*num_steps),1,8);

G=1/100;
length = 10;

add_conductance(1,100,1,2,0,0);

add_conductance(1,G*4,2,3,0,0);
add_Tline(length/2,1e-3,10e-9,3,4);
add_conductance(1,G*2,4,5,0,0);
add_Tline(length/2,1e-3,10e-9,5,6);
add_conductance(1,G*4,6,7,0,0);

add_conductance(1,1/100,7,8,0,0);

ground = 8;

%Plot Set-Up
add_plot(1,1,1,8,0,num_steps);
add_plot(2,1,7,8,0,num_steps);
end

%% 4
%  Lossy Line - 5 Splits

if circuit_num == 4

%Simulator Settings
simulation_method = 2;    
tau = 1e-6;
tmax = 1e-3;
num_steps = ceil(tmax/tau);
    
%Circuit Definiton
add_pulse(0,500,floor(0.1*num_steps),floor(0.2*num_steps),1,12);

G=1/100;
length = 10;

add_conductance(1,100,1,2,0,0);

add_conductance(1,G*10,2,3,0,0);
add_Tline(length/4,1e-3,10e-9,3,4);
add_conductance(1,G*5,4,5,0,0);
add_Tline(length/4,1e-3,10e-9,5,6);
add_conductance(1,.5*G*5,6,7,0,0);
add_Tline(length/4,1e-3,10e-9,7,8);
add_conductance(1,G*5,8,9,0,0);
add_Tline(length/4,1e-3,10e-9,9,10);
add_conductance(1,G*10,10,11,0,0);

add_conductance(1,1/100,11,12,0,0);

ground = 12;

%Plot Set-Up
add_plot(1,1,1,12,0,num_steps);
add_plot(2,1,11,12,0,num_steps);
end

%% 5
%  Single Phase Rectifier without line

if circuit_num == 5
    
% Simulator Settings    
simulation_method = 1;    
tau = 5e-6;
tmax = 40e-3;
num_steps = ceil(tmax/tau);    
   
% Circuit Definiton
add_v_source(170,50,pi/2,2,1);
add_v_source(-170,50,pi/2,3,1);

add_semi_cond(4,1/10e-3,1/10e6,0,2,4,0,0);
add_semi_cond(4,1/10e-3,1/10e6,0,3,4,0,0);

add_conductance(2,1e-3,1,5,0,0);
add_conductance(1,1/50,5,4,0,0);

ground = 1;

%Plot Set-Up
add_plot(1,1,2,4,0,num_steps);
add_plot(1,1,3,4,0,num_steps);

add_plot(2,1,5,1,0,num_steps);

add_plot(3,2,5,0,0,num_steps);
end  

%% 6
%  Single Phase Recitifier with 100km Transmission line

if circuit_num == 6
    
% Simulator Settings
simulation_method = 1;    
tau = 5e-6;
tmax = 40e-3;
num_steps = ceil(tmax/tau);   
    
% Circuit Definiton
add_v_source(170,50,pi/2,2,1);
add_v_source(170,50,-pi/2,3,1);

add_semi_cond(4,1/10e-3,1/10e6,0,2,4,0,0);
add_semi_cond(4,1/10e-3,1/10e6,0,3,4,0,0);
 
add_Tline(100,1e-3,10e-9,4,5);

add_conductance(2,1e-3,1,6,0,0);
add_conductance(1,1/50,6,5,0,0);

ground = 1;

%Plot Set-Up
add_plot(2,1,4,1,0,num_steps);
add_plot(2,1,5,1,0,num_steps);

add_plot(1,1,4,3,0,num_steps);
add_plot(1,1,4,2,0,num_steps);

add_plot(3,2,6,0,0,num_steps);
end    

%% 7
%  Rectifier with faulty Diode

if circuit_num == 7
    
% Simulation Settings   
simulation_method = 1;    
tau = 5e-6;
tmax = 80e-3;
num_steps = ceil(tmax/tau);  
    
add_v_source(170,50,pi/2,2,1);
add_v_source(170,50,-pi/2,3,1);

add_semi_cond(4,1/10e-3,1/10e6,0,2,4,0,0);
%add_semi_cond(4,0,0,0,3,4,0,0);
 
add_Tline(100,1e-3,10e-9,4,5);

add_conductance(2,1e-3,1,6,0,0);
add_conductance(1,1/50,6,5,0,0);

ground = 1;

% Plot set-up
add_plot(1,1,4,1,0,num_steps);
add_plot(1,1,5,1,0,num_steps);

add_plot(2,1,4,3,0,num_steps);
add_plot(2,1,4,2,0,num_steps);

add_plot(3,2,6,0,0,num_steps);
end

%% 8
%  3-Phase-System
if circuit_num == 8
    
% Simulation Settings    
simulation_method = 2;
tau = 5e-6;
tmax = 40e-3;
num_steps = ceil(tmax/tau);

% Set to 1 to insert a fault on phase one at 0.01 seconds
insert_fault = 1;

% Circuit Definiton
add_v_source(230e3,50,0,2,1);
add_v_source(230e3,50,2*pi/3,3,1);
add_v_source(230e3,50,4*pi/3,4,1);

add_conductance(1,1/50,2,5,0,0);
add_conductance(1,1/50,3,6,0,0);
add_conductance(1,1/50,4,7,0,0);

add_conductance(3,2.5e-9,5,6,0,0);
add_conductance(3,2.5e-9,6,7,0,0);
add_conductance(3,2.5e-9,7,5,0,0);

add_Tline(50,1e-3,10e-9,5,8);
add_Tline(50,1e-3,10e-9,6,9);
add_Tline(50,1e-3,10e-9,7,10);

add_conductance(3,5e-9,8,9,0,0);
add_conductance(3,5e-9,9,10,0,0);
add_conductance(3,5e-9,10,8,0,0);

add_conductance(1,1,8,11,0,0);
add_conductance(1,1,9,12,0,0);
add_conductance(1,1,10,13,0,0);

add_Tline(50,1e-3,10e-9,11,14);
add_Tline(50,1e-3,10e-9,12,15);
add_Tline(50,1e-3,10e-9,13,16);

add_conductance(3,2.5e-9,14,15,0,0);
add_conductance(3,2.5e-9,15,16,0,0);
add_conductance(3,2.5e-9,16,14,0,0);

add_conductance(1,1/50,14,1,0,0);
add_conductance(1,1/50,15,1,0,0);
add_conductance(1,1/50,16,1,0,0);

ground = 1;

add_plot(1,1,5,1,0,num_steps);
add_plot(1,1,6,1,0,num_steps);
add_plot(1,1,7,1,0,num_steps);

add_plot(2,1,11,1,0,num_steps);
add_plot(2,1,12,1,0,num_steps);
add_plot(2,1,13,1,0,num_steps);

add_plot(3,1,5,1,0,num_steps);
add_plot(3,1,11,1,0,num_steps);

end

%% 6- Pulse Rectifier
if circuit_num == 9
    
% Simulator Settings
simulation_method = 2;        
tau = 1e-7;
tmax = 25e-3;
num_steps = ceil(tmax/tau);
    
% Circuit Definiton 
add_v_source(230e3,50,0,1,2);
add_v_source(230e3,50,2*pi/3,1,3);
add_v_source(230e3,50,4*pi/3,1,4);

add_conductance(1,1/50,2,5,0,0);
add_conductance(1,1/50,3,6,0,0);
add_conductance(1,1/50,4,7,0,0);

add_semi_cond(4,1/10e-3,1/10e6,0,5,8,0,0);
add_semi_cond(4,1/10e-3,1/10e6,0,6,8,0,0);
add_semi_cond(4,1/10e-3,1/10e6,0,7,8,0,0);

add_semi_cond(4,1/10e-3,1/10e6,0,11,5,0,0);
add_semi_cond(4,1/10e-3,1/10e6,0,11,6,0,0);
add_semi_cond(4,1/10e-3,1/10e6,0,11,7,0,0);

add_Tline(100,1e-3,10e-9,8,9);
add_conductance(1,1/5000,9,10,0,0);
add_conductance(2,1e-3,1,10,0,0);

ground = 1;

% Plot Set-Up
add_plot(1,1,2,ground,0,num_steps);
add_plot(1,1,3,ground,0,num_steps);
add_plot(1,1,4,ground,0,num_steps);

add_plot(2,1,8,ground,0,num_steps);
add_plot(2,1,9,ground,0,num_steps);

add_plot(3,2,14,0,0,num_steps);

end

%% Initalization

jv = zeros(num_nodes,1); % Vector of injected currents for one iteration
vv = zeros(num_nodes,1); % Vector of voltages for one iteration
voltages = zeros(num_nodes,num_steps); % Voltage memory over all steps
currents = zeros(num_parts, num_steps); % Current memory over all steps 
x = zeros(num_steps,1); % Time stamp for plots


%% Simulation

for k=1:1:num_steps
   
% Fault simulation for 3 phase system
if (circuit_num == 8) && (insert_fault == 1) && (k*tau > 0.01)
    parts(16,p_con) = 0;
end


% Initialize Network Matrix
YNW = zeros(num_nodes,num_nodes);

% DIODES
% Init Diodes in k = 1
if k == 1
    for n=1:1:num_parts
        if parts(n,type) == 4
            if parts(n,init_v) > parts(n,v_th);
                parts(n,p_con) = parts(n,p_g_on);
            else
                parts(n,p_con) = parts(n,p_g_off);
            end
        end
    end

else 
%Switch Diodes if necessary
   for n=1:1:num_parts
       if parts(n,type) == 4
           if (voltages(parts(n,p_start),k-1)-voltages(parts(n,p_end),k-1)) > parts(n,v_th)
                parts(n,p_con) = parts(n,p_g_on);
           else
                parts(n,p_con) = parts(n,p_g_off);
           end   
       end
   end    
end

% Write conductances in Network matrix
for n = 1:1:num_parts   
    
    dY = zeros(num_nodes,num_nodes);
    dY(parts(n,p_start),parts(n,p_start)) = parts(n,p_con);
    dY(parts(n,p_end),parts(n,p_end)) = parts(n,p_con);
    
    if parts(n,type) == 5 % Decoupling of transmission line model
        dY(parts(n,p_start),parts(n,p_end)) = 0;
        dY(parts(n,p_end),parts(n,p_start)) = 0;
    else
        dY(parts(n,p_start),parts(n,p_end)) = -parts(n,p_con);
        dY(parts(n,p_end),parts(n,p_start)) = -parts(n,p_con);
    end
  
    YNW = YNW + dY;
end

% Identifying dependent and excitation nodes 
if k == 1
ex_count = 0;
dep_count = 0;

for n = 1:1:num_parts
    % A node is ex_node if it is connected to a voltage source
    if parts(n,type) == 0 
        ex_count = ex_count + 1;
        ex_nodes(ex_count) = parts(n,p_start);
        ex_count = ex_count + 1;
        ex_nodes(ex_count) = parts(n,p_end);
    end
end

% Ground is added to ex_nodes
ex_nodes(ex_count+1) = ground;
% Sorting and ordering vector with ex nodes
ex_nodes = unique(ex_nodes);

% All nodes that are not ex_nodes are dependent nodes
for n=1:1:num_nodes    
    if ismember(ex_nodes,n) == 0 
        dep_count = dep_count +1;
        dep_nodes(dep_count) = n;
    end
end
end

% Splitting the Network Matrix
Ydd = YNW(dep_nodes, dep_nodes);
Yde = YNW(dep_nodes, ex_nodes);


% Calaculation of current injections and building of current vector
jv = zeros(num_nodes,1);
for n=1:1:num_parts
    
% Inductor and Capacitor

    if parts(n,type) == 2 || parts(n,type) == 3
        %Trapezoidal for Inductor and Capacitor
        if simulation_method == 1
            if k == 1 
                sources(n,k) = parts(n,p_con) * parts(n,init_v) + parts(n,init_i);
            else                  
                sources(n,k) = parts(n,p_con) * (voltages(parts(n,p_start),k-1)-voltages(parts(n,p_end),k-1))+currents(n,k-1);
            end
        end
        
        %Backward Euler for Inductor
        if simulation_method == 2 && parts(n,type) == 2
            if k == 1 
                sources(n,k) = parts(n,init_i);
            else
                sources(n,k) = currents(n,k-1);
            end
        end
        
        %Backward Euler for Capacitor
        if simulation_method == 2 && parts(n,type) == 3
            if k == 1 
                sources(n,k) = parts(n,p_con) * parts(n,init_v);
            else
                sources(n,k) = parts(n,p_con) * (voltages(parts(n,p_start),k-1)-voltages(parts(n,p_end),k-1));
            end
        end
    end
    
% Diodes

    if parts(n,type) == 4 
        if parts(n,p_con) == parts(n,p_g_on) 
            sources(n,k) = parts(n,p_con) * parts(n,v_th);
        else 
            sources(n,k) = 0;
        end
    end

%Transmission Line

   if parts(n,type) == 5
       act_line = part_line_map(n);
       [i_l_hist1,i_l_hist2,v_l_hist1,v_l_hist2] = line_history(act_line,parts(n,7),k);
   end  

%Write in current vector

    if parts(n,type) ~= 0 && parts(n,type) ~= 5
        jv(parts(n,p_start)) = jv(parts(n,p_start)) + sources(n,k);
        jv(parts(n,p_end)) = jv(parts(n,p_end)) + sources(n,k); 
    elseif parts(n,type) == 5
        jv(parts(n,p_start)) = (i_l_hist2 + v_l_hist2*parts(n,p_con)); %Injection at beginning of line
        jv(parts(n,p_end)) = (i_l_hist1 + v_l_hist1*parts(n,p_con)); %Injection at end of line
    end
end

% Splitting current vector
jd = (jv(dep_nodes));

% Write voltage injections in voltage vector
vv = zeros(num_nodes,1);
for n=1:1:num_parts
    if parts(n,type) == 0
        if parts(n,p_start) == ground
            vv(parts(n,p_end)) =  vv(parts(n,p_end)) - sources(n,k);
        else
            vv(parts(n,p_start)) =  vv(parts(n,p_start)) + sources(n,k);
        end
    end
end

% Splitting voltage vector
ve = (vv(ex_nodes));

% Solve for voltages
vd = Ydd\(jd-Yde*ve);

% Re-Map voltage Results to nodes
dep_count = 1;
ex_count = 1;
for n = 1:1:num_nodes
    if dep_count <= size(dep_nodes,2)
        if n == dep_nodes(1,dep_count);
            voltages(n,k) = real(vd(dep_count));
            dep_count = dep_count +1;
        end
    end

    if ex_count <= size(ex_nodes,2)
        if n == ex_nodes(1,ex_count);
            voltages(n,k) = real(ve(ex_count));
            ex_count = ex_count +1;
        end
    end
end

% Save voltages at beginning and end of lines
for p=1:1:num_parts
    if parts(p,type) == 5
        act_line = part_line_map(p);
        l_voltage_memory(2*act_line-1,k) = voltages(parts(p,p_start),k);
        l_voltage_memory(2*act_line,k) = voltages(parts(p,p_end),k);
    end
end


% Map current results to parts
for p=1:1:num_parts
    if parts(p,type) == 2 
        % Inductor
        currents(p,k) = (voltages(parts(p,p_start),k)-voltages(parts(p,p_end),k))*parts(p,p_con) + sources(p,k);
    elseif parts(p,type) == 5
        % Transmission lines
        act_line = part_line_map(p);
        [i_l_hist1,i_l_hist2,v_l_hist1,v_l_hist2] = line_history(act_line,parts(p,7),k);
        l_current_memory(2*act_line-1,k) = l_voltage_memory(2*act_line-1,k)*parts(p,p_con) + (-i_l_hist2 - v_l_hist2*parts(p,p_con)); %Current at start of line
        l_current_memory(2*act_line,k) =  l_voltage_memory(2*act_line,k)*parts(p,p_con) + (-i_l_hist1 - v_l_hist1*parts(p,p_con)); %Current at end of line
        currents(p,k) = 0; % Dummy in currents vector because line currents are saved seperately
    else
        % All other parts
        currents(p,k) = (voltages(parts(p,p_start),k)-voltages(parts(p,p_end),k))*parts(p,p_con) - sources(p,k);
    end
end

% Time Stamp for plotting
x(k) = k*tau;
end



%% Create Plots
create_plots

