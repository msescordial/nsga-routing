% Inputs:
%  1. S0 - column vector of route IDs
%  2. BusRouteID - 3-column cell array
%                 (1st column: ID, 2nd column: Route, 3rd column: Cost
% -------------------------------------------------------------------------

function displayInitialRouteSet(S0,BusRouteID)
    s = size(S0,1);
    for b = 1:s
        r = S0(b,1);
        draft_route = BusRouteID{r,2};       
        fprintf('Route %d:', r);
        displayRoute(draft_route);
    end
end