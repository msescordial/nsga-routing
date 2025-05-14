function bin=checkRouteLengthConstraint(solution_vector,s,n,DistanceMatrix,min_route_length,max_route_length)

 % All routes must satisfy the length constraint
    route_set = stringToRoutes(solution_vector,s,n);
    bin = 1;
    for c=1:s
        route = nonzeros(route_set{c,1})';
        rlen = getRouteLength(route,DistanceMatrix);

        if ((rlen < min_route_length) || (rlen > max_route_length))
            bin = 0;       % Early exit on first invalid route
            break;
        end
    end
end