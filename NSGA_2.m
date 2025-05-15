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

function [front_pop_final] = NSGA_2(min_route_length, max_route_length, network_name, DistanceMatrix, TimeMatrix, TravelDemandMatrix, ...
    TerminalNodes, k_ksP, s, transfer_time, n, metro_line, incorporate_metro)

rng('shuffle');  % Ensure different random sequences per run

%% ----- Parameters -----
max_no_of_generations = 100;       
population_size = 100;             
P_ce = 0.5;             % inter-crossover probability
P_ca = 0.5;             % intra-crossover probability
P_m = 0.01;             % mutation probability

% For Sensitivity Analysis
gen_set = []; %[25 50 100 200 300];

%% ----- INITIALIZATION -----
% GENERATE CANDIDATE ROUTES
tic

% UNCOMMENT the next two lines
%[BusRouteID, AllPaths, AllCosts, TotalNoOfRoutes] = generateRoutes(DistanceMatrix,k_ksP,TerminalNodes,max_route_length);
%save('RoutesGenerated.mat','BusRouteID','AllPaths','AllCosts','TotalNoOfRoutes','-mat')
load('RoutesGenerated.mat','BusRouteID','AllPaths','AllCosts','TotalNoOfRoutes');
fprintf('\nNo. of candidate routes generated is %d.\n\n', TotalNoOfRoutes);
toc

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.ActualCost=[];
empty_individual.Transfer=[];
empty_individual.Rank=[];
empty_individual.DominationSet=[];
empty_individual.DominatedCount=[];
empty_individual.CrowdingDistance=[];
pop=repmat(empty_individual,population_size,1);

%% GENERATE INITIAL POPULATION

% UNCOMMENT the next four lines
%initial_pop_matrix = generateInitialPopulation(population_size, BusRouteID, TotalNoOfRoutes, ...
%    min_route_length, max_route_length, network_name, DistanceMatrix, TimeMatrix, TravelDemandMatrix, ...
%    TerminalNodes, k_ksP, s, transfer_time, n, metro_line, incorporate_metro);
%save('RouteSetsGenerated.mat','initial_pop_matrix','-mat')
load('RouteSetsGenerated.mat','initial_pop_matrix');
disp(initial_pop_matrix);

% All route sets must have finite objective function values
%for h=1:population_size
%    disp(initial_pop_matrix{h,4});
%end

for g=1:population_size
    pop(g).Position=initial_pop_matrix{g,5};
    pop(g).Cost=initial_pop_matrix{g,3};
    pop(g).ActualCost=initial_pop_matrix{g,4};
    pop(g).Transfer=initial_pop_matrix{g,6};
end

% For debugging
%load('pop_nsga.mat','pop');
%disp(pop);

% Non-Dominated Sorting
[pop, F]=NonDominatedSorting(pop);  
% Calculate Crowding Distance
pop=CalcCrowdingDistance(pop,F);    
% Sort Population
[pop, F]=SortPopulation(pop);       


%% --- NSGA-II MAIN LOOP ---
iter = 1;
%iter = 3;   % for debugging

while iter <= max_no_of_generations

    fprintf('\nGeneration %d\n',iter);

    %% CROSSOVER
    % Inter-string
    % 1. Choosing of Pair of Parents randomly
    % 2. Choosing of demarcation site randomly
    % 3. Crossover Probability P_ce 
    
    nCrossover=2*round(P_ce*population_size/2);     % Number of Parents (Offsprings)
    popc=repmat(empty_individual,nCrossover/2,2);   % repeat copies of array

    k = 1;
    while(k <= nCrossover) 
        fprintf('%d ',k);
        i1=randi([1 population_size]);
        p1=pop(i1);    
        i2=randi([1 population_size]);
        p2=pop(i2);   

        %crossover
        [new_route_string_1, new_route_string_2]=Inter_Crossover(p1.Position,p2.Position,s,n,DistanceMatrix);        
        
        route_set_1 = stringToRoutes(new_route_string_1,s,n);
        route_set_2 = stringToRoutes(new_route_string_2,s,n);

        % Check for feasibility (other constraints)
        bin1 = checkConstraints(route_set_1,s,n,new_route_string_1,...
            DistanceMatrix,min_route_length,max_route_length,TerminalNodes);
        if (bin1 == 0)
            continue
        end
        bin2 = checkConstraints(route_set_2,s,n,new_route_string_2,...
            DistanceMatrix,min_route_length,max_route_length,TerminalNodes);
        if (bin2 == 0)
            continue
        end

        % Append metro line route to compute cost
        route_string_1 = [new_route_string_1 metro_line];
        route_string_2 = [new_route_string_2 metro_line];
        s1 = 26;     
        new_route_set_1 = stringToRoutes(route_string_1,s1,n);
        new_route_set_2 = stringToRoutes(route_string_2,s1,n);

        % Make sure that the two Objective Function Values have no Inf value
        [rsce1_TimeMatrix, ntransfer1] = getRouteSetTimeMatrix(new_route_set_1,s1,TimeMatrix, transfer_time);
        route_set_1_cost = getObjectiveFunctionValue(new_route_set_1,TravelDemandMatrix,DistanceMatrix,rsce1_TimeMatrix,n);
        if (ismember(inf,route_set_1_cost) == 1 || any(isnan(route_set_1_cost)))
            %fprintf("Objective value has Inf/NaN ");
            continue
        end
        [rsce2_TimeMatrix, ntransfer2] = getRouteSetTimeMatrix(new_route_set_2,s1,TimeMatrix, transfer_time);
        route_set_2_cost = getObjectiveFunctionValue(new_route_set_2,TravelDemandMatrix,DistanceMatrix,rsce2_TimeMatrix,n);
        if (ismember(inf,route_set_2_cost) == 1 || any(isnan(route_set_2_cost)))
            %fprintf("Objective value has Inf/NaN ");
            continue
        end
        
        popc(k).Position = new_route_string_1;         %new_route_set_1
        popc(k+1).Position = new_route_string_2;       %new_route_set_2
        popc(k).Cost = route_set_1_cost;
        popc(k+1).Cost = route_set_2_cost;
        popc(k).ActualCost = route_set_1_cost;
        popc(k+1).ActualCost = route_set_2_cost;
        popc(k).Transfer = ntransfer1;
        popc(k+1).Transfer = ntransfer2; 

        k = k+2;
    end
    popc=popc(:);    %disp(popc);    

    fprintf("\nInter-String Crossover done.");

    % For debugging
