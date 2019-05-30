% demo 1: comparison of sRGB gamut and Adobe RGB gamut in CIELUV space
clear; close all; clc;

N = 8;
[r, g, b] = meshgrid(linspace(0, 1, N));
rgb = [r(:), g(:), b(:)];

[vol_srgb, ~, hax] = gamutview(rgb, [], 'srgb2luv', 'edgecolor', 'none');
vol_argb = gamutview(rgb, [], 'adobe_rgb2luv', 'facecolor', 'none', 'edgealpha', 0.8, 'parent', hax);

view(-20, 20);

fprintf('%s\nGamut volume in CIELUV color space\n', repmat('=', 1, 36));
fprintf('%-25s%.2e\n%-25s%.2e\n', 'sRGB:', vol_srgb, 'Adobe RGB:', vol_argb);
fprintf('%s\n', repmat('=', 1, 36));




% demo 2: comparison of OLED display gamut and sRGB gamut in CIELAB space
clear; close all; clc;

load('oled_display_measurements.mat');
[vol_oled, ~, hax] = gamutview(xyz, rgb, 'xyz2lab',...
                               'whitepoint', xyz_whitepoint,...
                               'edgecolor', 'k', 'edgealpha', .2);

N = 16;
[r, g, b] = meshgrid(linspace(0, 1, N));
rgb = [r(:), g(:), b(:)];

vol_srgb = gamutview(rgb, rgb, 'rgb2lab',...
                     'facecolor', 'none', 'linewidth', .5,...
                     'parent', hax);

fprintf('%s\nGamut volume in CIELAB color space\n', repmat('=', 1, 36));
fprintf('%-25s%.2e\n%-25s%.2e\n', 'OLED display:', vol_oled, 'sRGB:', vol_srgb);
fprintf('%s\n', repmat('=', 1, 36));

