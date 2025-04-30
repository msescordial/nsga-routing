%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function [costs,Fmin,Fmax,Fmed] = PlotActualCosts(pop)

    Costs=[pop.ActualCost];
    %disp(Costs);
    cost_1 = Costs(1,:);   
    cost_2 = Costs(2,:);   
    costs = [cost_1; cost_2]';

    [Fmin,Fmax,Fmed,front_pop_final] = sortParetoFront(pop);
    routes3 = cell2mat([Fmin(1,3), Fmax(1,3), Fmed(1,3)]);
    disp(routes3);

    figure();
    plot(cost_1,cost_2,'m.','MarkerSize',15); hold on;
    plot(845498.10, 446.61,'r.','MarkerSize',15); hold on;
    plot(routes3(1,1), routes3(2,1),'.','Color',[0 0.4470 0.7410],'MarkerSize',15); hold on; 
    plot(routes3(1,2), routes3(2,2),'.','Color',[0.4660 0.6740 0.1880],'MarkerSize',15); hold on;
    plot(routes3(1,3), routes3(2,3),'.','Color',[0.9290 0.6940 0.1250],'MarkerSize',15); 
    hold off;
    
    xlabel('Passenger Objective');
    ylabel('Operator Objective');
    title('Non-dominated Solutions (F_{1})');
    grid on;

end