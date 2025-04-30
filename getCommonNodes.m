% Inputs:
%  1. route1 - row vector
%  2. route2 - row vector
% Outputs: 
%  1. b = 1 if there is a common node,  
%         0 if otherwise
%  2. h = row vector of common nodes
% -------------------------------------------------------------------------

function [b, h] = getCommonNodes(route1, route2)

    h = intersect(route1, route2);  
    %disp(h);
    
    if isempty(h)
        b = 0;
    else
        b = 1;
    end
end
