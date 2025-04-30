function [p] = getNodePositionInARoute(route,node)

    p = find(route == node, 1);

end