%    sum = 0;
%    for h=1:length(pop)
%        sum = sum + pop(h).ActualCost;
%    end
%    disp("sum of pop actual costs"); disp(sum);

    
    %% Intra-string
    % 1. Choosing Parent population randomly
    % 2. Choosing of demarcation site randomly
    % 3. Crossover Probability P_ca 

    nCrossover=2*round(P_ca*population_size/2);     % Number of Parents (Offsprings)
    popc=repmat(popc,1,1);   % repeat copies of array
    k = 1;
    while (k <= nCrossover)   
        fprintf(' %d',k);
        i1=randi([1 population_size/2]);
        p1=popc(i1);
        
        %crossover
        [new_route_string]=Intra_Crossover(p1.Position,s,n,min_route_length,max_route_length,DistanceMatrix);
        route_set = stringToRoutes(new_route_string,s,n); 

        % Check for feasibility (other constraints)
        bin = checkConstraints(route_set,s,n,new_route_string,...
            DistanceMatrix,min_route_length,max_route_length,TerminalNodes);
        if (bin == 0)
            continue
        end

        % Append metro line route to compute cost
        route_string = [new_route_string metro_line];
        s1 = 26;     
        new_route_set = stringToRoutes(route_string,s1,n);

        [rsca_TimeMatrix, ntransfer] = getRouteSetTimeMatrix(new_route_set,s1,TimeMatrix, transfer_time);
        route_set_cost = getObjectiveFunctionValue(new_route_set,TravelDemandMatrix,DistanceMatrix,rsca_TimeMatrix,n);
        % Make sure that the two Objective Function Values have no Inf value
        if (ismember(inf,route_set_cost) == 1 || any(isnan(route_set_cost)))
            %fprintf('Objective value has Inf/NaN ');
            continue
        else
            popc(k).Position = new_route_string;    %new_route_set;
            popc(k).Cost = route_set_cost;
            popc(k).ActualCost = route_set_cost;
            popc(k).Transfer = ntransfer;
        end

        k = k+1;
    end
    popc=popc(:);       %disp(popc);

    fprintf("\nIntra-String Crossover done.");   

     % For debugging
