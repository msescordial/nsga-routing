function forSensitivityAnalysis(s1, n, metro_line, FM, network_name, iter)
    route_string = [FM metro_line];
    Sr=stringToRoutes(route_string,s1,n);
    for a=1:s1
        fprintf(' Route %d:', a); 
        br = functionRoute(Sr{a,1});
        displayRoute(br);
    end
    plotRouteSet(network_name,Sr,s1,n);
    title(['Generation ' num2str(iter)]); 
    pause(0.5);
end