% Inputs:
%  1. route_set - cell array
%  2. s - no. of routes in the network
%  3. n - no. of nodes
% Output: 
%  1. connected = 1 if resulting graph of route set is connected, 
%                 0 if otherwise
% -------------------------------------------------------------------------

function connected = checkConnectedness(route_set,s,n)

    % Listing the routes in Matrix Form
    B = cell2mat(route_set(:,1));

    % Defining a graph G
    edge_start = []; edge_end = [];
    for t=1:s
        bus_route = functionRoute(B(t,:));
        for q=1:length(bus_route)-1
            edge_start = [edge_start bus_route(1,q)];
            edge_end = [edge_end bus_route(1,q+1)];
        end
    end

    G = graph(edge_start, edge_end);
    
    % Find connected components
    bins = conncomp(G);

    % Check connectivity
    connected = double(sum(bins) == n);

end