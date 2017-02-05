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

@property (copy) void (^completionBlock)(BOOL, UIImage *);

- (void)addPhotoWithCompletionHandler:(void(^)(BOOL success, UIImage *image))completionHandler;

@end
