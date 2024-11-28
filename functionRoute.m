% Input:
%  1. draft_route - row vector
% Output:
%  1. final_route - row vector
% -------------------------------------------------------------------------

function [final_route]=functionRoute(draft_route)

    [m n] = size(draft_route);
    %fprintf('Size is %d by %d: \n',m, n);

    if (m == 1)
        final_route = nonzeros(draft_route)';
    end

end
