% Inputs:
%  1. M - matrix of size r-by-c where r = population_size and c = s*n
%  2. n - no. of nodes
% -------------------------------------------------------------------------

function displayPopulation(M,n)
    [r, c] = size(M);
    s = c / n;  % number of routes

    for i = 1:r
        for j = 1:s
            % Divide into routes
            k = (j-1) * n + 1;
            draft_route = M(i, k:k+n-1);
            C = nonzeros(draft_route)';
            fprintf('%d-', C(1:end-1));  
            fprintf('%d |', C(end));     
        end
        fprintf('\n');
    end

end