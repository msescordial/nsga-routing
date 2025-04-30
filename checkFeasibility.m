% Inputs:
%  1. solution_vector - route set in a row vector form
%  2. s - no. of routes in the network
%  3. n - no. of nodes
% Output: 
%  1. bin = 1 if the route set is feasible, 
%           0 if otherwise
% -------------------------------------------------------------------------

function bin = checkFeasibility(solution_vector,s,n)

    %% All nodes must be in the route set

    % Check for missing nodes
    missing = setdiff(1:n, nonzeros(solution_vector));
    bin1 = isempty(missing);

    %% Check for duplicate nodes in each route
    % convert string to routes
    route_set = stringToRoutes(solution_vector,s,n);
        
    repsum = 0;
    for c=1:s
        route = nonzeros(route_set{c,1})';
        rep = length(route)-length(unique(route));
        repsum = repsum + rep;
    end

    bin2 = repsum == 0;

%    if ~bin2
%        disp("There are same nodes in a route!");
%    end

    bin = bin1 && bin2;

end