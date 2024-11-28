clear
clc

%% Network: Manila (Import datasets)

my_csv1=readtable('data_nodes.csv');        %Reading the data
node_names = my_csv1.Node';
node_latitudes = my_csv1.Latitude';
node_longitudes = my_csv1.Longitude';
node_numbers = my_csv1.Node_Number';

my_csv2=readtable('data_edges.csv');        %Reading the data
s_numbers = my_csv2.s_Node_Number;
t_numbers = my_csv2.t_Node_Number;
edge_distance = my_csv2.distance_km;
edge_time = my_csv2.time_min;

%TimeMatrix = ; %matrix = TimeMatrix; %[m n] = size(matrix);

%% Define a graph G

% EDGES
edge_start = []; 
edge_end = [];      
edge_weight_distance = [];
edge_weight_time = [];

for i=1:height(my_csv2)          % per row of data_edges
    % starting node
    s = my_csv2{i,"s_Node_Number"};
    edge_start = [edge_start s];
    % ending node
    t = my_csv2{i,"t_Node_Number"};
    edge_end = [edge_end t];
    % weights
    distance = round(my_csv2{i, "distance_km"},2);
    edge_weight_distance = [edge_weight_distance distance];
    time = round(my_csv2{i, "time_min"},2);
    edge_weight_time = [edge_weight_time time];
end

%disp("List of Edges"); disp(edge_start); disp(edge_end);

% POSITIONS OF NODES
x = node_longitudes;
y = node_latitudes;

%G = graph(edge_start, edge_end);

% Plot Route Network Graph
%figure(1)
%plot(G,'EdgeLabel',G.Edges.Weight,'XData',x,'YData',y,...
%    'NodeFontWeight','bold', 'Marker','square','MarkerSize',6,...
%    'LineWidth',2, 'EdgeLabelColor','m');

figure(2)
weight = edge_weight_time;
H = graph(edge_start, edge_end, weight, node_names);
%H = simplify(H);
g = plot(H,'XData',x,'YData',y,'NodeFontWeight','bold', 'Marker','o', ...
    'MarkerSize',4,'LineWidth',0.5,'NodeLabel',node_names,...
    'EdgeLabel',H.Edges.Weight);

TerminalNodes = [2, 4, 7, 34, 39, 94, 113, 106, 95, 5, 100, 58, 66, 83, 103, 119, 121, 126, 43, 47, 72, 51, 8, 9, 17, 19, 21, 55, 114, 107, 143, 123, 29, 14, 44];

highlight(g, TerminalNodes, 'NodeColor', 'g');