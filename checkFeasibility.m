% Inputs:
%  1. solution_vector - route set in a row vector form
%  2. s - no. of routes in the network
%  3. n - no. of nodes
% Output: 
%  1. bin = 1 if the route set is feasible, 
%           0 if otherwise
% -------------------------------------------------------------------------

function bin = checkFeasibility(solution_vector,s,n)

    % All nodes must be in the route set
    % check for missing nodes
    missing = setdiff(1:n, nonzeros(solution_vector));
    bin = isempty(missing);

end