function [i_l_hist1, i_l_hist2, v_l_hist1, v_l_hist2] = line_history(act_line,kappa,k)
% This function reads the historic line values and interpolates them if
% the propagation time on the line is not a integer multiple of tau

% Input: act_line... number of line of which the historic values are required
%        kappa... twp/tau of the current line
%        k... current time step

% Output: i_l_hist1... Current at beginning of line at k-kappa
%         i_l_hist2... Current at end of line at k-kappa
%         v_l_hist1... Voltage at beginning of line at k-kappa
%         v_l_hist2... Voltage at end of line at k-kappa

% Initalizing global variables as defined in the MAIN script
global l_current_memory;
global l_voltage_memory;

% Creating lower and upper round of kappa and weighting factor
kappa_l = floor(kappa);
kappa_u = ceil(kappa);
kappa_w = kappa - kappa_l; 

% Calculating rows with values at beginning and end of the line
act_line_start = 2*act_line - 1;
act_line_end = 2*act_line;

% Getting historical values and interpolation
if (k-kappa_u) > 0 
   i_l_hist1 = l_current_memory(act_line_start,k-kappa_u) + kappa_w * (l_current_memory(act_line_start,k-kappa_l)-l_current_memory(act_line_start,k-kappa_u));
   i_l_hist2 = l_current_memory(act_line_end,k-kappa_u) + kappa_w * (l_current_memory(act_line_end,k-kappa_l)-l_current_memory(act_line_end,k-kappa_u));

   v_l_hist1 = l_voltage_memory(act_line_start,k-kappa_u) + kappa_w * (l_voltage_memory(act_line_start,k-kappa_l)-l_voltage_memory(act_line_start,k-kappa_u));
   v_l_hist2 = l_voltage_memory(act_line_end,k-kappa_u) + kappa_w * (l_voltage_memory(act_line_end,k-kappa_l)-l_voltage_memory(act_line_end,k-kappa_u));
else
    i_l_hist1 = 0;
    i_l_hist2 = 0;

    v_l_hist1 = 0;
    v_l_hist2 = 0;
end

% end of function
end 