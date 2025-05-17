function [pop_final] = getUniqueIndividuals(pop, population_size)

n = numel(pop);
pop2 = cell(n, 4);
costs = zeros(n, 2);

for g = 1:n
    pop2{g,1} = pop(g).Position;
    pop2{g,2} = pop(g).ActualCost;
    pop2{g,3} = pop(g).Transfer;
    costs(g,:) = pop(g).ActualCost';  
end

% Get unique individuals by ActualCost and sort
[~, ia, ~] = unique(costs, 'rows', 'stable');
costs_unique = costs(ia,:);
[~, sort_idx] = sortrows(costs_unique, [1, 2]);
pop_sorted = pop2(ia(sort_idx), :);

% Create final population structure
empty_individual = struct('Position', [], 'Cost', [], 'ActualCost', [], 'Transfer', [], ...
                          'Rank', [], 'DominationSet', [], 'DominatedCount', [], 'CrowdingDistance', []);
pop_final = repmat(empty_individual, size(pop_sorted,1), 1);

for g = 1:size(pop_sorted,1)
    pop_final(g).Position = pop_sorted{g,1};
    pop_final(g).ActualCost = pop_sorted{g,2};
    pop_final(g).Cost = pop_sorted{g,2};  
    pop_final(g).Transfer = pop_sorted{g,3};
end

% If unique individuals < population size, pad with non-duplicate individuals from original pop
if numel(pop_final) < population_size
    existing = cat(1, pop_final.ActualCost);
    for i = 1:n
        if size(existing,1) >= population_size
            break;
        end
        if ~ismember(pop(i).ActualCost, existing, 'rows')
            pop_final(end+1) = pop(i);
            existing = [existing; pop(i).ActualCost];
        end
    end
end

%disp([pop_final.ActualCost]');

end
