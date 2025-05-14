function initial_pop_matrix = generateInitialPopulation(population_size, BusRouteID, TotalNoOfRoutes, ...
    min_route_length, max_route_length, network_name, DistanceMatrix, TimeMatrix, TravelDemandMatrix, ...
    TerminalNodes, k_ksP, s, transfer_time, n, metro_line, incorporate_metro)

initial_pop_matrix = cell(population_size,5);

% 1st col: no., 2nd col: route IDs, 3rd col: Obj Func Value, 
% 4th col: Fitness Value, 5th col: route string, 6th col: transfers

g = 1;

fprintf('\n');
while (g <= population_size)
    [route_set_IDs,route_set] = generateInitialRouteSet(DistanceMatrix, BusRouteID, TotalNoOfRoutes, s, min_route_length, max_route_length);
    
    % Make sure that the route set is connected and has no repeated routes
    connected = checkConnectedness(route_set,s,n);
    repeatedroutes = checkRouteRepetition(route_set,s,n);
    if (connected == 0 || repeatedroutes == 1)
        %disp("Route set is not connected or has repeated routes.");
        continue
    elseif (connected == 1 && repeatedroutes == 0)
        fprintf('route set %d is connected and has no repeated routes...',g);
    end

    % Convert to String
    route_set_string = reshape(cell2mat(route_set(:,1).'), 1, []);
    
    % Append metro line route to compute cost
    route_string = [route_set_string metro_line];
    s1 = s + 1; 
    new_route_set = stringToRoutes(route_string,s1,n);

    fprintf('generating route set time matrix...');
    [rs_TimeMatrix, ntransfer] = getRouteSetTimeMatrix(new_route_set,s1,TimeMatrix, transfer_time);
    route_set_cost = getObjectiveFunctionValue(new_route_set,TravelDemandMatrix,DistanceMatrix,rs_TimeMatrix,n);
    % Make sure that the two Objective Function Values have no Inf value
    if (ismember(inf,route_set_cost) == 1 || any(isnan(route_set_cost)))
        fprintf('\n Objective Values have Inf/NaN');
        continue
    end

    initial_pop_matrix{g,1} = g;
    initial_pop_matrix{g,2} = transpose(route_set_IDs);
    initial_pop_matrix{g,3} = route_set_cost; 
    initial_pop_matrix{g,4} = route_set_cost; 
    initial_pop_matrix{g,5} = route_set_string;
    initial_pop_matrix{g,6} = ntransfer;
    g = g + 1;


end

disp("Initial Population Matrix"); disp(initial_pop_matrix);

end
