clear
clc


%% Network: Mandl

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
[m n] = size(matrix);

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
figure(1)
plot(G,'EdgeLabel',G.Edges.Weight,'XData',x,'YData',y,...
    'NodeFontWeight','bold', 'Marker','square','MarkerSize',6,...
    'LineWidth',2, 'EdgeLabelColor','m');


%% Network: India

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
[m n] = size(matrix);

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
figure(2);
plot(H,'EdgeLabel',H.Edges.Weight,'XData',x,'YData',y,...
    'NodeFontWeight','bold', 'Marker','o','MarkerSize',5,...
    'LineWidth',2, 'EdgeLabelColor','m');