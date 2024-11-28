function [new_route_set_string]=Intra_Crossover(route_set_string,s,n)
   
    new_route_set_string = zeros(1,1);
    routes_parent = zeros(s,n);         % display the routes
    p=1;
    for k=1:s
        routes_parent(k,:) = route_set_string(1,p:p+n-1);
        p = p+n;
    end
    %disp("Routes of the Parent Solution for Intra-Crossover"); 
    %disp(routes_parent);
                
    % Choose 2 routes randomly
    route_pair = 2;
    iter = 1; maxiter = 20;
             
    while (route_pair == 2)
        if (iter > maxiter)
            new_route_set_string = route_set_string;
            break;
        end
        A = zeros(1,s); 
        for q=1:s
            A(1,q) = q;
        end
        %disp("A"); disp(A);
                
        rp = sort(randperm(numel(A),2));  %disp("rp"); disp(rp);
        x1 = A(rp(1));
        x2 = A(rp(2));

        chosen_routes = zeros(2,n);
        e = 1;
        not_chosen_routes = zeros(s-2,n);
        f = 1;
        for w=1:s
            if (w == x1)
                chosen_routes(e,:) = routes_parent(w,:);
                e = e+1;
            elseif (w == x2)
                chosen_routes(e,:) = routes_parent(w,:);
                e = e+1;
            else
                not_chosen_routes(f,:) = routes_parent(w,:);
                f = f + 1;
            end
        end
        %disp("Chosen Routes"); disp(chosen_routes);
        %disp("Not Chosen Routes"); disp(not_chosen_routes);
                
        % 2. Then Choosing of demarcation site randomly 
        % Demarcation site is at the end of the common node 
        % Only one demarcation site (for now)
        route1 = BusRoute(chosen_routes(1,:));
        route2 = BusRoute(chosen_routes(2,:));
                
        [b, h] = common_nodes(route1, route2);
        if (b == 1)
            [newroute1, newroute2] = intra_crossover_operator(route1, route2, h, n);   
            if (newroute1 == 0)
                %disp("Get another route pair.");
                route_pair = 2;
            else
                % combine the new routes into one solution route set
                C = not_chosen_routes;  %disp("C"); disp(C);
                D1 = newroute1;
                D2 = newroute2;
                route_pair = 3; 
            end
        else
            %disp("Get another route pair.");
            route_pair = 2;
        end
        iter = iter + 1;
    end

    if (iter < maxiter)
        new_route_set_string = zeros(1,s*n);
        new_route_set_string(1,1:n) = D1;
        new_route_set_string(1,n+1:2*n) = D2;
        [Cr Cc] = size(C);
        f = 2;
        for q=1:Cr
            new_route_set_string(1,f*n+1:(f+1)*n) = C(q,:); 
            f = f + 1;
        end
        %displayRouteSet(route_set_string,s,n); 
        %disp("New Solution After Intra-Crossover"); displayRouteSet(new_route_set_string,s,n);
        return;
    end
    if (new_route_set_string == 0)
        new_route_set_string = route_set_string;
    end

end