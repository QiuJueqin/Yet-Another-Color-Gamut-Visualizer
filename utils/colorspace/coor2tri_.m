function T = coor2tri_(t,Yw)

% COOR2TRI compute tristimulus vectors from chromatic coordinates and luminance
% (at a given basis).
%
% SYNTAX
% -----------------------------------------------------------------------------
%
% T=coor2tri(t,Yw);
%
% T  = Output tristimulus vectors (color-like variable, colors in rows).
% 
% Yw = Trichromatic units [Yw(P1) Yw(P2) Yw(P3)]
%
% t  = Input chromatic coordinates and luminance  (color-like variable, [t1 t2 Y]).
%


l=size(t);
l=l(1);

t3=1-t(:,1)-t(:,2);
Y=t(:,3);
t=[t(:,1:2) t3];
coc=sum((Yw(ones(size(t,1),1),:).*t)')';
T=t.*[Y Y Y]./[coc coc coc];

ceros=find(isnan(T));
T(ceros)=0;
%for i=1:l
%    tt=t(i,:);
%    YY=Y(i);
%    TT=tt*YY/(tt*yw');
%    T(i,:)=TT;
%end