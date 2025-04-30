% Inputs:
%  1. solution_vector - route set in a row vector form
%  2. s - no. of routes in the network
%  3. n - no. of nodes
% -------------------------------------------------------------------------

function displayRouteSet(solution_vector,s,n)
    %divide into routes
    k = 1;
    for j = 1:s
        draft_route = solution_vector(1, k:k+n-1);
        C = nonzeros(draft_route)';
        fprintf('%d-', C(1:end-1));  % Print all but the last element with '-'
        fprintf('%d |', C(end));     % Print the last element
        k = k + n;
    end
    fprintf('\n');
end