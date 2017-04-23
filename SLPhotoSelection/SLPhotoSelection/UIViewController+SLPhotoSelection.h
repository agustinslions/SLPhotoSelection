//
//  UIViewController+SLPhotoSelection.h
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 5/2/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController (SLPhotoSelection) <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (copy) void (^completionBlock)(BOOL, id);

@property (copy) void (^multipleCompletionBlock)(BOOL, NSMutableArray *);

- (void)addPhotoWithCompletionHandler:(void(^)(BOOL success, id))completionHandler;

- (void)addVideoWithCompletionHandler:(void(^)(BOOL success, id))completionHandler;

- (void)selectMultiplePhotoWithCompletionHandler:(void(^)(BOOL success, NSMutableArray *multiplePhotos))completionHandler;

- (void)selectMultipleVideoWithCompletionHandler:(void(^)(BOOL success, NSMutableArray *multipleVideo))completionHandler;

@end
