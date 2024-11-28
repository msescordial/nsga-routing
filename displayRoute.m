% Input:
%   draft_route - row vector
% -------------------------------------------------------------------------

function displayRoute(draft_route)
    [m n] = size(draft_route);

    if (m == 1)
        C = nonzeros(draft_route)';
        % disp(C);
        for i=1:length(C)-1
            fprintf('%d-',C(1,i));
        end
        fprintf('%d\n',C(1,length(C)));
    end
end
