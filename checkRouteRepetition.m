% Inputs:
%  1. route_set - cell array
%  2. s - no. of routes in the network
%  3. n - no. of nodes
% Output: 
%  1. repeatedroutes = 1 if resulting route set has repeated routes
%                    = 0 if all routes are unique
% -------------------------------------------------------------------------

function repeatedroutes = checkRouteRepetition(route_set, s, n)
    
    R = cell(s, 1);
    for t = 1:s
        R{t} = functionRoute(route_set{t});
    end

    % Check for duplicates
    for t = 1:s
        route1 = R{t};
        for q = t+1:s
            route2 = R{q};
            if (isequal(route1, route2) || isequal(route1, flip(route2)))
                repeatedroutes = 1;
                return;
            end
        end
    end

    % No repeats found
    repeatedroutes = 0;
end
