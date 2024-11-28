% Inputs:
%  1. route1 - row vector
%  2. route2 - row vector
% Outputs: 
%  1. b = 1 if there is a common node,  
%         0 if otherwise
%  2. h = row vector of common nodes
% -------------------------------------------------------------------------

function [b, h] = getCommonNodes(route1, route2)
    % getting the common node(s)?
    v = 1;
    h = zeros(1,1);     % vector of common nodes of routei and routej 
    for p = 1:length(route1)
        for q = 1:length(route2)
            if (route1(p) == route2(q))
                h(1,v) = route1(1,p);     % common node 
                v = v+1;
            end
        end
    end
    
    %disp(h);
    
    if (h == 0)
        b = 0;
    else
        b = 1;
    end
end
