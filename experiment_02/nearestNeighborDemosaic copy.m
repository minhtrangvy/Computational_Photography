function [R, G, B] = nearestNeighborDemosaic(oldR,oldG,oldB)
    currentR = oldR + circshift(oldR, [0,1]);
    R = currentR + circshift(currentR, [1,0]);
    currentB = oldB + circshift(oldB, [0,1]);
    B = currentB + circshift(currentB, [1,0]);
    G = oldG + circshift(oldG, [0,1]);
end