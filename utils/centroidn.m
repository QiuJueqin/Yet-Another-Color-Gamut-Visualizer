% This function returns the x,y,z coordinates of centroid
% of surface triangulated polyhedron. 
%
% INPUT:
%     vertex: Point Cloud of Shape
%         vertex(:,1) : x coordinates
%         vertex(:,2) : y coordinates
%         vertex(:,3) : z coordinates
%     faces: Information of which vertex belongs to which triangle
% OUTPUT:
%     centroid: x,y,z cordinate of centroid
%          centroid(1,1): x coordinate
%          centroid(1,2): y coordinate
%          centroid(1,3): z coordinate
% 
% AUTHOR:
%   Isfandiyar RASHIDZADE
%   Email : irashidzade@gmail.com
%   Web Site: isfzade.info
%   Year: 2016


function centroid = centroidn(vertex, faces)
    
    %finding the area of closed polyhedron
        vector1 = vertex(faces(:, 2), :) - vertex(faces(:, 1), :);
        vector2 = vertex(faces(:, 3), :) - vertex(faces(:, 1), :);
        
        triangAreasTmp =0.5*cross(vector1,vector2);
        triangAreas(:,1) = (triangAreasTmp(:,1).^2+triangAreasTmp(:,2).^2 ...
                    +triangAreasTmp(:,3).^2).^(1/2); %area of each triangle
        
        totArea = sum(triangAreas); %total area
    
    point1 = vertex(faces(:, 1), :);
    point2 = vertex(faces(:, 2), :);
    point3 = vertex(faces(:, 3), :);
    
    centroidTriangles = (1/3) .* (point1 + point2 + point3); %cent. of each triangle
    
    mg(:,1) = triangAreas(:,1) .*  centroidTriangles(:,1);
    mg(:,2) = triangAreas(:,1) .*  centroidTriangles(:,2);
    mg(:,3) = triangAreas(:,1) .*  centroidTriangles(:,3);
    mg2 = [mg(:,1) mg(:,2) mg(:,3)];
    
    centroid = sum(mg2)./totArea;
    
    
end