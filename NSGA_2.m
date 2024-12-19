% (WITH MODIFICATION FOR BUS ROUTING) 
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

function [front_pop] = NSGA_2(min_route_length, max_route_length, network_name, DistanceMatrix, TimeMatrix, TravelDemandMatrix, ...
    TerminalNodes, k_ksP, s, transfer_time, n, metro_line, incorporate_metro)

%% ----- Parameters -----
max_no_of_generations = 20;       % maximum no. of generations (200)
population_size = 20;             % (100)
P_ce = 0.5;             % inter-crossover probability
P_ca = 0.5;             % intra-crossover probability
P_m = 0.05;             % mutation probability

%% ----- INITIALIZATION -----
% GENERATE CANDIDATE ROUTES
tic

if (network_name == "metro_manila")
    %[BusRouteID, AllPaths, AllCosts, TotalNoOfRoutes] = generateRoutes(DistanceMatrix,k_ksP,TerminalNodes);
    %save('RoutesGenerated.mat','BusRouteID','AllPaths','AllCosts','TotalNoOfRoutes','-mat')
    load('RoutesGenerated.mat','BusRouteID','AllPaths','AllCosts','TotalNoOfRoutes');
else
    [BusRouteID, AllPaths, AllCosts, TotalNoOfRoutes] = generateRoutes(DistanceMatrix,k_ksP,TerminalNodes);
end

fprintf('\nNo. of candidate routes generated is %d.\n\n', TotalNoOfRoutes);
toc

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.Rank=[];
empty_individual.DominationSet=[];
empty_individual.DominatedCount=[];
empty_individual.CrowdingDistance=[];
pop=repmat(empty_individual,population_size,1);

% GENERATE INITIAL POPULATION
initial_pop_matrix = cell(population_size,5);
% 1st col: no., 2nd col: route IDs, 3rd col: Obj Func Value, 
% 4th col: Fitness Value, 5th col: route string

g = 1;
% Rows
fprintf('\n');

while (g <= population_size)
    [route_set_IDs,route_set] = generateInitialRouteSet(DistanceMatrix, BusRouteID, TotalNoOfRoutes, s, min_route_length, max_route_length);
    % Make sure that the route set is connected
    connected = checkConnectedness(route_set,s,n);
    if (connected == 0)
        %disp("Route set is not connected.");
        continue
    else
        fprintf('route set %d is connected...',g);
    end
    
    fprintf('generating route set time matrix...');
    rs_TimeMatrix = getRouteSetTimeMatrix0(route_set,s,TimeMatrix, transfer_time);
    route_set_Cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rs_TimeMatrix,n);

    initial_pop_matrix{g,1} = g;
    initial_pop_matrix{g,2} = transpose(route_set_IDs);
    initial_pop_matrix{g,3} = route_set_Cost; 
    initial_pop_matrix{g,4} = route_set_Cost; 

    % Convert to String
    string_length = s*n;            % Note: Demarcation Line is at the end of every nth node
    route_set_string = zeros(1,string_length);
    y1=1; y2=n;
    for q=1:s 
        route_set_string(1,y1:y2)= route_set{q,1};
        y1=y1+n; y2=y2+n;
    end
    initial_pop_matrix{g,5} = route_set_string;
    g = g + 1;
end
fprintf('\n');

%disp("Initial Population Matrix"); disp(initial_pop_matrix);
save('RouteSetsGenerated.mat','initial_pop_matrix','-mat')
load('RouteSetsGenerated.mat','initial_pop_matrix');
disp(initial_pop_matrix);

for g=1:population_size
    pop(g).Position=initial_pop_matrix{g,5};
    pop(g).Cost=initial_pop_matrix{g,3};
end

% Plot ObjFuncValues of Initial Population
%figure(1);
%norm_costs = PlotCosts(pop);
%title('Initial Population');
%pause(0.01);


% Non-Dominated Sorting
[pop, F]=NonDominatedSorting(pop);  %disp("Non-Dominated Sorting"); disp("pop"); disp(F);
% Calculate Crowding Distance
pop=CalcCrowdingDistance(pop,F);    %disp("Calculate Crowding Distance"); disp("pop"); disp(F);
% Sort Population
[pop, F]=SortPopulation(pop);       %disp("Sort Population"); disp("pop"); disp(F);
%disp("pop"); disp(pop);

