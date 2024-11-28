function SolutionTimeMatrix = getRouteSetTimeMatrix(S0r,s,TimeMatrix, transfer_time)

    fprintf('generating route set time matrix...');

    n = size(TimeMatrix,1);
        
    %% Initialization
    SolutionTimeMatrix = Inf([n,n]);    %disp(SolutionTimeMatrix);
    
    % Listing the routes in S0 in Matrix Form
    B = zeros(s,n);
    for t=1:s
        B(t,:) = S0r{t,1};        % all s bus routes
    end
    %fprintf('B: \n'); disp(B);
    
    
    %% Determining the Shortest Time from Node i to Node j

    % 1. Diagonals must be zero
    for i=1:n
    for j=1:n
        if (i == j)
        	SolutionTimeMatrix(i,j) = 0; 
        end
    end
    end

    %disp("SolutionTimeMatrix After Case 1"); disp(SolutionTimeMatrix); 
    
    %% 2. Determining the shortest time between Node i and Node j using
    % Shortest Path
    
    % first, given the route set, build a route network matrix
    adjacency_matrix = zeros(n,n);
    route_network_matrix = zeros(n,n);
    for t=1:s                   % for all s bus routes
        route = B(t,:);
        nn = nnz(route); 
        final_route = B(t,1:nn);
        for i=1:nn-1            % for each route
            a = final_route(1,i);
            b = final_route(1,i+1);
            adjacency_matrix(a,b) = 1; 
            adjacency_matrix(b,a) = 1;
            route_network_matrix(a,b) = TimeMatrix(a,b);
            route_network_matrix(b,a) = TimeMatrix(b,a);
        end
    end
    %disp("Adjacency Matrix:"); disp(adjacency_matrix);
    %disp("Route Network Matrix:"); disp(route_network_matrix);

    % second, given the route_network_matrix, define a graph G
    edge_start = []; edge_end = []; edge_weight = [];
    for i=1:n
        for j=1:i
            if (route_network_matrix(i,j) ~= 0)
                edge_start = [edge_start i];
                edge_end = [edge_end j];
                edge_weight = [edge_weight route_network_matrix(i,j)];
            end
        end
    end 
    %disp("List of Edges"); disp(edge_start); disp(edge_end);

    G = graph(edge_start, edge_end, edge_weight);

    % Plot Route Network Graph
    %plot(G,'EdgeLabel',G.Edges.Weight);


    % Determine the Shortest Path between all pairs of nodes
    for i=1:n
        for j=1:n
            [Path,Time] = shortestpath(G,i,j); 

            % Determine the no. of transfers
            isin_mat = zeros(s,length(Path));
            for t=1:s                   % for all s bus routes
                route = B(t,:);
                final_route = nonzeros(route)';
                isin = ismember(Path,final_route);
                isin_mat(t,:) = isin;
            end
            % for debugging
            %if (i==1 && j==100)
            %    disp(Path); disp(isin_mat);
            %    n_transfer = getNumberOfTransfers(s,isin_mat,Path);
            %    disp(n_transfer);
            %end

            n_transfer = getNumberOfTransfers(s,isin_mat,Path);
            fprintf('\nNo. of transfers between %d and %d: %d', i,j,n_transfer);

            %if (n_transfer == Inf)
            %    disp(Path);
            %end

            % Final Answer
            SolutionTimeMatrix(i,j) = Time + (n_transfer*transfer_time);
        end
    end
    %disp("Route Set Time Matrix"); disp(SolutionTimeMatrix);

end