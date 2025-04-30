function [SolutionTimeMatrix, ntransfer] = getRouteSetTimeMatrix(S0r,s,TimeMatrix, transfer_time)

valid = 0;

while (valid ~= 1)

    n = size(TimeMatrix,1);
        
    % Initialization
    SolutionTimeMatrix = Inf([n,n]);
    TransferMatrix = Inf([n,n]);
    
    % Listing the routes in S0 in Matrix Form
    B = zeros(s,n);
    for t=1:s
        B(t,:) = S0r{t,1};        % all s bus routes
    end
    % fprintf('B: \n'); disp(B);
    
    
    % Determining the Shortest Time from Node i to Node j

    % 1. Diagonals must be zero
    for i=1:n
        SolutionTimeMatrix(i,i) = 0; 
        TransferMatrix(i,i)=0;
    end 
    
    % 2. Identifying Routes which contain Node i and Node j, respectively 
    %    and Case 1: No Transfer is Needed
    for i=1:n
    for j=1:n
        if (i ~= j)
        % Identifying the Routes where Nodes i and j are in  
        f1 = 1;
        f2 = 1;
        rin = zeros(1,f1);       % vector which stores the routei nos.
        rjn = zeros(1,f2);       % vector which stores the routej nos.
        for p=1:s
            routep = functionRoute(B(p,:));                    
            if (ismember(i,routep) == 1)       % node i is in route p
                rin(1,f1) = p;      
                f1 = f1+1;
            end
            if (ismember(j,routep) == 1)       % node j is in route p
                rjn(1,f2) = p;
                f2 = f2+1;
            end
        end    
            
        % Case 1: No Transfer is Needed;
        if ((sum(rin) ~= 0 && sum(rjn) ~= 0) && sum(ismember(rin,rjn)) > 0)     % common route

            f3 = 1;
            crn = zeros(2,f3);
            for u=1:length(rin)
            for v=1:length(rjn)
                if (rin(u) == rjn(v))
                crn(1,f3) = rin(u); 
                f3 = f3 + 1;
                end
            end
            end
      
            [r1 c1] = size(crn);
            %disp("Meow"); disp(crn);
            for w = 1:c1
                p1 = crn(1,w);
                common_route = functionRoute(B(p1,:));
                crn(2,w) = computeTijCase1(i,j,common_route, TimeMatrix);
            end
            SolutionTimeMatrix(i,j) = min(crn(2,:));
            TransferMatrix(i,j)=0;
            
        elseif ((sum(rin) ~= 0 && sum(rjn) ~= 0) && sum(ismember(rin,rjn)) == 0)   % there is no common route

            f4 = 1;
            crn2 = zeros(3,f4);
            for u = 1: length(rin)
            for v = 1: length(rjn)
                pi = rin(1,u); 
                pj = rjn(1,v); 
                routei = functionRoute(B(pi,:)); 
                routej = functionRoute(B(pj,:)); 
                    
                if (sum(ismember(routei,routej)) > 0)   % there is at least one common node
                    % Case 2: One Transfer is Needed
                    crn2(1,f4) = pi;
                    crn2(2,f4) = pj;
                    crn2(3,f4) = computeTijCase2(i,j, routei, routej, transfer_time, TimeMatrix);
                    f4 = f4+1;
                    SolutionTimeMatrix(i,j) = min(crn2(3,:)); 
                    TransferMatrix(i,j)=1;
                end       
            end
            end                 
        end
        end
    end
    end

    %disp("Meow After 0 or 1 Transfer, no. of inf, no. of excess zeroes"); 
    %disp(sum(sum(ismember(SolutionTimeMatrix,Inf))));
    %disp(sum(sum(ismember(SolutionTimeMatrix,0)))-149);
    
        
    % 3. Case 3: Two Transfers Are Needed
    for i=1:n
    for j=1:n
         if ( abs(i-j) > 0 ) 
         if (SolutionTimeMatrix(i,j) == Inf)
            f5 = 1;
            f6 = 1;
            rin = zeros(1,f5);       % vector which stores the routei nos.
            rjn = zeros(1,f6);       % vector which stores the routej nos.
            for p1=1:s
                routep = functionRoute(B(p1,:));                    
                if (ismember(i,routep) == 1)       % node i is in route p
                    rin(1,f5) = p1;
                    f5 = f5+1;
                end
                if (ismember(j,routep) == 1)       % node j is in route p
                    rjn(1,f6) = p1;
                    f6 = f6+1;
                end
            end   
            
            if ((sum(rin) ~= 0 && sum(rjn) ~= 0) && sum(ismember(rin,rjn)) == 0)

                f7=1;
                crn3 = zeros(4,f7);

                for u3 = 1: length(rin)
                for v3 = 1: length(rjn)
            	    pi3 = rin(1,u3); 
                    pj3 = rjn(1,v3);
                    routei = functionRoute(B(pi3,:));
                    routej = functionRoute(B(pj3,:)); 
                
                    % getting the possible transfer routes
                    % (excluding pi3 and pj3)
                    f8 = 1;
                    tr = zeros(1,f8);
                    for g=1:s
                        if ( abs(g - pi3) > 0 && abs(g - pj3) > 0)
                            tr(1,f8) = g;
                            f8 = f8 + 1;
                        end
                    end
                
                    for g1 = 1: length(tr)
                	    ptf = tr(g1);
                        routetf = functionRoute(B(ptf,:));

                        if (sum(ismember(routei,routetf))>0 && sum(ismember(routej,routetf))>0) 

                            routef = routetf;
                            crn3(1,f7) = pi3;
                            crn3(2,f7) = ptf;
                            crn3(3,f7) = pj3;
                            crn3(4,f7) = computeTijCase3(i,j,routei, routef, routej, transfer_time, TimeMatrix);
                            f7 = f7 + 1;
                        end                               
                    end


                end
                end



                SolutionTimeMatrix(i,j) = min(crn3(4,:));
                if (SolutionTimeMatrix(i,j) == 0)
                    SolutionTimeMatrix(i,j) = Inf;
                else
                    TransferMatrix(i,j)=2;
                end
                
            else
                SolutionTimeMatrix(i,j) = Inf;
            end
                   
         end            
         end
    end
    end

    %disp("Meow After 2 Transfers, no. of inf, no. of excess zeroes"); 
    %disp(sum(sum(ismember(SolutionTimeMatrix,Inf))));
    %disp(sum(sum(ismember(SolutionTimeMatrix,0)))-149);

    
    % Case 4: Three Transfers are Needed
    for i=1:n
    for j=1:n
         if ( abs(i-j) > 0 ) 
         if (SolutionTimeMatrix(i,j) == Inf) 
            
            %fprintf('\n3 transfers: %d and %d',i,j)
            f8 = 1;
            f9 = 1;
            rin = zeros(1,f8);       % vector which stores the routei nos.
            rjn = zeros(1,f9);       % vector which stores the routej nos.
            for p2=1:s
                routep = functionRoute(B(p2,:));  
                mi = ismember(routep,i);
                mj = ismember(routep,j);                   
                if (sum(mi) == 1)       % node i is in route p2
                    rin(1,f8) = p2;
                    f8 = f8+1;
                end
                if (sum(mj) == 1)       % node j is in route p2
                    rjn(1,f9) = p2;
                    f9 = f9+1;
                end
            end   
            
            %disp("rin,rjn"); disp(rin); disp(rjn);
            if ((sum(rin) ~= 0 && sum(rjn) ~= 0) && sum(ismember(rin,rjn)) == 0) 

                f11=1;
                crn4 = zeros(5,f11);

                for u4 = 1: length(rin)
                for v4 = 1: length(rjn)
            	    pi4 = rin(1,u4); 
                    pj4 = rjn(1,v4);
                    routei = functionRoute(B(pi4,:));
                    routej = functionRoute(B(pj4,:)); 
                
                    % getting the possible transfer routes (in pairs)
                    % (excluding pi4 and pj4)
                    f10 = 1;
                    tr = zeros(1,f10);
                    for g=1:s
                        if ( abs(g - pi4) > 0 && abs(g - pj4) > 0)
                            tr(1,f10) = g;
                            f10 = f10 + 1;
                        end
                    end              
                    tr2 = nchoosek(tr,2)';
                
                
                    [r c] = size(tr2);
                    for g1 = 1:c
                	    ptf1 = tr2(1,g1);
                        ptf2 = tr2(2,g1);
                        routetf1 = functionRoute(B(ptf1,:));
                        routetf2 = functionRoute(B(ptf2,:));
                        if (sum(ismember(routei,routetf1))>0 && sum(ismember(routetf1,routetf2))>0 && sum(ismember(routetf2,routej))>0) 
                            routef1 = routetf1;
                            routef2 = routetf2;
                            crn4(1,f11) = pi4;
                            crn4(2,f11) = ptf1;
                            crn4(3,f11) = ptf2;
                            crn4(4,f11) = pj4;
                            crn4(5,f11) = computeTijCase4(i,j,routei, routef1, routef2, routej, transfer_time, TimeMatrix);
                            f11 = f11 + 1;
                        end                               
                    end

                end
                end

                SolutionTimeMatrix(i,j) = min(crn4(5,:));
                %disp("Time is:"); disp(min(crn4(5,:)));

                if (SolutionTimeMatrix(i,j) == 0)
                    SolutionTimeMatrix(i,j) = Inf;
                else
                    %fprintf("\n %d %d", i,j); disp(crn4);
                    TransferMatrix(i,j)=3;
                end
                
            else
                %fprintf("\n %d %d", i,j);
                SolutionTimeMatrix(i,j) = Inf;

            end
                   
         end            
         end
    end
    end

    % Transfer Matrix
    ntransfer = zeros(1,5);
    ntransfer(1,1) = sum(sum(ismember(TransferMatrix,0)));  
    ntransfer(1,2) = sum(sum(ismember(TransferMatrix,1)));
    ntransfer(1,3) = sum(sum(ismember(TransferMatrix,2)));
    ntransfer(1,4) = sum(sum(ismember(TransferMatrix,3)));
    ntransfer(1,5) = sum(sum(ismember(TransferMatrix,Inf)));
    
    %disp("After 3 Transfers, no. of inf, no. of excess zeroes"); 
    %disp(sum(sum(ismember(SolutionTimeMatrix,Inf))));
    %disp(sum(sum(ismember(SolutionTimeMatrix,0)))-149);
    %disp(SolutionTimeMatrix);

    n = 149;

    if (sum(sum(ismember(SolutionTimeMatrix,0))) == n)
        valid = 1;
    end

end

end