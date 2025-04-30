% Computing Travel Time Between Node i and Node j
% Case 1: No Transfer Needed

function [tij]=computeTijCase1(i,j,common_route, TimeMatrix) 
    
    % Find positions of node i and j in the route
    pos_i = find(common_route(1,:) == i, 1);
    pos_j = find(common_route(1,:) == j, 1);
       
    % Case 1.1: Nodes i and j are adjacent to each other
    if ( abs(pos_i - pos_j) == 1 )
        tij = TimeMatrix(i,j);
 
    % Case 1.2: Nodes i and j are not adjacent to each other
    else
        if (pos_j > pos_i)
            g = common_route(1,pos_i:pos_j);
        else
            g = common_route(1,pos_j:pos_i);
        end        

        tij = sum(TimeMatrix(sub2ind(size(TimeMatrix), g(1:end-1), g(2:end))));
    end
    
    
end
