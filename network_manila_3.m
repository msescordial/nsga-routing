function [DistanceMatrix,TimeMatrix,TravelDemandMatrix,TerminalNodes,k,s,transfer_time]=network_manila_3()

%------------------------------ Remarks: ----------------------------------
% Network Inputs: 
%  d = Stop-to-Stop Distance Matrix
%  T = Stop-to-Stop Time Matrix
%  D = Travel Demand Matrix
%  t = Terminal Nodes
%  k = for k-shortest paths algorithm: this refers to the first k
%    shortest paths
%  s = no. of bus routes for the network
%  transfer_time = time for each transfer (constant)

size = 144;     % no. of nodes
% T
load("final_time.mat","-mat");
TimeMatrix = array;
for i=1:size
    for j=1:size
        if abs(i-j)>0
            if TimeMatrix(i,j) == 0
                TimeMatrix(i,j) = inf;
            end
        end
    end
end
disp("Time Matrix"); disp(TimeMatrix);


% d
load("final_distance.mat","-mat");
DistanceMatrix = array;
for i=1:size
    for j=1:size
        if abs(i-j)>0
            if DistanceMatrix(i,j) == 0
                DistanceMatrix(i,j) = inf;
            end
        end
    end
end
disp("Distance Matrix"); disp(DistanceMatrix);

% D 
load("final_demand.mat","-mat");
TravelDemandMatrix = array;
disp("Travel Demand Matrix"); disp(TravelDemandMatrix);

% t (34 nodes)
TerminalNodes = ([2, 4, 5, 7, 8, 9, 17, 21, 29, 34, 39, 43, 51, 55, 58, 66, 72, ...
    83, 94, 100, 103, 106, 113, 119, 121, 122, 126, 143, 95, 47, 19, 107, 123, 14]);


k = 4;                  % k shortest Paths for each node to node
s = 25;                 % no. of routes in a bus network
transfer_time = 5;      % transfer time is 5 minutes

end

