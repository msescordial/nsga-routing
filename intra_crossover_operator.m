function [newroute1, newroute2] = intra_crossover_operator(route1, route2, h, n, min_route_length, max_route_length, DistanceMatrix)
    % choosing randomly 
    k = length(h);
    c = randi([1, k],1);

    demarc_node = h(c);
    %disp("Demarcation Node"); disp(demarc_node);
    
    m1 = length(route1); m2 = length(route2);
    % getting the position of demarc_node

    pos_1 = find(route1 == demarc_node, 1);
    pos_2 = find(route2 == demarc_node, 1);
      
    if ( pos_1 == m1 || pos_2 == m2)
        newroute1 = 0; newroute2 = 0;
    elseif ( pos_1 == 1 || pos_2 == 1)
        newroute1 = 0; newroute2 = 0;       
    else 
        % splitting the two routes
        part11 = route1(1,1:pos_1); p11 = length(part11);
        part12 = route1(1,pos_1+1:m1); p12 = length(part12);       
        part21 = route2(1,1:pos_2); p21 = length(part21);
        part22 = route2(1,pos_2+1:m2); p22 = length(part22);
        
        newroute1 = zeros(1,n);
        newroute2 = zeros(1,n);
        
        % intra-crossover
        newroute1(1,1:p11) = part11;
        newroute1(1,p11+1:p11+p22) = part22;
        newroute2(1,1:p21) = part21;
        newroute2(1,p21+1:p21+p12)= part12;
 
        %disp("newroute1"); disp(newroute1);
        %disp("newroute2"); disp(newroute2); 

        A1 = getRouteLength(functionRoute(newroute1),DistanceMatrix); 
        A2 = getRouteLength(functionRoute(newroute2),DistanceMatrix);
        
        if ((A1 < min_route_length) || (A1 > max_route_length))
            newroute1 = 0; newroute2 = 0;
        elseif ((A2 < min_route_length) || (A2 > max_route_length))
            newroute1 = 0; newroute2 = 0;
        end
        
        % are there two same nodes in each new route?
        A3 = functionRoute(newroute1); A4 = functionRoute(newroute2);
        rep3 = length(A3)-length(unique(A3));
        rep4 = length(A4)-length(unique(A4));
        repsum = rep3 + rep4;
        if (repsum ~= 0)
            newroute1 = 0; newroute2 = 0;
            %fprintf("Meow! There are same nodes in a route");
        end
        
    end
end