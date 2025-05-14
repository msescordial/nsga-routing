function bin = checkConstraints(route_set,s,n,route_string,DistanceMatrix,min_route_length,max_route_length,TerminalNodes)

    bin = 0;

    %% (input: cell array)
    repeatedroutes = checkRouteRepetition(route_set,s,n);
    if repeatedroutes
        fprintf("Repeated routes ");
        return
    end

    %% (input: string)
    valid = checkRouteLengthConstraint(route_string,s,n,DistanceMatrix,min_route_length,max_route_length);
    if ~valid
        fprintf("Route length not valid ");
        return
    end

    %% (input: cell array)
    overlappingroutes = checkOverlappingRoutes(route_set,s);
    if overlappingroutes
        fprintf("Overlapping routes ");
        return
    end

    %% (input: cell array)
    connected = checkConnectedness(route_set,s,n);
    if ~connected
        fprintf("Not connected ");
        return
    end

    %% (input: string)
    nocycle = checkNodeRepetition(route_string,s,n);
    if ~nocycle
        fprintf("Contains cycles or loops ");
        return
    end

    %% (input: string)
    term = checkTerminalNodes(route_string,s,n,TerminalNodes);
    if ~term
        fprintf("End nodes are not terminal nodes ");
        return
    end

    bin = 1;

end