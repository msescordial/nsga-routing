function bin = checkNodeRepetition(solution_vector,s,n)

    % Check for duplicate nodes in each route
    % convert string to routes
    route_set = stringToRoutes(solution_vector,s,n);
        
    repsum = 0;
    for c=1:s
        route = nonzeros(route_set{c,1})';
        rep = length(route)-length(unique(route));
        repsum = repsum + rep;
    end

    bin = repsum == 0;      % bin = 1 if no node repetition, 0 otherwise

%    if ~bin
%        disp("There are same nodes in a route!");
%    end

end