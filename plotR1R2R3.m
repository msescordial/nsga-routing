clear
clc

[DistanceMatrix,TimeMatrix,TravelDemandMatrix,TerminalNodes,k_kSP,s,transfer_time, metro_line]=network_metro_manila();

% Network: Metro_Manila (Import datasets)
    
    size = 149;     % no. of nodes
    % T
    load("final_time.mat","-mat");
    TimeMatrix = array;
    %disp(array);
    for i=1:size
    for j=1:size
        if abs(i-j)>0
        if (TimeMatrix(i,j) == 0)
            TimeMatrix(i,j) = inf;
        end
        end
    end
    end
    
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

    matrix = TimeMatrix;
   
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

    % Define a graph P

    % EDGES
    edge_start = []; 
    edge_end = [];      
    edge_weight_distance = [];
    edge_weight_time = [];

    for i=1:height(my_csv2)          % per row of data_edges
        % starting node
        v = my_csv2{i,"s_Node_Number"};
        edge_start = [edge_start v];
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

    % Plot Route Network Graph
    figure(1);
    
    weight = edge_weight_time;
    P = graph(edge_start, edge_end, weight);    
    g = plot(P,'XData',x,'YData',y,'NodeFontWeight','bold', 'Marker','o', ...
        'MarkerSize',2,'LineWidth',0.5);
    %'EdgeLabel',P.Edges.Weight
    highlight(g, TerminalNodes, 'NodeColor', 'g');

    %% R1
    route1 = [34,33,40,41,42,43,44,45,46,22,21,20,1,5,15,14];

    highlight(g,route1,'EdgeColor','red','LineWidth',3);
    highlight(g,[21,34],'MarkerSize',5);
    labelnode(g,[21 34],{'Gil Puyat Ave' 'Monumento'});
    filename = 'F1_compareR1.png';
    saveas(gcf,filename);


    %% R2
    figure(2);
    weight = edge_weight_time;
    P = graph(edge_start, edge_end, weight);
    
    g = plot(P,'XData',x,'YData',y,'NodeFontWeight','bold', 'Marker','o', ...
        'MarkerSize',2,'LineWidth',0.5);
    %'EdgeLabel',P.Edges.Weight
    highlight(g, TerminalNodes, 'NodeColor', 'g');

    route1 = [5,48,47,21,22,46,45,44,122,67,88,89,90,91,135,92,93,140,94];
    route2 = [4,3,136,2,1,5,19,51,142,145,64,76,146,126,95,94,113,114,147,130,34];

    highlight(g,route1,'EdgeColor',hsv2rgb([4/5, 1, 1]),'LineWidth',3);
    hold on
    highlight(g,route2,'EdgeColor',hsv2rgb([2/5, 1, 1]),'LineWidth',3);
    hold on
    highlight(g,[21,34],'MarkerSize',5);
    labelnode(g,[21 34],{'Gil Puyat Ave' 'Monumento'});
    filename = 'F1_compareR2.png';
    saveas(gcf,filename);
    hold off

    %% R3
    figure(3);
    weight = edge_weight_time;
    P = graph(edge_start, edge_end, weight);
    
    g = plot(P,'XData',x,'YData',y,'NodeFontWeight','bold', 'Marker','o', ...
        'MarkerSize',2,'LineWidth',0.5);
    %'EdgeLabel',P.Edges.Weight
    highlight(g, TerminalNodes, 'NodeColor', 'g');

    route1 = [94,140,93,92,135,91,90,89,88,67,122,44,45,46,22,21,20,1,2];
    route2 = [34,33,40,41,42,43,44,45,46,47];

    highlight(g,route1,'EdgeColor',hsv2rgb([3/7, 1, 1]),'LineWidth',3);
    hold on
    highlight(g,route2,'EdgeColor',hsv2rgb([5/7, 1, 1]),'LineWidth',3);
    hold on
    highlight(g,[21,34],'MarkerSize',5);
    labelnode(g,[21 34],{'Gil Puyat Ave' 'Monumento'});
    filename = 'F1_compareR3.png';
    saveas(gcf,filename);
    hold off


