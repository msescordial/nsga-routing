function n_transfer = getNumberOfTransfers(s,isin_mat,Path)
 
    n_transfer = inf;
    % Case 1: no transfer
    S_rows = sum(isin_mat,2); %disp(S_rows);
    if ismember(length(Path),S_rows)
        n_transfer = 0;
    end

    % Case 2: has transfers
    if (n_transfer ~=0)
        v = zeros(1,s);
        for t=1:s
            v(1,t) = t;
        end
        stop = 0;
        n_routes = 2; 

        while (stop == 0 && n_routes <= s)
            % Define a matrix c_mat with all possible combinations
            %disp("n_routes"); disp(n_routes);
            c_mat = nchoosek(v,n_routes); 
            %disp("c_mat"); disp(c_mat);

            % Assess each row of c_mat
            [r c] = size(c_mat);
            
            for i=1:r
                if (n_transfer ~= inf)
                    break;
                end
                A = zeros(n_routes,length(Path));
                random_rows = c_mat(i,:);
                for j=1:n_routes
                    A(j,:) = isin_mat(random_rows(1,j),:);
                end
                sumA = sum(A);                     % get the column-wise sum

                if nnz(sumA) == length(Path)
                    %disp("sumA"); disp(sumA); 
                    if sum(sumA) > length(Path)    % there is at least a common node
                        
                        % vector of indices of nodes
                        vin = [];         
                        for p=1:n_routes
                            icn = find(A(p,:));
                            vin = [vin icn];
                        end

                        % vector of indices of common nodes 
                        % (except the start and end of path)
                        vicn = [];
                        for q=1:length(Path)
                            m = sum(ismember(vin,q));
                            if m > 1         % index of node repeats
                                vicn = [vicn q];                
                            end
                        end
                        vicn = setdiff(vicn,[1, length(Path)]);

                        if isscalar(vicn)           % scalar: one common node
                            n_transfer = 1;         % one transfer
                        end
                        
                        if (n_transfer ~= 1)
                            n_transfer = n_routes - 1;  % TO ADD
                        end
                        if (n_transfer == 1 )
                            fprintf('\n'); disp("Path"); disp(Path); disp("A"); disp(A);
                            fprintf('\n'); %disp("vin"); disp(vin); 
                            disp("vicn"); disp(vicn);
                        end
                        stop = 1;
                    end
                end
            end
            n_routes = n_routes + 1;
        end
    end

    %disp(n_transfer);

end