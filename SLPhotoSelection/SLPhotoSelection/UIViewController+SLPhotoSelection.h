//
//  UIViewController+SLPhotoSelection.h
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 5/2/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <Photos/PHImageManager.h>
#import "SLPhotoView.h"
#import "SLPhotoManager.h"

typedef enum {
    SLSinglePhotoType,
    SLSingleVideoType,
    SLMultiplePhotoType,
    SLMultipleVideoType
} SLPhotoSelectionType;

typedef void (^SLSelectionBlock)(BOOL success, id object);

@interface UIViewController (SLPhotoSelection) <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (copy) SLSelectionBlock completionBlock;

/**
 This method allow getting a image from camera roll or take a photo in your device. 
 @param completionHandler
    The completionHandler return a UIImage if the process was successful.
 */
- (void)addPhotoWithCompletionHandler:(SLSelectionBlock)completionHandler;

/**
 This method allow getting a video from camera roll or make a video in your device.
 @param completionHandler
 The completionHandler return a AVAsset if the process was successful.
 */
- (void)addVideoWithCompletionHandler:(SLSelectionBlock)completionHandler;

/**
 This method allow getting multiple images from device.
 @param completionHandler
 The completionHandler return an array of PHAssets if the process was successful.
 */
- (void)selectMultiplePhotoWithCompletionHandler:(SLSelectionBlock)completionHandler;

/**
 This method allow getting multiple videos from device.
 @param completionHandler
 The completionHandler return an array of PHAssets if the process was successful.
 */
- (void)selectMultipleVideoWithCompletionHandler:(SLSelectionBlock)completionHandler;

@end
