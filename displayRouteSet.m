% Inputs:
%  1. solution_vector - route set in a row vector form
%  2. s - no. of routes in the network
%  3. n - no. of nodes
% -------------------------------------------------------------------------

function displayRouteSet(solution_vector,s,n)
    %divide into routes
    k = 1;
    for j=1:s
        draft_route = solution_vector(1,k:k+n-1);
        C = nonzeros(draft_route)';
        for q=1:length(C)-1
            fprintf('%d-',C(1,q));
        end
        fprintf('%d |', C(1,length(C)));
        k = k + n;
    end
    fprintf('\n');
end