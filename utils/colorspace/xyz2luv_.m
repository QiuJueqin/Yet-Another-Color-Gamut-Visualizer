function luv = xyz2luv_(XYZ,XYZw)

% XYZ2LUV computes the lightness, L*, and the chromatic coordinates u* and v* in CIELUV
% of a set of colours defined by their tristimulus CIE-1931 values.
%
% CIELUV is a simple appearance model providing perceptual descriptors (lightness, hue
% and chroma) for related colours (colours in a scene).
%
% In this representation, information about the illumination conditions or, alternatively,
% about the scene, is included in a reference stimulus. Using CIELUV in the standard
% conditions implies that the reference stilulus is a perfect difuser illuminated as the
% test.
% 
% SYNTAX
% ----------------------------------------------------------------------------
% LUV=xyz2luv(XYZ,XYZR)
%
% XYZ = Tristimulus values of the test stimuli.
%       For N colours, this is a Nx3 matrix.
%
% XYZR = Tristimulus values of the reference stimulus.
%        If the reference stimulus is the same for all the test stimuli, this
%        is a 1x3 matrix. If the reference is different for each tes stimulus
%        XYZR is a Nx3 matrix.
%
% LUV  = For N colours, Nx3 matrix, containing, in columns, the lightness L*,
%        and the chromaticity coordinates u* and v*.
%
% RELATED FUNCTIONS
% ----------------------------------------------------------------------------
% luv2xyz, luv2perc, perc2luv
%

s=size(XYZ,1);
ss=size(XYZw,1);
if ss==1
   XYZw=repmat(XYZw,s,1);
end

uvpY=xyz2uvp_(XYZ);
uvpYw=xyz2uvp_(XYZw);
cond=double(XYZ(:,2)>0.008856*XYZw(:,2));
luv(:,1)=(116*((XYZ(:,2)./XYZw(:,2)).^(1/3))-16).*cond+903.3*(XYZ(:,2)./XYZw(:,2)).*not(cond);
luv(:,2)=13*luv(:,1).*(uvpY(:,1)-uvpYw(:,1));
luv(:,3)=13*luv(:,1).*(uvpY(:,2)-uvpYw(:,2));