%% --- NSGA-II MAIN LOOP ---
for iter=1:max_no_of_generations
    fprintf('\nGeneration %d\n',iter);

    % CROSSOVER
    % Inter-string
    % 1. Choosing of Pair of Parents randomly
    % 2. Choosing of demarcation site randomly
    % 3. Crossover Probability P_ce 
    
    nCrossover=2*round(P_ce*population_size/2);     % Number of Parents (Offsprings)
    popc=repmat(empty_individual,nCrossover/2,2);   % repeat copies of array

    k = 1;
    while(k <= nCrossover) 
        i1=randi([1 population_size]);
        p1=pop(i1);    
        i2=randi([1 population_size]);
        p2=pop(i2);   

        %crossover
        [new_route_set_1, new_route_set_2]=Inter_Crossover(p1.Position,p2.Position,s,n,DistanceMatrix);        
        %cost
        route_set_1 = stringToRoutes(new_route_set_1,s,n);
        route_set_2 = stringToRoutes(new_route_set_2,s,n);

        % Make sure that each route set is connected
        connected_1 = checkConnectedness(route_set_1,s,n);
        connected_2 = checkConnectedness(route_set_2,s,n);
        if (connected_1 + connected_2 < 2)
            continue
        %else
            %fprintf('\nroute set is connected...');
        end

        rsce1_TimeMatrix = getRouteSetTimeMatrix0(route_set_1,s,TimeMatrix, transfer_time);
        route_set_1_cost = getObjectiveFunctionValue(route_set_1,TravelDemandMatrix,DistanceMatrix,rsce1_TimeMatrix,n);
        rsce2_TimeMatrix = getRouteSetTimeMatrix0(route_set_2,s,TimeMatrix, transfer_time);
        route_set_2_cost = getObjectiveFunctionValue(route_set_2,TravelDemandMatrix,DistanceMatrix,rsce2_TimeMatrix,n);
        
        popc(k).Position = new_route_set_1;
        popc(k+1).Position = new_route_set_2;
        popc(k).Cost = route_set_1_cost;
        popc(k+1).Cost = route_set_2_cost;

        k = k+2;
    end
    popc=popc(:);    %disp("popc"); disp(popc);      

    
    % Intra-string
    % 1. Choosing Parent population randomly
    % 2. Choosing of demarcation site randomly
    % 3. Crossover Probability P_ca 

    nCrossover=2*round(P_ca*population_size/2);     % Number of Parents (Offsprings)
    popc=repmat(popc,1,1);   % repeat copies of array
    k = 1;
    while (k <= nCrossover)   
        i1=randi([1 population_size/2]);
        p1=popc(i1);
        
        %crossover
        [new_route_set]=Intra_Crossover(p1.Position,s,n);      %disp(popc(k).Position)
        %cost
        route_set = stringToRoutes(new_route_set,s,n); 
        rsca_TimeMatrix = getRouteSetTimeMatrix0(route_set,s,TimeMatrix, transfer_time);
        route_set_cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rsca_TimeMatrix,n);

        popc(k).Position = new_route_set;
        popc(k).Cost = route_set_cost;
        
        k = k+1;
    end
    popc=popc(:);       %disp(popc);
       

    % MUTATION

    nMutation=round(P_m*population_size);     % Number of Parents (Offsprings)
    popm=repmat(empty_individual,nMutation,1);   % repeat copies of array
    k = 1;
    while (k <= nMutation)   
        i1=randi([1 population_size/2]);
        p1=popc(i1);

        %mutation
        [new_route_set] = Mutation(p1.Position,s,n,DistanceMatrix);
        %cost
        route_set = stringToRoutes(new_route_set,s,n); 
        % Make sure that the route set is connected
        connected = checkConnectedness(route_set,s,n);
        if (connected == 0)
            continue
        %else
            %fprintf('\nroute set is connected...');
        end
        rsm_TimeMatrix = getRouteSetTimeMatrix0(route_set,s,TimeMatrix, transfer_time);
        route_set_cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rsm_TimeMatrix,n);
        popm(k).Position = new_route_set;
        popm(k).Cost = route_set_cost;
        k = k + 1;
    end
    popm=popm(:);       %disp("popm"); disp(popm);
       

    % MERGE
    pop=[pop
         popc
         popm];         
    %disp("pop"); disp(pop);
   
    % Recompute Costs
    if (incorporate_metro == 1)
        for k=1:length(pop)
            route_string = [pop(k).Position metro_line];
            s1 = 26; n1 = 149;
            route_set = stringToRoutes(route_string,s1,n1);
            rsm_TimeMatrix = getRouteSetTimeMatrix0(route_set,s1,TimeMatrix, transfer_time);
            route_set_cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rsm_TimeMatrix,n1);
            pop(k).Cost = route_set_cost;
        end
    elseif (sum(metro_line) == 0)
        for k=1:length(pop)
            route_string = [pop(k).Position];
            route_set = stringToRoutes(route_string,s,n);
            rsm_TimeMatrix = getRouteSetTimeMatrix0(route_set,s,TimeMatrix, transfer_time);
            route_set_cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rsm_TimeMatrix,n);
            pop(k).Cost = route_set_cost;
        end
    end

    % Normalize costs
    Costs=[pop.Cost];
    %disp("NOT Normalized Costs"); disp(Costs');
    norm_cost_1 = normalize(Costs(1,:));
    norm_cost_2 = normalize(Costs(2,:));
    norm_costs = [norm_cost_1; norm_cost_2]';
    %disp("Normalized Costs"); disp(norm_costs);
    for k=1:length(pop)
        pop(k).Cost = norm_costs(k,:)';
    end

    % Non-Dominated Sorting
    [pop, F]=NonDominatedSorting(pop);
    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);
    % Sort Population
    [pop, F]=SortPopulation(pop);
    
    % Truncate
    pop=pop(1:population_size);

    % Non-Dominated Sorting
    [pop, F]=NonDominatedSorting(pop);
    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);
    % Sort Population
    [pop, F]=SortPopulation(pop);

    % Store F1
    F1=pop(F{1}); %disp(F1);
    
    % Show Iteration Information
    fprintf('\n');
    disp(['Iteration ' num2str(iter) ': Number of F1 Members = ' num2str(numel(F1))]);
    
    % Plot F1 Normalized Costs
    figure(1);
    norm_costs = PlotCosts(F1);
    pause(0.01);
   
