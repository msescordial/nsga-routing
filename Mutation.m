function new_route_set = Mutation(route_set,s,n,DistanceMatrix,min_route_length,max_route_length)

    new_route_set = zeros(1,s*n);
        
    % choose random node
    g = 0;
    while (g == 0)
        selected_route = randi([1,s],1);
        vec = functionRoute(route_set(1,(selected_route-1)*n+1:selected_route*n));
        mutation_point = randi([1,length(vec)],1);
        node = vec(1,mutation_point);       %disp("Old Node"); disp(node);
        new_node = mutation_operator(node, DistanceMatrix, vec, n);     %disp("New Node"); disp(new_node);
        len = length(new_node);     

        if (len == 1)
            new_route_set(1,:) = route_set(1,:);          % other nodes stay the same
            new_route_set(1,(selected_route-1)*n+mutation_point) = new_node;
        
        elseif (len > 1)
            new_route_set(1,:) = route_set(1,:);
            new_route_set(1,(selected_route-1)*n+mutation_point:(selected_route-1)*n+mutation_point+len-1) = new_node;
        end

            new_route = new_route_set(1,(selected_route-1)*n+1:selected_route*n);
            route_length = getRouteLength(functionRoute(new_route),DistanceMatrix);

        if ((route_length < min_route_length) || (route_length > max_route_length))
            g = 0;
        else
            g = 1; 
        end
    end
    %displayRouteSet(route_set,s,n);
    %disp("After Mutation:"); displayRouteSet(new_route_set,s,n);

    % checking if all nodes are in the solution set
    feasible = checkFeasibility(new_route_set,s,n); 
    if (feasible == 0)                % Infeasible
        infeasible_solution = new_route_set; 
        %disp("Infeasible Solution after Mutation"); displayRouteSet(infeasible_solution,s,n); 
        feas2 = repair_infeasible_route_set(infeasible_solution, s, n, DistanceMatrix);
        if (feas2 == 0)              % Infeasibility cannot be repaired
            new_route_set = route_set;
        else                         % Infeasibility is repaired
            new_route_set = feas2;
            %disp("Feasible Solution"); displayRouteSet(feas2,s,n);
        end
    end

end