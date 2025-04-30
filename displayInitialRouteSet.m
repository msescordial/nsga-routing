% Inputs:
%  1. S0 - column vector of route IDs
%  2. BusRouteID - 3-column cell array
%                 (1st column: ID, 2nd column: Route, 3rd column: Cost
% -------------------------------------------------------------------------

function displayInitialRouteSet(S0,BusRouteID)
    for b = 1:size(S0, 1)
        r = S0(b, 1);
        fprintf('Route %d:', r);
        displayRoute(BusRouteID{r, 2});
    end
end