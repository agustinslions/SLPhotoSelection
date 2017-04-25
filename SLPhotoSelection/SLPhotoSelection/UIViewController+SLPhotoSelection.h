//
//  UIViewController+SLPhotoSelection.h
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 5/2/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    SLSinglePhotoType,
    SLSingleVideoType,
    SLMultiplePhotoType,
    SLMultipleVideoType
} SLPhotoSelectionType;

typedef void (^SLSelectionBlock)(BOOL success, id object);

@interface UIViewController (SLPhotoSelection) <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (copy) SLSelectionBlock completionBlock;

- (void)addPhotoWithCompletionHandler:(SLSelectionBlock)completionHandler;

- (void)addVideoWithCompletionHandler:(SLSelectionBlock)completionHandler;

- (void)selectMultiplePhotoWithCompletionHandler:(SLSelectionBlock)completionHandler;

- (void)selectMultipleVideoWithCompletionHandler:(SLSelectionBlock)completionHandler;

@end
