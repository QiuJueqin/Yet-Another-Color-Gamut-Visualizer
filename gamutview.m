function [vol, hpatch, hax] = gamutview(colors, drive_values, type, varargin)
% GAMUTVIEW visualizes color gamut(s) for the input color values.
%
% See gamutview_demo.m for some usage guides.
% 
% SYNTAX:
%
% GAMUTVIEW(COLORS, DRIVE_VALUES, TYPE) will construct a 3D color gamut for
% the input color values in COLORS using "grid points" stored in
% DRIVE_VALUES. Both COLORS and DRIVE_VALUES must be M*3 matrices. TYPE
% specifies the input color space where COLORS is from and the target color
% space where the gamut is to be visualize, with
% '{input_space}2{output_space}' syntax, e.g., 'rgb2lab', 'xyz2luv', etc.
% If TYPE is empty, the default input color space will be 'sRGB' and output
% will be 'Lab'. The input and output color spaces can be any two of
% following ones (case-insensitive):
%
% 'srgb' (or 'rgb') | 'adobe_rgb' (or 'argb' or 'adobe_rgb_1998') | 'xyz' |
% 'lab' | 'luv' | 'lupvp' (or 'luvp') | 'ycbcr' (or 'ycc') | 'hsv' (or
% 'hsb') | 'hsi' (or 'hsl')
%
% When evaluating the color gamut for a display, the "grid points"
% generally are those drive values that generated monochromatic test
% patterns, e.g., [0, 0, 64], [0, 0, 128], [0, 0, 192], [0, 0, 255], ... ,
% and the COLORS are generally those XYZ values measured by a colorimeter
% or a spectrophotometer.
% 
% GAMUTVIEW(COLORS, [], TYPE) will detect the convex hull of COLORS and
% construct a 3D gamut using triangulation method, if the drive values are
% not given. Sometimes the shape of color gamut may appear odd in this
% mode.
%
% GAMUTVIEW(___, 'whitepoint', WP) uses the user-specified white point to
% transform color values between two color spaces. WP can be a 1-by-3 XYZ
% vector of the light source or a string of a standard illuminant, e.g.,
% 'd65', 'd50', 'a', etc. Use 'doc whitepoint' to see more usages.
%
% GAMUTVIEW(___, Name, Value) allows you to customize the appearance of the
% color gamut. All properties for PATCH object are supported, e.g.,
% 'facecolor', 'facealpha', 'edgecolor', etc.
%
% GAMUTVIEW(___, 'parent', AXES) will overlap the color gamut in the
% axes specified by the user. You can use this command to compare two
% gamuts intuitively (remember to set 'facecolor' to 'none' for the larger
% one).
%
% [VOL, HPATCH, HAX] = GAMUTVIEW(___) returns the gamut volume, handle of
% PATCH object, and the handle of axes.
%
%
% Copyright
% Qiu Jueqin - May, 2019

EPSILON = 1E-6;

if nargin <= 2
    type = [];
end
if nargin == 1
    drive_values = [];
end

[white_point, patch_properties, parent] = parse(varargin{:});

[inspace, outspace] = color_spaces_parse(type);

% transform input color values to the target color space in which the gamut
% is to be visualized
if ~strcmpi(inspace, outspace)
    colors = transform_color(colors, inspace, outspace, white_point);
end

nan_idx = any(isnan(colors), 2) | any(isinf(colors), 2);
colors = colors(~nan_idx, :);

[~, vol] = convhull(colors);

if isempty(drive_values) % mode 1: no drive values are given
    drive_values = transform_color(colors, outspace, inspace, white_point);
    
    % keep only convex vertices
    k = unique(convhull_robust(drive_values));
    drive_values = drive_values(k, :);
    gamut_vertices = colors(k, :);
    gamut_facets = convhull_robust(drive_values);
