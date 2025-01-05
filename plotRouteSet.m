% Inputs:
%  1. network_name - string
%  2. routes - cell array of route set
%  3. s - no. of routes in the network
%  4. n - no. of nodes
% -------------------------------------------------------------------------

function plotRouteSet(network_name,routes,s,n)


%% Network: Mandl

if (network_name == "mandl")

    TimeMatrix = [0 8 inf inf inf inf inf inf inf inf inf inf inf inf inf;
              8 0 2 3 6 inf inf inf inf inf inf inf inf inf inf;
              inf 2 0 inf inf 3 inf inf inf inf inf inf inf inf inf;
              inf 3 inf 0 4 4 inf inf inf inf inf 10 inf inf inf;
              inf 6 inf 4 0 inf inf inf inf inf inf inf inf inf inf;
              inf inf 3 4 inf 0 inf 2 inf inf inf inf inf inf 3;
              inf inf inf inf inf inf 0 inf inf 7 inf inf inf inf 2;
              inf inf inf inf inf 2 inf 0 inf 8 inf inf inf inf 2;
              inf inf inf inf inf inf inf inf 0 inf inf inf inf inf 8;
              inf inf inf inf inf inf 7 8 inf 0 5 inf 10 8 inf;
              inf inf inf inf inf inf inf inf inf 5 0 10 5 inf inf;
              inf inf inf 10 inf inf inf inf inf inf 10 0 inf inf inf;
              inf inf inf inf inf inf inf inf inf 10 5 inf 0 2 inf;
              inf inf inf inf inf inf inf inf inf 8 inf inf 2 0 inf;
              inf inf inf inf inf 3 2 2 8 inf inf inf inf inf 0];

    matrix = TimeMatrix;

    % Define a graph G
    edge_start = []; edge_end = []; edge_weight = [];
    for i=1:n
    for j=1:i
        if (matrix(i,j) ~= 0)
        if (matrix(i,j) ~= Inf)
            edge_start = [edge_start i];
            edge_end = [edge_end j];
            edge_weight = [edge_weight matrix(i,j)];
        end
        end
    end
    end 
    %disp("List of Edges"); disp(edge_start); disp(edge_end);
    x = [1,2,3.5,2,0.5,3.5,6.5,4.5,6.5,3,2,1,3,4,5.5];
    y = [5.5,4.5,4.5,3.5,4,3.5,2.5,2.5,5,1.5,1,2.5,0,1,4];

    G = graph(edge_start, edge_end, edge_weight);

    % Plot Route Network Graph
    h = plot(G,'EdgeLabel',G.Edges.Weight,'XData',x,'YData',y,...
            'NodeFontWeight','bold','Marker','square','MarkerSize',6,'EdgeLabelColor','m',...
            'NodeLabel',{'1'  '2'  '3'  '4'  '5'  '6' '7' '8' '9' '10' '11' '12' '13' '14' '15'});
    for a=1:s
        path = functionRoute(routes{a,1});
        highlight(h,path,'EdgeColor',hsv2rgb([a/s, 1, 1]),'LineWidth',2);
        hold on
    end
    hold off
end


