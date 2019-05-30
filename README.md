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

<img src="screenshots/example1.gif" width="580">

<br>

> The animation was created by [animated-gif creator](https://www.mathworks.com/matlabcentral/fileexchange/28766-animated-gif-creator).


## Gamuts comparison for sRGB (solid) and Adobe RGB (black grid) in CIELUV color space

```
[r, g, b] = meshgrid(linspace(0, 1, 8));
rgb = [r(:), g(:), b(:)];
[~, ~, hax] = gamutview(rgb, rgb, 'srgb2luv', 'edgecolor', 'none');
gamutview(rgb, rgb, 'argb2luv', 'facecolor', 'none', 'edgecolor', 'k', 'edgealpha', .25, 'parent', hax);
```

<br>

<img src="screenshots/example2.gif" width="580">

<br>

Please see [gamutview_demo.m](gamutview_demo.m) for more usage guides.


# License

Copyright 2019 Qiu Jueqin

Licensed under [MIT](http://opensource.org/licenses/MIT).