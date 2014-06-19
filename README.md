CSS Image Sprite of country flags
=================================


CSS Image sprite of country Flags with Pirates with different image sizes:

- [16x16](https://rawgit.com/flarik/css-sprite-flags/master/assets/16x16/index.html)
- [24x24](https://rawgit.com/flarik/css-sprite-flags/master/assets/24x24/index.html)
- [32x32](https://rawgit.com/flarik/css-sprite-flags/master/assets/32x32/index.html)
- [48x48](https://rawgit.com/flarik/css-sprite-flags/master/assets/48x48/index.html)
- [64x64](https://rawgit.com/flarik/css-sprite-flags/master/assets/64x64/index.html)


## Example usage

First copy the set you want to you to your local html project

Next edit the CSS filename and make sure the image url is correct for your
project:

```css
.flag.flag-24 {
  // ...
  background-image: url('sprite-flags-24x24.png'); 
  // ...
}
```

Next include the appropriate CSS file in the head of your HTML. E.g. if you want to use 24x24 and the filename is sprite-flags-24x24.css in your project 

```html
<link
  rel="stylesheet"
  type="text/css"
  href="sprite-flags-24x24.css"
/>
```


Next start rendering some flags!


```html
<i class="flag flag-16 flag-nl"></i>
<i class="flag flag-24 flag-nl"></i>
<i class="flag flag-32 flag-nl"></i>
<i class="flag flag-48 flag-nl"></i>
<i class="flag flag-64 flag-nl"></i>
```