%    sum = 0;
%    for h=1:length(pop)
%        sum = sum + pop(h).ActualCost;
%    end
%    disp("sum of pop actual costs"); disp(sum);



    %% MUTATION
    nMutation=round(P_m*population_size);     % Number of Parents (Offsprings)
    popm=repmat(empty_individual,nMutation,1);   % repeat copies of array
    k = 1;
    while (k <= nMutation)   
        fprintf(' %d ',k);
        i1=randi([1 population_size/2]);
        p1=popc(i1);

        %mutation
        [new_route_string] = Mutation(p1.Position,s,n,DistanceMatrix,min_route_length,max_route_length);
        route_set = stringToRoutes(new_route_string,s,n); 
        
        % Check for feasibility (other constraints)
        bin = checkConstraints(route_set,s,n,new_route_string,...
            DistanceMatrix,min_route_length,max_route_length,TerminalNodes);
        if (bin == 0)
            continue
        end

        % Append metro line route to compute cost
        route_string = [new_route_string metro_line];
        s1 = 26;    %s1 = 22;     
        new_route_set = stringToRoutes(route_string,s1,n);

        [rsm_TimeMatrix, ntransfer] = getRouteSetTimeMatrix(new_route_set,s1,TimeMatrix, transfer_time);
        route_set_cost = getObjectiveFunctionValue(new_route_set,TravelDemandMatrix,DistanceMatrix,rsm_TimeMatrix,n);
        % Make sure that the two Objective Function Values have no Inf value
        if (ismember(inf,route_set_cost) == 1 || any(isnan(route_set_cost)))
            %fprintf('Objective value has Inf/NaN ');
            continue
        end  

        popm(k).Position = new_route_string;
        popm(k).Cost = route_set_cost;
        popm(k).ActualCost = route_set_cost;
        popm(k).Transfer = ntransfer;
        k = k + 1;
    end
    popm=popm(:);       %disp("popm"); disp(popm);

    fprintf("\nMutation done.\n");

     % For debugging
%    sum = 0;
%    for h=1:length(pop)
%        sum = sum + pop(h).ActualCost;
%    end
%    disp("sum of pop actual costs"); disp(sum);


    %disp("pop"); disp(pop);
    %disp("popc"); disp(popc);
    %disp("popm"); disp(popm);

    % MERGE
    pop=[pop
         popc
         popm];         
    %disp("pop merged"); disp([pop.ActualCost]);

    % Delete duplicate individuals
    pop2 = pop;
    pop = getUniqueIndividuals(pop2, population_size);
    %disp("pop unique"); disp([pop.ActualCost]);

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
    
    % Plot F1 Actual Costs
    [actual_costs,Fmin,Fmax,Fmed] = PlotActualCosts(F1,iter,gen_set);
    title(['Generation ' num2str(iter)]);
    pause(0.01);

    save('pop_nsga.mat','pop','-mat');  

    %% Graph and Display F1 for Sensitivity Analysis
    if (ismember(iter,gen_set))  
        % plot route sets R1, R2, R3
        s1 = 26; n = 149;
        fprintf('\n R1:');
        forSensitivityAnalysis(s1, n, metro_line, Fmin{1,1}, network_name, iter);
        filename = 'F1_R1.fig';
        savefig(gcf,filename);
        fprintf('\n R2:');
        forSensitivityAnalysis(s1, n, metro_line, Fmax{1,1}, network_name, iter);
        filename = 'F1_R2.fig';
        savefig(gcf,filename);
        fprintf('\n R3:');
        forSensitivityAnalysis(s1, n, metro_line, Fmed{1,1}, network_name, iter);
        filename = 'F1_R3.fig';
        savefig(gcf,filename);
    end

    iter = iter + 1;
end


%% Pareto Front
[Fmin,Fmax,Fmed,front_pop_final] = sortParetoFront(F1);
[nr, ~]=size(front_pop_final);
F1_transfermatrix = zeros(nr,5);

%% Display F1 Route Sets 
fprintf('\n\nRoute Sets in Pareto-optimal Front: \n'); 
q = 101;
for g=1:nr
    fprintf('\nRoute Set no. %d: \n', g); 
    fprintf('Actual Costs: \n'); disp(front_pop_final{g,3}');
    F1_transfermatrix(g,:) = front_pop_final{g,4};
    
    route_string = [front_pop_final{g,1} metro_line];
    s = 26;     
    n = 149;

    Sr=stringToRoutes(route_string,s,n);
    for a=1:s
        fprintf(' Route %d:', a); 
        br = functionRoute(Sr{a,1});
        displayRoute(br);
    end

    % Plot Route Sets
    figure(q);
    plotRouteSet(network_name,Sr,s,n,g);
    title(['Route Set ' num2str(g)]); 
    pause(0.5);
    q = q+1;
end

%% Plot F1 Actual Costs
figure();
costs = PlotActualCosts(F1,iter,gen_set);
pause(0.01);
title('F1 Actual Costs');
filename = 'F1actcost.fig';
savefig(gcf,filename);

%% Plot F1 Transfer Statistics
figure();
x = linspace(1,nr,nr);
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
s = 26;
hold on
plot(3.5, 0.1441,'r-*','MarkerSize',10); hold on
plot(3.5, 0.4792,'y-*','MarkerSize',10); hold on
plot(3.5, 0.3738,'g-*','MarkerSize',10); hold on
plot(3.5, 0.0030,'c-*','MarkerSize',10);
hold off

xlabel('Non-dominated Solutions');
ylabel('Proportion of Transfers');
title('Proportion of Transfers of Non-Dominated Solutions');
legend('Direct trips','1 Transfer trips','2 Transfer trips','3 Transfer trips');
filename = 'F1transfers.fig';
savefig(gcf,filename);

end
    


