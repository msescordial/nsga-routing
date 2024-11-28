% Inputs:
%  1. M - matrix of size r-by-c where r = population_size and c = s*n
%  2. n - no. of nodes
% -------------------------------------------------------------------------

function displayPopulation(M,n)
    [r c] = size(M);
    s = c/n;    % no. of routes     
    for i=1:r
        %divide into routes
        k = 1;
        for j=1:s
            draft_route = M(i,k:k+n-1);
            C = nonzeros(draft_route)';
            for q=1:length(C)-1
                fprintf('%d-',C(1,q));
            end
            fprintf('%d |', C(1,length(C)));
            k = k + n;
        end
        fprintf('\n');
    end  
end