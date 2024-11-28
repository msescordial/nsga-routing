clc
clear

tic

% Constraints
min_route_length = 3;
max_route_length = 23;

% Network (Choices: mandl, india, manila_3)
network_name = "manila_3";             
[DistanceMatrix,TimeMatrix,TravelDemandMatrix,TerminalNodes,k_kSP,s,transfer_time]=network_manila_3                                                                ();
n = size(DistanceMatrix,1);         % n = no. of nodes

% Genetic Algorithm    
[front_pop] = NSGA_2(min_route_length, max_route_length, network_name, DistanceMatrix, TimeMatrix, TravelDemandMatrix, ...
    TerminalNodes, k_kSP, s, transfer_time, n);

% Compare to real-world routes
s = 25;
real_routes(TravelDemandMatrix, DistanceMatrix, TimeMatrix, transfer_time, s, n);

toc