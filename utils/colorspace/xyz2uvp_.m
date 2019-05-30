function uvpY = xyz2uvp_(XYZ)

%Computes chromaticity coordinates u' v' and luminance
%from CIEXYZ tristimulus values
%
%USE: uvpY=xyz2uvp(XYZ)
%
%     XYZ: Nx3 matrix containing CIEXYZ tristimulus values
%     uvpY: Nx3 matrix containing [u' v' Y]
EPSILON = 1E-7;
dark_ind = all(XYZ < EPSILON, 2);
if nnz(dark_ind) > 0
    XYZ(dark_ind, :) = [0.2105, 0.4737, 0];
end
uvpY(:,1)=4*XYZ(:,1)./(XYZ(:,1)+15*XYZ(:,2)+3*XYZ(:,3)+EPSILON);
uvpY(:,2)=9*XYZ(:,2)./(XYZ(:,1)+15*XYZ(:,2)+3*XYZ(:,3)+EPSILON);
uvpY(:,3)=XYZ(:,2);