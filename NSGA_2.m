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
max_no_of_generations = 100;       
population_size = 100;             
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

%% GENERATE INITIAL POPULATION
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
    [rs_TimeMatrix, ntransfer] = getRouteSetTimeMatrix(route_set,s,TimeMatrix, transfer_time);
    route_set_Cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rs_TimeMatrix,n);
    % Make sure that the two Objective Function Values have no Inf value
    if (ismember(inf,route_set_Cost) == 1 || ismember(NaN,route_set_Cost) == 1)
        continue
    end

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

% Non-Dominated Sorting
[pop, F]=NonDominatedSorting(pop);  %disp("Non-Dominated Sorting"); disp("pop"); disp(F);
% Calculate Crowding Distance
pop=CalcCrowdingDistance(pop,F);    %disp("Calculate Crowding Distance"); disp("pop"); disp(F);
% Sort Population
[pop, F]=SortPopulation(pop);       %disp("Sort Population"); disp("pop"); disp(F);
%disp("pop"); disp(pop);


%% --- NSGA-II MAIN LOOP ---
iter = 1;
while iter <= max_no_of_generations
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
        end

        [rsce1_TimeMatrix, ntransfer] = getRouteSetTimeMatrix(route_set_1,s,TimeMatrix, transfer_time);
        route_set_1_cost = getObjectiveFunctionValue(route_set_1,TravelDemandMatrix,DistanceMatrix,rsce1_TimeMatrix,n);
        [rsce2_TimeMatrix, ntransfer] = getRouteSetTimeMatrix(route_set_2,s,TimeMatrix, transfer_time);
        route_set_2_cost = getObjectiveFunctionValue(route_set_2,TravelDemandMatrix,DistanceMatrix,rsce2_TimeMatrix,n);
        % Make sure that the two Objective Function Values have no Inf value
        if (ismember(inf,route_set_1_cost) == 1 || ismember(NaN,route_set_1_cost) == 1 || ismember(inf,route_set_2_cost) == 1 || ismember(NaN,route_set_2_cost) == 1)
            continue
        end
        
        popc(k).Position = new_route_set_1;
        popc(k+1).Position = new_route_set_2;
        popc(k).Cost = route_set_1_cost;
        popc(k+1).Cost = route_set_2_cost;

        k = k+2;
    end
    popc=popc(:);    %disp("popc"); disp(popc);    

    fprintf("\nInter-String Crossover done.");

    
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
        % Make sure that the route set is connected
        connected = checkConnectedness(route_set,s,n);
        if (connected == 0)
            continue
        end
        [rsca_TimeMatrix, ntransfer] = getRouteSetTimeMatrix(route_set,s,TimeMatrix, transfer_time);
        route_set_cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rsca_TimeMatrix,n);
        % Make sure that the two Objective Function Values have no Inf value
        if (ismember(inf,route_set_cost) == 1 || ismember(NaN,route_set_cost) == 1)
            continue
        end        

        popc(k).Position = new_route_set;
        popc(k).Cost = route_set_cost;
        
        k = k+1;
    end
    popc=popc(:);       %disp(popc);

    fprintf("\nIntra-String Crossover done.");
       

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
        end
        [rsm_TimeMatrix, ntransfer] = getRouteSetTimeMatrix(route_set,s,TimeMatrix, transfer_time);
        route_set_cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rsm_TimeMatrix,n);
        % Make sure that the two Objective Function Values have no Inf value
        if (ismember(inf,route_set_cost) == 1 || ismember(NaN,route_set_cost) == 1)
            continue
        end  

        popm(k).Position = new_route_set;
        popm(k).Cost = route_set_cost;
        k = k + 1;
    end
    popm=popm(:);       %disp("popm"); disp(popm);

    fprintf("\nMutation done.\n");
       

    % MERGE
    pop=[pop
         popc
         popm];         
    %disp("pop"); disp(pop);
   
    % Recompute Costs
    if (incorporate_metro == 1)         % network = metro_manila
        for k=1:length(pop)
            route_string = [pop(k).Position metro_line];
            s1 = 26; n1 = 149;
            route_set = stringToRoutes(route_string,s1,n1);
            [rsm_TimeMatrix, ntransfer] = getRouteSetTimeMatrix(route_set,s1,TimeMatrix, transfer_time);
            route_set_cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rsm_TimeMatrix,n1);
            pop(k).Cost = route_set_cost;
        end
    elseif (sum(metro_line) == 0)       % network = mandl OR india
        for k=1:length(pop)
            route_string = [pop(k).Position];
            route_set = stringToRoutes(route_string,s,n);
            [rsm_TimeMatrix, ntransfer] = getRouteSetTimeMatrix(route_set,s,TimeMatrix, transfer_time);
            route_set_cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rsm_TimeMatrix,n);
            pop(k).Cost = route_set_cost;       
        end
    end

    % Normalize costs
    Costs=[pop.Cost];
    norm_cost_1 = normalize(Costs(1,:));
    norm_cost_2 = normalize(Costs(2,:));
    norm_costs = [norm_cost_1; norm_cost_2]';
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
   
    iter = iter + 1;
