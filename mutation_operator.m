function new_node = mutation_operator(node, DistanceMatrix, vec, n)

    B = setdiff(1:n, vec);  % nodes not in current path

    pos = find(vec == node, 1);

    if isempty(pos)
        new_node = node;
        return;
    end

    if pos == 1
        aft = vec(2);
        valid_nodes = B(DistanceMatrix(B, aft) ~= Inf & DistanceMatrix(B, aft) ~= 0);

        if isempty(valid_nodes)
            new_node = node;
        else
            new_node = selectClosest(valid_nodes, aft, DistanceMatrix);
        end

    elseif pos == length(vec)
        bef = vec(end-1);
        valid_nodes = B(DistanceMatrix(B, bef) ~= Inf & DistanceMatrix(B, bef) ~= 0);

        if isempty(valid_nodes)
            new_node = node;
        else
            new_node = selectClosest(valid_nodes, bef, DistanceMatrix);
        end

    else
        bef = vec(pos-1);
        aft = vec(pos+1);

        vicinity_nodes = B(DistanceMatrix(bef, B) ~= Inf & DistanceMatrix(bef, B) ~= 0);

        if isempty(vicinity_nodes)
            new_node = node;
            return;
        end

        candidates = vicinity_nodes(DistanceMatrix(vicinity_nodes, aft) ~= Inf & DistanceMatrix(vicinity_nodes, aft) ~= 0);

        if ~isempty(candidates)
            new_node = selectClosest(candidates, aft, DistanceMatrix);
            return;
        end

        vici = vicinity_nodes(randi(length(vicinity_nodes)));
        k_paths = 5;
        [shortestPaths, totalCosts] = kSP(DistanceMatrix, vici, aft, k_paths);

        for h = 1:k_paths
            path = shortestPaths{h};
            if isempty(path)
                continue;
            end
            intermediate_nodes = path(1:end-1);
            if all(~ismember(intermediate_nodes, vec))
                new_node = intermediate_nodes(1);
                return;
            end
        end

        new_node = node;
    end

end

function chosen = selectClosest(candidates, target, DistanceMatrix)
    % Pick the closest node among candidates
    dists = DistanceMatrix(candidates, target);
    [~, idx] = min(dists);  % find minimum distance
    chosen = candidates(idx);
end