%% Network: India

    if (network_name == "india")

    % d
    d = inf(28,28);
    d(1,22)=1; d(22,1)=1;
    d(2,3)=2; d(3,2)=2; d(2,16)=3; d(16,2)=3; d(2,22)=1; d(22,2)=1;
    d(3,25)=4; d(25,3)=4;
    d(4,23)=1; d(23,4)=1; d(4,24)=1; d(24,4)=1;
    d(5,6)=2; d(6,5)=2; d(5,14)=1; d(14,5)=1; d(5,25)=1; d(25,5)=1;
    d(6,7)=2; d(7,6)=2; d(6,27)=1; d(27,6)=1;
    d(7,28)=2; d(28,7)=2;
    d(8,26)=2; d(26,8)=2; d(8,28)=1; d(28,8)=1;
    d(9,10)=3; d(10,9)=3; d(9,27)=4; d(27,9)=4; d(9,28)=1; d(28,9)=1;
    d(10,11)=2; d(11,10)=2; d(10,12)=3; d(12,10)=3;
    d(12,13)=3; d(13,12)=3; d(12,27)=2; d(27,12)=2;
    d(13,14)=1; d(14,13)=1; d(13,21)=3; d(21,13)=3;
    d(14,27)=2; d(27,14)=2;
    d(15,22)=1; d(22,15)=1; d(15,23)=1; d(23,15)=1;
    d(16,26)=3; d(26,16)=3;
    d(17,23)=2; d(23,17)=2;
    d(18,22)=2; d(22,18)=2;
    d(19,26)=2; d(26,19)=2;
    d(20,26)=2; d(26,20)=2;
    d(21,24)=4; d(24,21)=4;
    d(24,25)=1; d(25,24)=1;
    DistanceMatrix = d;
    for i=1:28
        DistanceMatrix(i,i)=0;
    end

    matrix = DistanceMatrix;

    % Define a graph H
    edge_start = []; edge_end = []; edge_weight = [];
    for i=1:n
    for j=1:i
        if (matrix(i,j) ~= 0)
        if (matrix(i,j) ~= Inf)
            edge_start = [edge_start i];
            edge_end = [edge_end j];
            edge_weight = [edge_weight matrix(i,j)];
        end
        end
    end
    end 
    %disp("List of Edges"); disp(edge_start); disp(edge_end);
    x = [2,6,7,3,5.5,8,10,12,12,11,14,8,5,6,4.5,9,1,4.5,15,13,2,4.5,3.5,1.5,4,13,8,12];
    y = [8,7,6,4.5,3,3.5,4.5,5.5,3,0,0,0.5,1,2,6.5,7,6,8.5,7,8,1,7.5,5.5,3.5,3.5,7,2.5,4.5];

    H = graph(edge_start, edge_end, edge_weight);

    % Plot Route Network Graph
    h = plot(H,'EdgeLabel',H.Edges.Weight,'XData',x,'YData',y,...
        'NodeFontWeight','bold', 'Marker','o','MarkerSize',5,'EdgeLabelColor','m',...
        'NodeLabel',{'1'  '2'  '3'  '4'  '5'  '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16' ...
            '17' '18' '19' '20' '21' '22' '23' '24' '25' '26' '27' '28'});
    
    % Plot Route Network Graph
    for a=1:s
        path = functionRoute(routes{a,1});
        highlight(h,path,'EdgeColor',hsv2rgb([a/s, 1, 1]),'LineWidth',2);
        hold on
    end
    hold off

end




%% Network: Metro_Manila (Import datasets)

if (network_name == "metro_manila")
    
    size = 149;     % no. of nodes
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

    % terminal nodes (35 nodes)
    TerminalNodes = ([2, 4, 5, 7, 8, 9, 17, 21, 29, 34, 39, 43, 51, 55, 58, 66, 72, ...
    83, 94, 100, 103, 106, 113, 119, 121, 122, 126, 143, 95, 47, 19, 107, 123, 14]);

   
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

    % Display node names
    for a=1:s
        fprintf(' Corresponding Route %d: ', a); 
        R = nonzeros(routes{a,1})';
        for i=1:length(R)
            node_no = R(1,i);
            node_name = node_names{1,node_no};
            if (i < length(R))
                fprintf('%s - ',node_name);
            elseif (i == length(R))
                fprintf('%s \n',node_name);
            end
        end
    end

    % Plot Route Network Graph
    weight = edge_weight_time;
    P = graph(edge_start, edge_end, weight);
    
    g = plot(P,'XData',x,'YData',y,'NodeFontWeight','bold', 'Marker','o', ...
        'MarkerSize',4,'LineWidth',0.5);
    %'EdgeLabel',P.Edges.Weight

    TerminalNodes = [2, 4, 7, 34, 39, 94, 113, 106, 95, 5, 100, 58, 66, 83, 103, 119, 121, 126, 43, 47, 72, 51, 8, 9, 17, 19, 21, 55, 114, 107, 143, 123, 29, 14, 44];
    highlight(g, TerminalNodes, 'NodeColor', 'g');

    for a=1:s
        path = functionRoute(routes{a,1});
        highlight(g,path,'EdgeColor',hsv2rgb([a/s, 1, 1]),'LineWidth',2);
        hold on
    end
    title('A Pareto-optimal Route Set');
    hold off
end


end
