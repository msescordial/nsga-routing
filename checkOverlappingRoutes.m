function overlappingroutes = checkOverlappingRoutes(route_set,s)

    R = cell(s, 1);
    for t = 1:s
        R{t} = functionRoute(route_set{t});
    end

    % Check for overlaps
    for t = 1:s
        route1 = R{t};
        route1_rev = flip(route1);
        for q = t+1:s
            route2 = R{q};
            route2_rev = flip(route2);

            if isSubsequence(route1, route2) || isSubsequence(route1, route2_rev) || ...
               isSubsequence(route2, route1) || isSubsequence(route2, route1_rev)
                overlappingroutes = 1;
                return;
            end
        end
    end

    overlappingroutes = 0;
end

function bin = isSubsequence(r1, r2)
    bin = 0;

    if length(r1) > length(r2)
        return;
    end

    for i = 1:(length(r2) - length(r1) + 1)
        if isequal(r2(i:i+length(r1)-1), r1)
            bin = 1;
            return;
        end
    end
end