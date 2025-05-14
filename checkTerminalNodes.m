function bin = checkTerminalNodes(solution_vector,s,n,TerminalNodes)

    % Check if end nodes are terminal nodes
    % convert string to routes
    route_set = stringToRoutes(solution_vector,s,n);
        
    for c = 1:s
        route = nonzeros(route_set{c,1})';
        starting_node = route(1,1);
        ending_node = route(end);
        if ~ismember(starting_node, TerminalNodes) || ~ismember(ending_node, TerminalNodes)
            bin = 0;
            return;
        end
    end

    bin = 1;

end
