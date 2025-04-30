function [tij]=computeTijCase4(i,j,routei, routef1, routef2, routej, transfer_time, TimeMatrix)

    % Initialization
    h1 = intersect(routei, routef1);
    h2 = intersect(routef1, routef2);
    h3 = intersect(routef2, routej);

    k1 = length(h1);  
    k2 = length(h2); 
    k3 = length(h3);
            
    % Matrix M of travel times
    % 1st ato 3rd row: node h1, h2, and h3   (all possible combinations)
    % 4th row: travel time between nodes i and h1
    % 5th row: travel time between nodes h1 and h2
    % 6th row: travel time between nodes h2 and h3
    % 7th row: travel time between nodes h3 and h4
    % 8th row: Total travel time between nodes i and j
    
    M = zeros(8,k1*k2*k3);  
    %disp("h"); disp(h1); disp(h2); disp(h3);
    
    % 1st to 3rd row of M:
    M(1:3,:) = table2array(combinations(h1,h2,h3))';
    %disp("M"); disp(M);
      
    % 4th to 7th row of M  
    for a=1:k1*k2*k3
        [tih1]=computeTijCase1(i,M(1,a),routei, TimeMatrix);
        M(4,a)=tih1;
        [th1h2]=computeTijCase1(M(1,a),M(2,a),routef1, TimeMatrix);
        M(5,a)=th1h2;
        [th2h3]=computeTijCase1(M(2,a),M(3,a),routef2, TimeMatrix);
        M(6,a)=th2h3;
        [th3j]=computeTijCase1(M(3,a),j,routej, TimeMatrix);
        M(7,a)=th3j;
    end
    
    % 8th row of M
    for d=1:k1*k2*k3
        M(8,d)=M(4,d)+ transfer_time + M(5,d) + transfer_time + M(6,d) + transfer_time + M(7,d);
    end
    
    %disp("i"); disp("j"); disp(i); disp(j);
    %disp("M"); disp(M); 
    tij = min(M(8,:)); %disp("tij"); disp(tij);
end