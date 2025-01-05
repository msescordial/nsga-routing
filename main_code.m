clc
clear

tic

% Constraints
min_route_length = 4;
max_route_length = 23; 

% Network (Choices: mandl, india, metro_manila)
network_name = "metro_manila"; 

if (network_name == "metro_manila")
    incorporate_metro = 1;
    [DistanceMatrix,TimeMatrix,TravelDemandMatrix,TerminalNodes,k_kSP,s,transfer_time, metro_line]=network_metro_manila();
elseif (network_name == "mandl")
    incorporate_metro = 0;
    metro_line = [];
    [DistanceMatrix,TimeMatrix,TravelDemandMatrix,TerminalNodes,k_kSP,s,transfer_time]=network_mandl();
elseif (network_name == "india")
    incorporate_metro = 0;
    metro_line = [];
    [DistanceMatrix,TimeMatrix,TravelDemandMatrix,TerminalNodes,k_kSP,s,transfer_time]=network_india(); 
end

n = size(DistanceMatrix,1);         % n = no. of nodes

% Genetic Algorithm    
[front_pop] = NSGA_2(min_route_length, max_route_length, network_name, DistanceMatrix, TimeMatrix, TravelDemandMatrix, ...
    TerminalNodes, k_kSP, s, transfer_time, n, metro_line, incorporate_metro);

if (network_name == "metro_manila")
    % Compare to real-world routes
    s = 26;
    real_routes(TravelDemandMatrix, DistanceMatrix, TimeMatrix, transfer_time, s, n);
end

toc