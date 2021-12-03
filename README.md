# ABOUT

**WallHe+** is a simple MacOS Swift application to automatically tile and display your wallpapers or any supported image file.
Specify image folder and delay, Wallhe will randomly pick an image, resize/tile it to fit all visible desktops then loop through all images. 
Inspired by Wally by Antonio Di Monaco

# INSTALLATION

## See latest release

**WallHe+**
Uses depends SwiftImage to open PNG files. 

## Building and installation

    # Swift 5
    # Xcode 13.0
    # MacOS 10.15  (MacOS Catalina and higher)  

# FEATURES

Runs as a menu bar application.
Makes it easy to pick a folder(s), pause/start rotation or change delay settings.

Background image loading
Can select directories with any number of images (limited by available memory). Display starts with small sample while loading of directory completes.

Random order
Currently only provides random ordering of images.

Updates all windows.
Multi-monitor set-ups: updates wallpaper on all visible desktops.

Automatically resizes and tiles images.
No need to manually resize images to your screen size before using them as wallpaper.

Works with all image files supported by MacOS.
Can have any number of mixed image files in your selected directories.

Log.
Allows you to see which image was shown and when.


# License

WallHe+ is available under the MIT license. See the LICENSE file for more info.

# TO DO

Remove dependency on SwiftImage.
Use label to skip folder from being selected.
Use of arbitrary filters to prevent items from being selected.
Select images from URL.
