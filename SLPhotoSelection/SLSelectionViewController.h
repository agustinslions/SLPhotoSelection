//
//  SLSelectionViewController.h
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 23/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SLSinglePhotoType,
    SLSingleVideoType,
    SLMultiplePhotoType,
    SLMultipleVideoType
} SLPhotoSelectionType;

@interface SLSelectionViewController : UIViewController

@property (nonatomic, assign) SLPhotoSelectionType photoSelectionType;

@end
