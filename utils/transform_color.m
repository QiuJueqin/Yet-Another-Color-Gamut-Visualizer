function colors = transform_color(colors, input_color_space, output_color_space, wp)
% TRANSFORM_COLOR transforms H*W*3 or N*3 color values between any two of
% following color spaces: (case-insensitive)
%
%     'RGB' or 'sRGB':       sRGB IEC 61966-2-1
%     'Adobe_RGB' or 'aRGB': Adobe RGB (1998)
%     'XYZ':                 CIE 1931 XYZ
%     'Lab':                 CIE 1976 L*a*b* (CIELAB)
%     'Luv':                 CIE L*u*v* (CIELUV)
%     'Luvp' or 'Lupvp':     CIE Yu'v'
%     'YCbCr' or 'YCC':      Luma + Chroma ("digitized" version of Y'PbPr)
%     'YUV':                 NTSC PAL Y'UV Luma + Chroma
%     'HSV' or 'HSB':        Hue Saturation Value/Brightness
%     'HSL' or 'HSI':        Hue Saturation Luminance
%
% For sRGB, the values should be scaled between 0 and 1.
%
%
% Copyright
% Qiu Jueqin - May, 2019

nb_dims = ndims(colors);
if nb_dims == 3
    [height, width, ~] = size(colors);
    colors = reshape(colors, [], 3);
end

input_color_space = alias_(input_color_space);
output_color_space = alias_(output_color_space);

if nargin <= 3 || isempty(wp)
    wp = 'd65';
end
if ischar(wp)
    wp = whitepoint(wp);
else
    assert(numel(wp) == 3);
end

% phase 1: transform input values into XYZ color space
if strcmpi(input_color_space, 'xyz')
    xyz = colors;
else
    xyz = input2xyz(colors, input_color_space, wp);
end

% phase 2: transform XYZ values into output color space
if strcmpi(output_color_space, 'xyz')
    colors = xyz;
else
    colors = xyz2output(xyz, output_color_space, wp);
end

if nb_dims == 3
    colors = reshape(colors, height, width, 3);
end

end


function xyz = input2xyz(input, input_color_space, wp)
switch input_color_space
    case 'srgb'
        xyz = rgb2xyz(input, 'whitepoint', wp);
	case 'adobe-rgb-1998'
        xyz = rgb2xyz(input, 'colorspace', 'adobe-rgb-1998', 'whitepoint', wp);
    case 'lab'
        xyz = lab2xyz(input, 'whitepoint', wp);
    case 'ycbcr'
        srgb = ycbcr2rgb(input);
        xyz = rgb2xyz(srgb, 'whitepoint', wp);
    case 'hsv'
        srgb = hsv2rgb(input);
        xyz = rgb2xyz(srgb, 'whitepoint', wp);
    case 'hsl'
        srgb = hsl2rgb_(input);
        xyz = rgb2xyz(srgb, 'whitepoint', wp);
    case 'luv'
        xyz = luv2xyz_(input, wp);
	case 'luvp'
        xyz = uvp2xyz_(input);
end
end


function output = xyz2output(xyz, output_color_space, wp)
switch output_color_space
    case 'srgb'
        output = xyz2rgb(xyz, 'whitepoint', wp);
        output = max(min(output, 1), 0);
	case 'adobe-rgb-1998'
        output = xyz2rgb(xyz, 'colorspace', 'adobe-rgb-1998', 'whitepoint', wp);
        output = max(min(output, 1), 0);
    case 'lab'
        output = xyz2lab(xyz, 'whitepoint', wp);
    case 'ycbcr'
        srgb = xyz2rgb(xyz, 'whitepoint', wp);
        srgb = max(min(srgb, 1), 0);
        output = rgb2ycbcr(srgb);
	case 'hsv'
        srgb = xyz2rgb(xyz, 'whitepoint', wp);
        srgb = max(min(srgb, 1), 0);
        output = rgb2hsv(srgb);
	case 'hsl'
        srgb = xyz2rgb(xyz, 'whitepoint', wp);
        srgb = max(min(srgb, 1), 0);
        output = rgb2hsl_(srgb);
    case 'luv'
        output = xyz2luv_(xyz, wp);
	case 'luvp'
        output = xyz2uvp_(xyz);
end
end
