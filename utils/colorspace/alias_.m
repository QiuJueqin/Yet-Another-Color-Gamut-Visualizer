function color_space = alias_(color_space)
assert(ischar(color_space));
switch lower(color_space)
    case {'rgb', 'srgb'}
        color_space = 'srgb';
	case {'argb', 'adobe_rgb', 'adobe-rgb', 'adobe-rgb-1998'}
        color_space = 'adobe-rgb-1998';
    case {'ycc', 'ycbcr'}
        color_space = 'ycbcr';
    case {'hsv', 'hsb'}
        color_space = 'hsv';
    case {'hsl', 'hsi', 'hls'}
        color_space = 'hsl';
	case {'luv', 'uvl'}
        color_space = 'luv';
    case {'lupvp', 'luvp', 'upvpl', 'uvpl'}
        color_space = 'luvp';
end
end