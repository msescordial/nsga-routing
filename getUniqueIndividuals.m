function [pop_final] = getUniqueIndividuals(pop, population_size)

% Extract necessary fields into a matrix
n = numel(pop);     %disp("Numel pop"); disp(n); disp(pop);
pop2 = cell(n, 6);
for g = 1:n
    pop2{g,1} = pop(g).Position;
    pop2{g,2} = pop(g).ActualCost;
    pop2{g,3} = pop(g).ActualCost;  % Possibly redundant
    pop2{g,4} = pop(g).Transfer;
    
    % Assuming ActualCost is a 1x2 vector
    pop2{g,5} = pop(g).ActualCost(1);
    pop2{g,6} = pop(g).ActualCost(2);
end

% Sort by ActualCost
pop_sorted = sortrows(pop2, [5, 6]);
%disp("Pop Sorted"); disp(pop_sorted);

% Remove duplicates based on ActualCost
% Get unique rows
[nr, ~] = size(pop_sorted);
pop3 = cell(1,6);
pop3(1,:) = pop_sorted(1,:);
w = 2;
for k=2:nr
    A = isequal(pop_sorted{k,3},pop_sorted{k-1,3});
    if (A == 0)    % unequal rows
        pop3(w,:) = pop_sorted(k,:);
        w = w + 1;
    end
end
%disp("Pop Final"); disp(pop3);

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.ActualCost=[];
empty_individual.Transfer=[];
empty_individual.Rank=[];
empty_individual.DominationSet=[];
empty_individual.DominatedCount=[];
empty_individual.CrowdingDistance=[];
pop_final=repmat(empty_individual,size(pop3,1),1);

for g=1:size(pop3,1)
    pop_final(g).Position=pop3{g,1};
    pop_final(g).Cost=pop3{g,2};
    pop_final(g).ActualCost=pop3{g,3};
    pop_final(g).Transfer=pop3{g,4};
end

m = numel(pop_final); %disp("Numel pop_final"); disp(m); disp(pop_final);

if m < population_size
    pop_final = pop;
end


end