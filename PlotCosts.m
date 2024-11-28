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

function norm_costs = PlotCosts(pop)

    Costs=[pop.Cost];
    %disp(Costs);
    norm_cost_1 = Costs(1,:); %normalize(Costs(1,:)); 
    norm_cost_2 = Costs(2,:); %normalize(Costs(2,:)); 
    norm_costs = [norm_cost_1; norm_cost_2]';

    plot(norm_cost_1,norm_cost_2,'r*','MarkerSize',8);
    %plot(Costs(1,:),Costs(2,:),'r*','MarkerSize',8);
    
    xlabel('1^{st} Objective');
    ylabel('2^{nd} Objective');
    title('Non-dominated Solutions (F_{1})');
    grid on;

end