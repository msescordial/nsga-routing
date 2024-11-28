% Inputs:
%  1. S1 - route set in a row vector form
%  2. s - no. of routes in the network
%  3. n - no. of nodes
% Output:
%  1. S1c - cell array of size s-by-1
% -------------------------------------------------------------------------

function [S1c] = stringToRoutes(S1,s,n)
    S1c = cell(s,1);
    p = 1;
    for q=1:s
        S1c{q,1} = S1(1,p:p+n-1);
        p = p + n;
    end
    %disp(S1c);
end