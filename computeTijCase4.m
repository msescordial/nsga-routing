function [tij]=computeTijCase4(i,j,routei, routef1, routef2, routej, transfer_time, TimeMatrix)

    % Initialization
    tij = Inf; 
    
    v1 = 1;
    h1 = zeros(1,1);     % vector of common nodes of routei and routef1

    v2 = 1;
    h2 = zeros(1,1);     % vector of common nodes of routef1 and routef2
    
    v3 = 1;
    h3 = zeros(1,1);     % vector of common nodes of routef2 and routej
    
    for p1 = 1:length(routei)
        for q1 = 1:length(routef1)
            if (routei(p1) == routef1(q1))
                h1(1,v1) = routei(1,p1);     % common node 
                v1 = v1+1;
            end
        end
    end
    
    for p2 = 1:length(routef1)
        for q2 = 1:length(routef2)
            if (routef1(p2) == routef2(q2))
                h2(1,v2) = routef1(1,p2);     % common node 
                v2 = v2+1;
            end
        end
    end

    for p3 = 1:length(routef2)
        for q3 = 1:length(routej)
            if (routef2(p3) == routej(q3))
                h3(1,v3) = routef2(1,p3);     % common node 
                v3 = v3+1;
            end
        end
    end

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
