function new_route_set = Mutation(route_set,s,n,DistanceMatrix,min_route_length,max_route_length)

    new_route_set = zeros(1,s*n);
        
    % choose random node
    g = 0;
    while (g == 0)
        sr = randi([1,s],1);
        vec = functionRoute(route_set(1,(sr-1)*n+1:sr*n));
        mp = randi([1,length(vec)],1);
        node = vec(1,mp);       %disp("Old Node"); disp(node);
        new_node = mutation_operator(node, DistanceMatrix, vec, n);     %disp("New Node"); disp(new_node);
        len = length(new_node);     

        len2 = len + length(vec) - 1;
        if ((len2 < min_route_length) || (len2 > max_route_length))
            g = 0;
        else
            g = 1; 
        end
    end
    
    if (len == 1)
        new_route_set(1,:) = route_set(1,:);          % other nodes stay the same
        new_route_set(1,(sr-1)*n+mp) = new_node;
    elseif (len > 1)
        new_route_set(1,:) = route_set(1,:);
        new_route_set(1,(sr-1)*n+mp:(sr-1)*n+mp+len-1) = new_node;
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
