%%Create plots for voltages and currents. 
%This function works as follows:
%1: Create the according number of subplots (1 to 3) and add the 
%   corresponding number to the index. 
%
%2: identify plot type (voltage or current). 
%   As the voltage stored, is the potential against ground, the diefference
%   between (node1 - node2) is plotted
%   As the current is not a potential between nodes, the current is taken
%   from the No. of the part storen in node_1
%   If the there is a plot for the current of a line, a plot is generated
%   with 2 currents, from start node and end node
%
%3: Identify how many cureves should be in the subplot. This value is 
%   stored in p_sub when initializing the plots
%
%4: create plot and legends with node_1 node_2 for the voltages and part
%   number for the currents

p = 1;
l = 1;
figure
for p_sub=1:1:num_subplots
    subplot(num_subplots,1,p_sub)
    if plot_info(p,p_type) == 1 % if type = voltage
       
         if sum(plot_info(:,1) == p_sub) == 1 %if one voltage is in the subplot  
            plot(x,(voltages(plot_info(p,node_1),:)-voltages(plot_info(p,node_2),:)))
            legend(strcat('v_',num2str(plot_info(p,node_1)),'_',num2str(plot_info(p,node_2))))
            title('Voltages')
            p = p + 1;
         end
         if sum(plot_info(:,1) == p_sub) == 2 %if two voltage are in the subplot  
            plot(x,(voltages(plot_info(p,node_1),:)-voltages(plot_info(p,node_2),:)),x,(voltages(plot_info(p+1,node_1),:)-voltages(plot_info(p+1,node_2),:)))
            legend(strcat('v_',num2str(plot_info(p,node_1)),'_',num2str(plot_info(p,node_2))),strcat('v_',num2str(plot_info(p+1,node_1)),'_',num2str(plot_info(p+1,node_2))))
            title('Voltages')
            p = p + 2;
         end
         if sum(plot_info(:,1) == p_sub) == 3 %if three voltages are in the subplot  
            plot(x,(voltages(plot_info(p,node_1),:)-voltages(plot_info(p,node_2),:)),x,(voltages(plot_info(p+1,node_1),:)-voltages(plot_info(p+1,node_2),:)),x,(voltages(plot_info(p+2,node_1),:)-voltages(plot_info(p+2,node_2),:)))
            legend(strcat('v_',num2str(plot_info(p,node_1)),'_',num2str(plot_info(p,node_2))),strcat('v_',num2str(plot_info(p+1,node_1)),'_',num2str(plot_info(p+1,node_2))),strcat('v_',num2str(plot_info(p+2,node_1)),'_',num2str(plot_info(p+2,node_2))))
            title('Voltages')
            p = p + 3;
         end   
    
    
    elseif plot_info(p,p_type) == 2 && (parts(plot_info(p,node_1),1) ~= 5 ) % if type = current and part not a line
         if sum(plot_info(:,1) == p_sub) == 1 %if one current is in the subplot  
            plot(x,(currents(plot_info(p,node_1),:)))
            legend(strcat('i_',num2str(plot_info(p,node_1))))
            title('Currents')
            p = p + 1;
         end
         if sum(plot_info(:,1) == p_sub) == 2 %if two volcurrents are in the subplot  
            plot(x,(currents(plot_info(p,node_1),:)),x,(currents(plot_info(p+1,node_1))))
            legend(strcat('i_',num2str(plot_info(p,node_1))),strcat('i_',num2str(plot_info(p,node_1))))
            title('Currents')
            p = p + 2;
         end
         if sum(plot_info(:,1) == p_sub) == 3 %if three volcurrents are in the subplot 
             plot(x,(currents(plot_info(p,node_1),:)),x,(currents(plot_info(p+1,node_1),:)),x,(currents(plot_info(p+2,node_1),:)))
             legend(strcat('i_',num2str(plot_info(p,node_1))),strcat('i_',num2str(plot_info(p,node_1))),strcat('i_',num2str(plot_info(p,node_1))))
             title('Currents')
             p = p + 3;
         end    
         
    
    
    elseif plot_info(p,p_type) == 2 && parts(plot_info(p,node_1),1) == 5 % if type=current and part = line
            plot(x,(l_current_memory(2*l-1,:)),x,(l_current_memory(2*l,:)))
            legend('i_{l=0}','i_{l=x}')
            title('Currents on Line')
            p = p + 1;
    end
    
end
   