end

%% Pareto Front
front_pop = cell(numel(F1),2);
for g=1:numel(F1)
    front_pop{g,1}=F1(g).Position; 
    front_pop{g,2}=norm_costs(g,:);
end

F1_transfermatrix = zeros(numel(F1),5);

%% Display F1 Route Sets 
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
    [rsm_TimeMatrix, ntransfer] = getRouteSetTimeMatrix(route_set,s,TimeMatrix, transfer_time);
    F1_transfermatrix(g,:) = ntransfer;
    route_set_cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rsm_TimeMatrix,n);
    front_pop{g,1} = route_string;
    front_pop{g,2} = route_set_cost;
    F1(g).Cost = route_set_cost;                % actual costs
    
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

%% Plot F1 Actual Costs
figure(3);
costs = PlotCosts(F1);
pause(0.01);
title('F1 Actual Costs');

%% Plot F1 Transfer Statistics
figure(4);
x = linspace(1,numel(F1),numel(F1));
y1 = ([F1_transfermatrix(:,1)]').*(1/n^2);
plot(x,y1,'r-*','MarkerSize',10, 'DisplayName', 'Direct trips','LineWidth',2);
hold on 
y2 = ([F1_transfermatrix(:,2)]').*(1/n^2);
plot(x,y2,'y-*','MarkerSize',10, 'DisplayName', '1 Transfer trips','LineWidth',2);
hold on 
y3 = ([F1_transfermatrix(:,3)]').*(1/n^2);
plot(x,y3,'g-*','MarkerSize',10, 'DisplayName', '2 Transfer trips','LineWidth',2);
hold on 
y4 = ([F1_transfermatrix(:,4)]').*(1/n^2);
plot(x,y4,'c-*','MarkerSize',10, 'DisplayName', '3 Transfer trips','LineWidth',2);
if (network_name == "metro_manila")
    hold on
    plot(3.5, 0.1441,'r-*','MarkerSize',10); hold on
    plot(3.5, 0.4792,'y-*','MarkerSize',10); hold on
    plot(3.5, 0.3767,'g-*','MarkerSize',10); hold on
    plot(3.5, 0,'c-*','MarkerSize',10);
end
hold off

xlabel('Non-dominated Solutions');
ylabel('Percentage of Transfers');
title('Percentage of Transfers of Non-Dominated Solutions');
legend('Direct trips','1 Transfer trips','2 Transfer trips','3 Transfer trips');

%% Plot Final Population Actual Costs
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
    [rsm_TimeMatrix, ntransfer] = getRouteSetTimeMatrix(route_set,s,TimeMatrix, transfer_time);
    route_set_cost = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,rsm_TimeMatrix,n);
    all_pop{g,1} = route_string;
    all_pop{g,2} = route_set_cost;
    pop(g).Cost = route_set_cost;   % actual costs
end
figure(5);
costs = PlotCosts(pop);
pause(0.01);
title('Final Population Costs');


end
    


