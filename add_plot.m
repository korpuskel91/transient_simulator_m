function add_plot(num, type, node_1, node_2, t_from, t_to)
% store plot information for automatic plot creation  
global num_plots; %Total numer of plots
global plot_info; %Table in which information is stored
global num_subplots; %Number of subplots, as you can fit multiple plots in one subplot

%first plot goes into sub_plot 1
%if num of second plot is equal to num of the first, both plots go into the
%same subplot

%if num of second plot != num first plot, a new subplot is created 
if sum(plot_info(:,1) == num) == 0;
    num_subplots = num_subplots +1; 
end


num_plots = num_plots + 1;


plot_info(num_plots,1) = num;
plot_info(num_plots,2) = type;
plot_info(num_plots,3) = node_1;
plot_info(num_plots,4) = node_2;
plot_info(num_plots,5) = t_from;
plot_info(num_plots,6) = t_to;

end