end

% Pareto Front
front_pop = cell(numel(F1),2);
for g=1:numel(F1)
    front_pop{g,1}=F1(g).Position; %disp(front_pop{g,1});
    front_pop{g,2}=norm_costs(g,:);
end

% Display Route Sets 
fprintf('\n\nRoute Sets in Pareto-optimal Front: \n'); 
for g=1:numel(F1)
    fprintf('\nRoute Set no. %d: \n', g); 
    fprintf('Normalized Costs: \n'); disp(front_pop{g,2}); 
    if (incorporate_metro == 1)                  % network: manila
        route_string = [front_pop{g,1} metro_line];
        s = 26; n = 149;
        route_set = stringToRoutes(route_string,s,n);
    elseif (sum(metro_line) == 0)                % metro_line == [], network: mandl OR india
        route_string = [front_pop{g,1}];
        route_set = stringToRoutes(route_string,s,n);
    end
    rsm_TimeMatrix = getRouteSetTimeMatrix0(route_set,s,TimeMatrix, transfer_time);
    route_set_cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rsm_TimeMatrix,n);
    front_pop{g,1} = route_string;
    front_pop{g,2} = route_set_cost;
    F1(g).Cost = route_set_cost;            % actual costs
    
    Sr=stringToRoutes(front_pop{g,1},s,n);
    for a=1:s
        fprintf(' Route %d:', a); 
        br = functionRoute(Sr{a,1});
        displayRoute(br);
    end
    fprintf('Costs: \n'); disp(front_pop{g,2}); 
    % Plot Route Sets
    figure(2);
    plotRouteSet(network_name,Sr,s,n);
    pause(0.5);
end

% Plot F1 Actual Costs
figure(3);
costs = PlotCosts(F1);
pause(0.01);
title('F1 Actual Costs');

% Plot Final Population Actual Costs
all_pop = cell(numel(pop),2);
for g=1:numel(pop)
    all_pop{g,1}=pop(g).Position; %disp(front_pop{g,1});
    all_pop{g,2}=pop(g).Cost;
end
for g=1:length(pop)
    if (incorporate_metro == 1)                  % network: manila
        route_string = [all_pop{g,1} metro_line];
        s = 26; n = 149;
        route_set = stringToRoutes(route_string,s,n);
    elseif (sum(metro_line) == 0)                % metro_line == [], network: mandl OR india
        route_string = [all_pop{g,1}];
        route_set = stringToRoutes(route_string,s,n);
    end
    rsm_TimeMatrix = getRouteSetTimeMatrix0(route_set,s,TimeMatrix, transfer_time);
    route_set_cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rsm_TimeMatrix,n);
    all_pop{g,1} = route_string;
    all_pop{g,2} = route_set_cost;
    pop(g).Cost = route_set_cost;   % actual costs
end
figure(4);
costs = PlotCosts(pop);
pause(0.01);
title('Final Population Costs');

% Plot F1 Costs of the Latest Generation of Solutions
%figure(2);
%plot(norm_costs(:,1),norm_costs(:,2),'r*','MarkerSize',8);
%xlabel('1^{st} Objective');
%ylabel('2^{nd} Objective');
%title('Non-dominated Solutions (F_{1})');
%grid on;

end
    


