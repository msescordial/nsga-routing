function [new_route_set_1_string, new_route_set_2_string]=Inter_Crossover(route_set_1_string, route_set_2_string,s,n,DistanceMatrix)

    string_length = s*n;

    demarc_line = n*randi([1,s-1],1) + 1;       % disp("Demarcation Line"); disp(demarc_line);

    new_route_set_1_string = zeros(1,string_length);
    new_route_set_2_string = zeros(1,string_length);

    new_route_set_1_string(1,1:demarc_line-1) = route_set_1_string(1,1:demarc_line-1);
    new_route_set_1_string(1,demarc_line:s*n) = route_set_2_string(1,demarc_line: string_length);
    new_route_set_2_string(1,1:demarc_line-1) = route_set_2_string(1,1:demarc_line-1);
    new_route_set_2_string(1,demarc_line:s*n) = route_set_1_string(1,demarc_line: string_length);

    % checking if all nodes are in the new route sets
    feasible = checkFeasibility(new_route_set_1_string,s,n); 
    %disp("feasible"); disp(feasible);
    if (feasible == 0)         % Infeasible
        infeasible_solution = new_route_set_1_string;       %disp("Infeasible Solution"); displayRouteSet(infeasible_solution,s,n); 
        feas1 = repair_infeasible_route_set(infeasible_solution, s, n, DistanceMatrix);
        if (feas1 == 0)        % Infeasibility cannot be repaired
            new_route_set_1_string = route_set_1_string;
            %disp("Infeasible Solution; cannot be repaired");
        else                   % Infeasibility is repaired
            new_route_set_1_string = feas1;     %disp("Feasible Solution"); displayRouteSet(feas1,s,n);
        end
    end


    feasible = checkFeasibility(new_route_set_2_string,s,n); 
    if (feasible == 0)         % Infeasible
        infeasible_solution = new_route_set_2_string;       %disp("Infeasible Solution"); displayRouteSet(infeasible_solution,s,n); 
        feas2 = repair_infeasible_route_set(infeasible_solution, s, n, DistanceMatrix);
        if (feas2 == 0)        % Infeasibility cannot be repaired
            new_route_set_2_string = route_set_2_string;
            %disp("Infeasible Solution; cannot be repaired");
        else                   % Infeasibility is repaired
            new_route_set_2_string = feas2;     %disp("Feasible Solution"); displayRouteSet(feas2,s,n);
        end
    end
    
    %disp("Inter-Crossover");
    %disp("New Route Set 1"); disp(new_route_set_1_string);
    %disp("New Route Set 2"); disp(new_route_set_2_string);

end