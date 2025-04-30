function [Fmin,Fmax,Fmed,front_pop_final] = sortParetoFront(F1)

front_pop = cell(numel(F1),6);
for g=1:numel(F1)
    front_pop{g,1}=F1(g).Position; 
    front_pop{g,2}=F1(g).ActualCost;
    front_pop{g,3}=F1(g).ActualCost;
    front_pop{g,4}=[F1(g).Transfer];
end

actcost = [F1.ActualCost]';
%disp(actcost);
for g=1:numel(F1)
    actcostvec = actcost(g,:);
    front_pop{g,5}=actcostvec(1,1);
    front_pop{g,6}=actcostvec(1,2);
end

front_pop_sorted = sortrows(front_pop,[5,6]);
%disp("Front Pop Sorted"); disp(front_pop_sorted);

% Get unique rows
[nr, ~] = size(front_pop_sorted);
front_pop_final = cell(1,6);
front_pop_final(1,:) = front_pop_sorted(1,:);
w = 2;
for k=2:nr
    A = isequal(front_pop_sorted{k,3},front_pop_sorted{k-1,3});
    if (A == 0)    % unequal rows
        front_pop_final(w,:) = front_pop_sorted(k,:);
        w = w + 1;
    end
end

disp("Front Pop Final"); disp(front_pop_final);

%% Get Fmin, Fmax, Fmed
[nr2, ~] = size(front_pop_final);

Fmin = front_pop_final(1,:);
Fmax = front_pop_final(nr2,:);
%disp("Fmin, Fmax"); disp(Fmin); disp(Fmax);

E_first = front_pop_final{1,3};      % E = [E1; E2]
E_last  = front_pop_final{nr2,3};
E1_max = E_last(1);                 % From first solution
E2_max = E_first(2);                  % From last solution
%disp("E1_max, E2_max"); disp(E1_max); disp(E2_max);

% Fmed: normalize first
lambda = 0.5;
E_matrix = cell2mat([front_pop_final(:,5), front_pop_final(:,6)]);  
E1_all = E_matrix(:,1)';                    
E2_all = E_matrix(:,2)';                    

%disp(E_matrix); disp(E1_all); disp(E2_all);

% Compute normalized objective values
scores = (E1_all / E1_max) + lambda * (E2_all / E2_max);
%disp(scores);

% Assign back to column 7
front_pop_final(:,7) = num2cell(scores);

%disp(front_pop_final);

[~, idx] = min(cell2mat(front_pop_final(:,7)));
Fmed = front_pop_final(idx, :);
%disp("Fmed"); disp(Fmed);

end