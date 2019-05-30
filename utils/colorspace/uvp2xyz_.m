function XYZ = uvp2xyz_(uvpY)

%Computes CIEXYZ tristimulus values from
%chromaticity coordinates u' v' and luminance
%
%USE: XYZ=uvp2xyz(uvpY)
%
%     uvpY: Nx3 matrix containing [u' v' Y]
%     XYZ: Nx3 matrix containing CIEXYZ tristimulus values


xy=uvp2xy_(uvpY(:,1:2));
XYZ=coor2tri_([xy uvpY(:,3)],[0 1 0]);


