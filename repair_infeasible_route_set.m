function [feasible_solution] = repair_infeasible_route_set(infeasible_solution, s, n, DistanceMatrix)
    % Initialize
    feasible_solution = zeros(1, length(infeasible_solution));

    % Divide the routes
    [Sc] = stringToRoutes(infeasible_solution, s, n);
    route1 = cell(s, 1);
    for a = 1:s
        route1{a, 1} = BusRoute(Sc{a, :});
    end

    % Determine the missing nodes
    g = ones(1, n);
    for b = 1:n
        for c = 1:s
            route2 = route1{c, :};
            d = length(route2);
            if any(route2 == b)
                g(1, b) = 0;
                break;
            end
        end
    end

    % Identify missing nodes
    M = find(g == 1);

    % Get the neighbors of each missing node (precompute neighbors for faster lookup)
    neighbors = cell(1, n);
    for i = 1:n
        neighbors{i} = find(DistanceMatrix(i, :) ~= 0 & DistanceMatrix(i, :) ~= Inf);
    end

    % Cell array to store the new feasible routes
    new_route_cell = cell(s, 1);

    % Checking each missing node and its neighbors
    replaced_route_no = [];
    for i1 = 1:length(M)
        missing_node = M(i1);
        possible_neighbors = neighbors{missing_node}; % Get all neighbors for the missing node

        % Check each neighbor for possible insertion in routes
        for j1 = 1:length(possible_neighbors)
            neighbor = possible_neighbors(j1);

            % Loop through routes to find feasible insertion
            for k1 = 1:s
                route3 = route1{k1, 1}; % Current route

                if ismember(neighbor, route3)
                    p = getNodePositionInARoute(route3, neighbor);
                    lenr = length(route3);
                    new_route = zeros(1, lenr + 1);

                    % Handle cases where neighbor is at the start or end
                    if p == lenr
                        new_route(1, 1:lenr) = route3;
                        new_route(1, lenr + 1) = missing_node;
                        new_route_cell{k1, 1} = new_route;
                        replaced_route_no = [replaced_route_no, k1];
                        break;
                    elseif p == 1
                        new_route(1, 1) = missing_node;
                        new_route(1, 2:lenr + 1) = route3;
                        new_route_cell{k1, 1} = new_route;
                        replaced_route_no = [replaced_route_no, k1];
                        break;
                    else
                        % Try to insert the missing node with two repair strategies
                        feasible_route1 = correct_infeasible_route_case1(missing_node, neighbor, p, route3, DistanceMatrix);
                        if feasible_route1 ~= 0
                            new_route = feasible_route1;
                            new_route_cell{k1, 1} = new_route;
                            replaced_route_no = [replaced_route_no, k1];
                            break;
                        else
                            feasible_route2 = correct_infeasible_route_case2(missing_node, neighbor, p, route3, DistanceMatrix);
                            if feasible_route2 ~= 0
                                new_route = feasible_route2;
                                new_route_cell{k1, 1} = new_route;
                                replaced_route_no = [replaced_route_no, k1];
                                break;
                            end
                        end
                    end
                end
            end
        end
    end

    % Sort and update feasible solution
    replaced_route_no = unique(replaced_route_no);

    for g2 = 1:s
        if ~isempty(new_route_cell{g2, 1})
            a3 = n * (g2 - 1) + 1;
            b3 = n * (g2 - 1) + length(new_route_cell{g2, 1});
            feasible_solution(1, a3:b3) = new_route_cell{g2, 1};
        end
    end

    for f2 = 1:s
        if ~ismember(f2, replaced_route_no)
            a2 = n * (f2 - 1) + 1;
            b2 = n * (f2 - 1) + n;
            feasible_solution(1, a2:b2) = infeasible_solution(1, a2:b2);
        end
    end

    % Final feasibility check
    bin = checkFeasibility(feasible_solution, s, n);
    if bin == 0
        feasible_solution = 0;
    end
end
