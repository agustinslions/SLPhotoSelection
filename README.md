# SLPhotoSelection

## General

This project easily implements the selection of a photo using the camera or saved in the cell phone.

## Installation

* Manual

You need to add to your project the file
  - UIViewController+SLPhotoSelection.h
  - UIViewController+SLPhotoSelection.m

## Usage

Import the file to your class.
```
#import "UIViewController+SLPhotoSelection.h"
```

Then add the next line in order to show the component.

```
    [self addPhotoWithCompletionHandler:^(BOOL success, UIImage *image) {
      if (success) {
        //When select your photo
      } else {
        //When fail or cancel 
      }
    }];
```
## Author

[![Agustín De León](https://avatars2.githubusercontent.com/u/18148345?v=3&s=460)](https://github.com/agustinslions) |
---|---|---
[Agustín De León](https://github.com/agustinslions) |

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