else % mode 2: with drive values provided
    drive_values = drive_values(~nan_idx, :);
    assert(isequal(size(drive_values), size(colors)));
    assert(size(drive_values, 2) == 3);
    
    % remove duplicates in the drive values
    [~, dup_idx] = unique(drive_values, 'row');
    drive_values = drive_values(dup_idx, :);
    colors = colors(dup_idx, :);
    
    ch = [1, 2, 3, 1, 2, 3];
    v = [min(drive_values, [], 1), max(drive_values, [], 1)];
    gamut_vertices = [];
    gamut_facets = [];
    
    % 6 surfaces for a gamut polyhedron
    for s = 1:6 
        vertices_indices = abs(drive_values(:, ch(s)) - v(s)) <= EPSILON;
        surface_vertices = colors(vertices_indices, :);
        rgb_vertices = drive_values(vertices_indices, :);
        rgb_vertices(:, ch(s)) = [];

        surface_facets = [];
        for i = 1:size(rgb_vertices, 1)
            current_vertex = rgb_vertices(i, :);
            if all(max(current_vertex) < max(rgb_vertices))
                tmp = rgb_vertices;
                tmp(any(tmp < current_vertex, 2), :) = inf;
                distances = sum((tmp - current_vertex).^2, 2);
                [~, adjacent_vertices] = mink(distances, 4);
                surface_facets = [surface_facets; adjacent_vertices([1, 2, 4, 3])'];
            end
        end

        % increase the indices by the number of vertices that had been added to
        % the polyhedron
        surface_facets = surface_facets + size(gamut_vertices, 1);
        gamut_facets = [gamut_facets; surface_facets];
        gamut_vertices = [gamut_vertices; surface_vertices];
    end
end

cdata = transform_color(gamut_vertices, outspace, 'srgb', white_point);
cdata = max(min(cdata, 1), 0);

% transform the final color representations to cartesian coordinates system
gamut_vertices = coordinate_transform(gamut_vertices, outspace);

if isempty(parent)
    hfig = figure('color', 'w');
    hax = axes(hfig);
else
    hax = parent;
end

hpatch = patch(hax,...
               'faces', gamut_facets, 'vertices', gamut_vertices,...
               'facevertexcdata', cdata,...
               patch_properties{:});
set_axes(hax, outspace);

end


function [input_color_space, output_color_space] = color_spaces_parse(type)
if isempty(type)
    input_color_space = 'xyz';
    output_color_space = 'lab';
    return;
end
color_spaces = strsplit(type, '2');
if numel(color_spaces) == 1
    input_color_space = color_spaces{1};
    output_color_space = 'lab';
elseif isempty(color_spaces{1})
    input_color_space = 'xyz';
    output_color_space = color_spaces{2};
elseif isempty(color_spaces{2})
    input_color_space = color_spaces{1};
    output_color_space = 'lab';
else
    input_color_space = color_spaces{1};
    output_color_space = color_spaces{2};
end
input_color_space = alias_(input_color_space);
output_color_space = alias_(output_color_space);
end


function colors = coordinate_transform(colors, color_space)
switch color_space
    case {'ycbcr', 'lab', 'luv'}
        colors = colors(:, [2, 3, 1]);
    case {'hsv', 'hsl'}
        [x_, y_, z_] = pol2cart(2*pi*colors(:, 1), colors(:, 2), colors(:, 3));
        colors = [x_, y_, z_];
end
end


function set_axes(hax, color_space)
switch lower(color_space)
    case {'srgb', 'adobe-rgb-1998'}
        axes_labels = {'$R$', '$G$', '$B$'};
    case 'xyz'
        axes_labels = {'$X$', '$Y$', '$Z$'};
    case 'lab'
        axes_labels = {'$a^\ast$', '$b^\ast$', '$L^\ast$'};
    case 'ycbcr'
        axes_labels = {'$Cb$', '$Cr$', '$Y$'};
    case 'luv'
        axes_labels = {'$u^\ast$', '$v^\ast$', '$L^\ast$'};
    case 'luvp'
        axes_labels = {'$u^\prime$', '$v^\prime$', '$L$'};
    case 'hsv'
        axes_labels = {'saturation', 'saturation', 'value'};
    case 'hsl'
        axes_labels = {'saturation', 'saturation', 'lightness'};
end
xlabel(hax, axes_labels{1}, 'interpreter', 'latex', 'fontsize', 16);
ylabel(hax, axes_labels{2}, 'interpreter', 'latex', 'fontsize', 16);
zlabel(hax, axes_labels{3}, 'interpreter', 'latex', 'fontsize', 16);
grid(hax, 'on');
set(hax, 'projection', 'perspective');
view(30, 30);
end


function [wp, patch_properties, parent] = parse(varargin)
% parse inputs & return structure of parameters
parser = inputParser;
parser.KeepUnmatched = true;
parser.addParameter('edgecolor', 'interp');
parser.addParameter('facecolor', 'interp');
parser.addParameter('linewidth', 1);
parser.addParameter('parent', []);
parser.addParameter('whitepoint', 'd65');
parser.parse(varargin{:});
p = setstructfields(parser.Results, parser.Unmatched);
wp = p.whitepoint;
parent = p.parent;
if ischar(wp)
    wp = whitepoint(wp);
end
patch_properties = rmfield(p, {'whitepoint', 'parent'});
patch_properties = [fieldnames(patch_properties), struct2cell(patch_properties)]';
patch_properties = patch_properties(:)';
end
