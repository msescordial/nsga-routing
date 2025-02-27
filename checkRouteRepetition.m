% Inputs:
%  1. route_set - cell array
%  2. s - no. of routes in the network
%  3. n - no. of nodes
% Output: 
%  1. repeatedroutes = 1 if resulting route set has repeatedroutes
%                    = 0 if all routes are unique
% -------------------------------------------------------------------------

function repeatedroutes = checkRouteRepetition(route_set,s,n)
    % Listing the routes in Matrix Form
    B = zeros(s,n);
    for t=1:s
        B(t,:) = route_set{t,1};        % all s bus routes
    end

    A = zeros(1,1);

    % Check for Repeated Routes
    p = 1;
    for t=1:s
        route1 = functionRoute(B(t,:));
        for q=t+1:s
            route2 = functionRoute(B(q,:));
            A(1,p)= isequal(route1,route2);
            p = p+1;
        end
    end

    repeatedroutes = ismember(1,A);

end