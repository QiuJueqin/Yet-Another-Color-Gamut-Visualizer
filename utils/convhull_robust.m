function [k, vol] = convhull_robust(pts)
% a robust version of CONVHULL that detectes points ON the convex surfaces
% as the vertices of the convex hull. (The built-in CONVHULL may neglect
% some points ON the line joining two convex vertices)
%
%
% Copyright
% Qiu Jueqin - May, 2019

TOL = 1E-7;
EPSILON_UPPER = .1;
EPSILON_LOWER = .01;

assert(size(pts, 2) == 3);

[~, vol] = convhull(pts);
centroid = centroidn(pts);

% push every points away from the centroid by a step inversely proportional
% to its distance from the centroid
distances = sum((pts - centroid).^2, 2);
M = max(distances);
m = min(distances);
steps = (EPSILON_LOWER - EPSILON_UPPER) * distances ./ (M - m) + (EPSILON_UPPER*M - EPSILON_LOWER * m) / (M - m); % normalized steps

[distance_sorted, idx] = sort(distances);
[~, idx_backwards] = sort(idx);
[distance_sorted, ~, iq] = uniquetol(distance_sorted, TOL);
max_steps = distance_sorted(2:end) ./ distance_sorted(1:end-1);
max_steps = [max_steps; 1];
max_steps = max_steps(iq);
max_steps = max_steps(idx_backwards, :);

steps = steps .* max_steps; % absolute steps

pts_pushed = (1 + steps) .* (pts - centroid) + centroid;
k = convhull(pts_pushed);
