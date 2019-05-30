function [XYZ] = luv2xyz_(luv,XYZw)

% LUV2XYZ computes the tristimulus values of a set of colours from their lightness, L*,
% and chromatic coordinates u* and v* in CIELUV.
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
% XYZ=luv2xyz(LUV,XYZR)
%
% LUV  = For N colours, Nx3 matrix, containing, in columns, the lightness L*,
%        and the chromaticity coordinates u* and v*.
%
% XYZR = Tristimulus values of the reference stimulus.
%        If the reference stimulus is the same for all the test stimuli, this
%        is a 1x3 matrix. If the reference is different for each tes stimulus
%        XYZR is a Nx3 matrix.
%
% XYZ = Tristimulus values of the test stimuli.
%       For N colours, this is a Nx3 matrix.
%
% RELATED FUNCTIONS
% ----------------------------------------------------------------------------
% xyz2luv, luv2perc, perc2luv
%
EPSILON = 1E-7;

s=size(luv,1);
ss=size(XYZw,1);
if ss==1
   XYZw=repmat(XYZw,s,1);
end
uvpYw=xyz2uvp_(XYZw);
uu=luv(:,2)./(13*luv(:,1)+EPSILON)+uvpYw(:,1);
vv=luv(:,3)./(13*luv(:,1)+EPSILON)+uvpYw(:,2);
cond=((luv(:,1)+16).^3)/116^3;
XYZ(:,2)=XYZw(:,2).*(cond.*(cond>0.008856)+(luv(:,1)/903.3).*(cond<=0.008856));
XYZ(:,1)=XYZ(:,2).*(9*uu./(4*vv));
XYZ(:,3)=(9*XYZ(:,2)-15*XYZ(:,2).*vv-XYZ(:,1).*vv)./(3*vv); 
