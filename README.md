# SLPhotoSelection

## General

This project easily implements the selection of a photo using the camera or saved in the cell phone.

## Installation

* Manual

You need to add this files to your project:
  - The folder SLImagePickerController with all files.
  - UIViewController+SLPhotoSelection.h
  - UIViewController+SLPhotoSelection.m
  
  
 After iOS 10 you have to define and provide a usage description of all the system’s privacy-sensitive data accessed by your app in Info.plist.
 
 You need to add the next key value pair:

```
<key>NSCameraUsageDescription</key>
<string>This app needs access to the camera to take photos.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to photos.</string>

```

## Usage

Import the file to your class.
```
#import "UIViewController+SLPhotoSelection.h"
```
 
You have four methods to gettings images and videos.
 
The next methods allow selects a single image:
```
    [self addPhotoWithCompletionHandler:^(BOOL success, id object) {
      if (success) {
        //This method return a UIImage in object attribute.
      } else {
        //When fail or cancel 
      }
    }];
```
The next methods allow selects a single video:
```
    [self addVideoWithCompletionHandler:^(BOOL success, id object) {
      if (success) {
        //This method return a AVAsset in object attribute.
      } else {
        //When fail or cancel 
      }
    }];
```

The next methods allow selects multiples images:
```
    [self selectMultiplePhotoWithCompletionHandler:^(BOOL success, NSMutableArray *multiplePhotos) {
      if (success) {
        //This method return a NSMutableArray of PHAssets.
      } else {
        //When fail or cancel 
      }
    }];
```

The next methods allow selects multiples videos:
```
    [self selectMultipleVideoWithCompletionHandler:^(BOOL success, NSMutableArray *multipleVideo) {
      if (success) {
        //This method return a NSMutableArray of PHAssets.
      } else {
        //When fail or cancel 
      }
    }];
```

Also I added a SLPhotoManage file. This class have two methods to getting a UIImage from a PHAssets and getting a AVPlayerItem from a PHAssets (for videos.)
```
  [SLPhotoManager loadImage:asset completion:^(UIImage *image, NSDictionary *info) {
  
  }];
```

```
  [SLPhotoManager loadVideo:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {

  }];
```

## Author

[![Agustín De León](https://avatars2.githubusercontent.com/u/18148345?v=3&s=460)](https://github.com/agustinslions)

[Agustín De León](https://github.com/agustinslions)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
