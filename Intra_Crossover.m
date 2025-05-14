function [new_route_set_string]=Intra_Crossover(route_set_string,s,n,min_route_length,max_route_length,DistanceMatrix)
   
    new_route_set_string = zeros(1,1);

    routes_parent = reshape(route_set_string(1, 1:s*n), s, n);
    
    %disp("Routes of the Parent Solution for Intra-Crossover"); disp(routes_parent);
                
    % Choose 2 routes randomly
    route_pair = 2;
    iter = 1; maxiter = 20;
    
    %fprintf("\n iter "); 
    while (route_pair == 2)
        %fprintf('\n %d ',iter);
        if (iter > maxiter)
            new_route_set_string = route_set_string;
            break;
        end
        
        A = 1:s;
        %disp("A"); disp(A);
                
        rp = sort(randperm(numel(A),2));  %disp("rp"); disp(rp);
        x1 = A(rp(1));
        x2 = A(rp(2));

        chosen_routes = routes_parent([x1, x2], :);
        not_chosen_routes = routes_parent(setdiff(1:s, [x1, x2]), :);

        %disp("Chosen Routes"); disp(chosen_routes);
        %disp("Not Chosen Routes"); disp(not_chosen_routes);
                
        % 2. Then Choosing of demarcation site randomly 
        % Demarcation site is at the end of the common node 
        % Only one demarcation site (for now)
        route1 = functionRoute(chosen_routes(1,:));
        route2 = functionRoute(chosen_routes(2,:));
                
        [b, h] = getCommonNodes(route1, route2);
        if (b == 1)
            [newroute1, newroute2] = intra_crossover_operator(route1, route2, h, n, min_route_length, max_route_length, DistanceMatrix);   
            if (newroute1 == 0)
                %fprintf("Get another route pair. ");
                route_pair = 2;
            else
                % combine the new routes into one solution route set
                C = not_chosen_routes;  %disp("C"); disp(C);
                D1 = newroute1;
                D2 = newroute2;
                route_pair = 3; 
            end
        else
            %fprintf("No common nodes; Get another route pair. ");
            route_pair = 2;
        end
        iter = iter + 1;
    end

    if (iter < maxiter)
        new_route_set_string = [D1, D2, reshape(C.', 1, [])];

        %displayRouteSet(route_set_string,s,n); 
        %disp("New Solution After Intra-Crossover"); displayRouteSet(new_route_set_string,s,n);
        return;
    end
    if (new_route_set_string == 0)
        new_route_set_string = route_set_string;
    end

end