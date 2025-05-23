function real_routes(TravelDemandMatrix, DistanceMatrix, TimeMatrix, transfer_time, s, n)

    S0r = [];
    S0r{1,1} = [34, 35, 36, 37, 38, 39, zeros(1,143)];
    S0r{2,1} = [34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 1, 2, 136, 3, 4, zeros(1,129)];
    S0r{3,1} = [113, 114, 115, 111, 110, 109, 108, 107, 102, 103, zeros(1,139)];
    S0r{4,1} = [94, 125, 96, 139, 97, 98, 101, 141, 102, 103, 104, 105, 106, zeros(1,136)];
    S0r{5,1} = [95, 94, 140, 93, 92, 135, 91, 90, 89, 88, 67, 122, 44, 45, 46, 47, 48, 5, zeros(1,131)];
    S0r{6,1} = [94, 125, 96, 139, 97, 99, 100, zeros(1,142)];
    S0r{7,1} = [126, 86, 118, 119, zeros(1,145)];
    S0r{8,1} = [126, 86, 120, 121, zeros(1,145)];
    S0r{9,1} = [126, 74, 73, 72, 71, 70, 69, 68, 138, 67, 43, zeros(1,138)];
    S0r{10,1} = [72, 75, 76, 77, 78, 81, 82, 83, zeros(1,141)];
    S0r{11,1} = [66, 65, 64, 63, 62, 61, 60, 59, 58, zeros(1,140)];
    S0r{12,1} = [21, 47, 49, 50, 137, 142, 56, 57, 55, zeros(1,140)];
    S0r{13,1} = [7, 9, 16, 17, 18, 19, 52, 49, 50, 137, 142, 51, zeros(1,137)];
    S0r{14,1} = [8, 7, 9, 16, 17, 18, 19, 52, 49, 50, 137, 142, 51, zeros(1,136)];
    S0r{15,1} = [17, 18, 19, 52, 49, 50, 137, 142, 51, zeros(1,140)];
    S0r{16,1} = [34, 33, 40, 41, 42, 43, 44, 45, 46, 47, 48, 5, zeros(1,137)];
    S0r{17,1} = [4, 12, 13, 14, 15, 5, 1, 2, zeros(1,141)];
    S0r{18,1} = [55, 57, 60, 80, 79, 78, 84, 85, 86, 87, 139, 117, 116, 111, 112, 113, zeros(1,133)];
    S0r{19,1} = [4, 11, 10, 148, 9, zeros(1,144)];
    S0r{20,1} = [4, 6, 149, 7, zeros(1,145)];
    S0r{21,1} = [55, 54, 53, 127, 17, 16, 9, 7, zeros(1,141)];
    S0r{22,1} = [126, 134, 133, 135, 91, 90, 89, 88, 67, 122, 44, 45, 46, 47, 49, 52, 19, 18, 17, 16, 9, 7, 8, zeros(1,126)];
    S0r{23,1} = [143, 144, 102, 107, 108, 124, 123, 130, 129, 128, 41, 42, 43, zeros(1,136)];
    S0r{24,1} = [29, 28, 27, 26, 25, 24, 23, 22, 21, 47, 49, 50, 137, 142, 51, 19, 18, 17, zeros(1,131)]; 
    S0r{25,1} = [122, 67, 138, 68, 69, 70, 131, 132, 75, 76, 77, 78, 81, 82, 83, zeros(1,134)];
    S0r{26,1} = [4, 3, 136, 2, 1, 5, 19, 51, 142, 145, 64, 76, 146, 126, 95, 94, 113, 114, 147, 130, 34, zeros(1,128)];
    
    %for j=1:26
    %    route = S0r{j,1};
    %    fprintf('\n'); disp(j); disp(length(route));
    %    for i=1:length(route)-1
    %        fprintf('%d-',TimeMatrix(route(1,i),route(1,i+1)));
    %    end
    %    
    %end

    for j=1:26
        dist = 0;
        route = nonzeros(S0r{j,1})'; %disp(route);
        for i=1:length(route)-1
            dist = dist + DistanceMatrix(route(1,i),route(1,i+1));
        end
        %fprintf('\n Route %d: %.2f',j,dist); 
    end

    route_set = S0r;
    %disp(route_set);

    % Plot Route Set
    figure(6);
    plotRouteSet("metro_manila",route_set,26,149);
    title('Real-world route set');

    [SolutionTimeMatrix, ntransfer] = getRouteSetTimeMatrix(route_set,s,TimeMatrix, transfer_time);
    disp(ntransfer);
    %disp(SolutionTimeMatrix);
    E0 = getObjectiveFunctionValue(route_set,TravelDemandMatrix,DistanceMatrix,SolutionTimeMatrix,n);
    fprintf('\n Objective 1: %.6f, Objective 2: %.6f \n', E0(1,1), E0(2,1)); %disp(ntransfer.*(1/n^2));

end

