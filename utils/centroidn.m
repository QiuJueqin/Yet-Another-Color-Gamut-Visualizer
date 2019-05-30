function centroid = centroidn(vertices)
% modified from geom3d toolbox
% https://www.mathworks.com/matlabcentral/fileexchange/24484-geom3d
%
% CENTROIDN Compute the centroid of a 3D convex polyhedron
%
%   CENTRO = CENTROIDN(V)
%   Computes the centroid (center of mass) of the polyhedron defined by
%   vertices V.
%   The polyhedron is assumed to be convex.

% compute set of elementary tetrahedra
DT = delaunayTriangulation(vertices);
T = DT.ConnectivityList;

% number of tetrahedra
nT  = size(T, 1);

% initialize result
centroid = zeros(1, 3);
vt = 0;

% Compute the centroid and the volume of each tetrahedron
for i = 1:nT
    % coordinates of tetrahedron vertices
    tetra = vertices(T(i, :), :);
    
    % centroid is the average of vertices. 
    centi = mean(tetra);
    
    % compute volume of tetrahedron
    vol = det(tetra(1:3,:) - tetra([4 4 4],:)) / 6;
    
    % add weighted centroid of current tetraedron
    centroid = centroid + centi * vol;
    
    % compute the sum of tetraedra volumes
    vt = vt + vol;
end

% compute by sum of tetrahedron volumes
centroid = centroid / vt;
