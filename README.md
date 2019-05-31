# Descriptions

This tool helps to visualizes color volume by constructing a 3D gamut(s) given point cloud of color values. Please see [gamutview.m](gamutview.m) for more detailed descriptions.


# Examples

## Visualization of sRGB gamut in CIELAB color space

```
[r, g, b] = meshgrid(linspace(0, 1, 8));
rgb = [r(:), g(:), b(:)];
gamutview(rgb, rgb, 'srgb', 'facecolor', 'none');
```

<br>

<img src="screenshots/example1.gif" width="520">

<br>

> The animation was created by [animated-gif creator](https://www.mathworks.com/matlabcentral/fileexchange/28766-animated-gif-creator).


## Comparison of visible gamut and sRGB gamut in CIE1931 XYZ color space

```
[r, g, b] = meshgrid(linspace(0, 1, 8));
rgb = [r(:), g(:), b(:)];
[~, ~, hax] = gamutview(rgb, [], 'srgb2xyz', 'edgecolor', 'none');

load('visible_spectra.mat');
xyz = spectra2colors(visible_spectra, wavelengths, 'spd', 'd65');

vol_visible = gamutview(xyz, [], 'xyz2xyz', 'facecolor', 'none', 'parent', hax);
```

<br>

<img src="screenshots/example2.gif" width="520">

<br>


## Gamuts comparison for sRGB (solid) and Adobe RGB (black grid) in CIELUV color space

```
[r, g, b] = meshgrid(linspace(0, 1, 16));
rgb = [r(:), g(:), b(:)];
[~, ~, hax] = gamutview(rgb, rgb, 'srgb2luv', 'edgecolor', 'none');
gamutview(rgb, rgb, 'argb2luv', 'facecolor', 'none', 'edgecolor', 'k', 'edgealpha', .25, 'parent', hax);
```

<br>

<img src="screenshots/example3.gif" width="520">

<br>

Please see [demo/gamutview_demo.m](demo/gamutview_demo.m) for more usage guides.


# License

Copyright 2019 Qiu Jueqin

Licensed under [MIT](http://opensource.org/licenses/MIT).