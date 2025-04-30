function [tij]=computeTijCase3(i,j,routei, routef, routej, transfer_time, TimeMatrix)

    h1 = intersect(routei, routef);
    h2 = intersect(routef, routej);
   
    k1 = length(h1);  
    k2 = length(h2); 
            
    % Matrix M of travel times
    % 1st and 2nd row: node h1 and h2   (all possible combinations)
    % 3rd row: travel time between nodes i and h1
    % 4th row: travel time between nodes h1 and h2
    % 5th row: travel time between nodes h2 and j
    % 6th row: Total travel time between nodes i and j
    
    M = zeros(6,k1*k2);  

    
    % 1st and 2nd row of M:
    for u = 1:k1
        idx = (u-1)*k2 + (1:k2);   % block of columns for current u
        M(1, idx) = h1(u);         
        M(2, idx) = h2;            
    end
      
    % 3rd row of M  
    for a=1:k1*k2
        [tih1]=computeTijCase1(i,M(1,a),routei, TimeMatrix);
        M(3,a)=tih1;
    end 
    
    % 4th row of M
    for b=1:k1*k2
        [th1h2]=computeTijCase1(M(1,b),M(2,b),routef, TimeMatrix);
        M(4,b)=th1h2;
    end
    
    % 5th row of M
    for c=1:k1*k2
        [th2j]=computeTijCase1(M(2,c),j,routej, TimeMatrix);
        M(5,c)=th2j;
    end
    
    % 6th row of M
    for d=1:k1*k2
        M(6,d)=M(3,d)+ transfer_time + M(4,d) + transfer_time + M(5,d);
    end   
    
    %disp("i"); disp("j"); disp(i); disp(j);
    %disp("M"); disp(M); 
    tij = min(M(6,:)); %disp("tij"); disp(tij);
end