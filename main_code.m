clc
clear

tic

% Constraints
min_route_length = 6.30;      % 6.30
max_route_length = 26.20;     % 26.20 (final) 29.20 (22 routes) % 37.43 (26 routes)
% Network (Choices: mandl, india, metro_manila)
network_name = "metro_manila"; 

if (network_name == "metro_manila")
    incorporate_metro = 1;
    [DistanceMatrix,TimeMatrix,TravelDemandMatrix,TerminalNodes,k_kSP,s,transfer_time, metro_line]=network_metro_manila();
    %s = 21;
    %k_kSP = 6;
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

%if (network_name == "metro_manila")
    % Compare to real-world routes
    %s = 26;
%    s = 22;
%    real_routes(TravelDemandMatrix, DistanceMatrix, TimeMatrix, transfer_time, 26, n);
%end

toc