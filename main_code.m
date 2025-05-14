clc
clear

tic
    
network_name = "metro_manila"; 

% Constraints
min_route_length = 6.30;        
max_route_length = 26.20;       
incorporate_metro = 1;

[DistanceMatrix,TimeMatrix,TravelDemandMatrix,TerminalNodes,k_kSP,s,transfer_time, metro_line]=network_metro_manila();

n = size(DistanceMatrix,1);         % n = no. of nodes

% Genetic Algorithm    
[front_pop] = NSGA_2(min_route_length, max_route_length, network_name, DistanceMatrix, TimeMatrix, TravelDemandMatrix, ...
    TerminalNodes, k_kSP, s, transfer_time, n, metro_line, incorporate_metro);


% Compare to existing real-world route set
%real_routes(TravelDemandMatrix, DistanceMatrix, TimeMatrix, transfer_time, 26, n);

toc