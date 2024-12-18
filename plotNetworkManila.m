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
    'MarkerSize',4,'LineWidth',0.5,...
    'EdgeLabel',H.Edges.Weight);

% 'NodeLabel',node_names,

TerminalNodes = ([2, 4, 5, 7, 8, 9, 17, 21, 29, 34, 39, 43, 51, 55, 58, 66, 72, ...
    83, 94, 100, 103, 106, 113, 119, 121, 122, 126, 143, 95, 47, 19, 107, 123, 14]);

highlight(g, TerminalNodes, 'NodeColor', 'g');