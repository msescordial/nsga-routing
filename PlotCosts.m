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

function costs = PlotCosts(pop)

    Costs=[pop.Cost];
    %disp(Costs);
    cost_1 = normalize(Costs(1,:));    % normalize(Costs(1,:));
    cost_2 = normalize(Costs(2,:));    % normalize(Costs(2,:));
    costs = [cost_1; cost_2]';

    plot(cost_1,cost_2,'m.','MarkerSize',15);
    %plot(Costs(1,:),Costs(2,:),'r*','MarkerSize',8);
    
    xlabel('Passenger Objective');
    ylabel('Operator Objective');
    title('Non-dominated Solutions (F_{1})');
    grid on;

end