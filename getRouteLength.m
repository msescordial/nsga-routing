function route_length = getRouteLength(route, DistanceMatrix)
   
    route_length = 0;
    for i=1:length(route)-1
        route_length = route_length + DistanceMatrix(route(1,i),route(1,i+1));
    end 

end