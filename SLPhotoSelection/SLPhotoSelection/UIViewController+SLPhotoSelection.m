//
//  UIViewController+SLPhotoSelection.m
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 5/2/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import "UIViewController+SLPhotoSelection.h"
#import <objc/runtime.h>
#import "SLAlbumViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@implementation UIViewController (SLPhotoSelection)

static char UIB_PROPERTY_KEY;

#pragma mark - Getter and setter methods

- (void)setCompletionBlock:(SLSelectionBlock)completionBlock
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SLSelectionBlock)completionBlock
{
    return (SLSelectionBlock)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

#pragma mark - Public methods

- (void)addPhotoWithCompletionHandler:(SLSelectionBlock)completionHandler
{
    self.completionBlock = completionHandler;
    
    [self showActionSheetWithOptionType:SLSinglePhotoType];
}

- (void)addVideoWithCompletionHandler:(SLSelectionBlock)completionHandler
{
    self.completionBlock = completionHandler;

    [self showActionSheetWithOptionType:SLSingleVideoType];
}

- (void)selectMultiplePhotoWithCompletionHandler:(SLSelectionBlock)completionHandler
{
    self.completionBlock = completionHandler;
    
    [self showActionSheetWithOptionType:SLMultiplePhotoType];
}

- (void)selectMultipleVideoWithCompletionHandler:(SLSelectionBlock)completionHandler
{
    self.completionBlock = completionHandler;
    
    [self showActionSheetWithOptionType:SLMultipleVideoType];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.completionBlock(NO, nil);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage *selectedImage = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
        self.completionBlock(YES, selectedImage);
    
    } else if ([mediaType isEqualToString:@"public.movie"]){
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        AVAsset *avAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        
        self.completionBlock(YES, avAsset);
    }
}

#pragma mark - Private methods

- (void)pushToSLAlbumViewControllerWithSelectionType:(SLSelectionType)selectionType
{
    SLAlbumViewController *albumViewController = [[UIStoryboard storyboardWithName:@"SLImagePicker" bundle:nil] instantiateViewControllerWithIdentifier:@"AlbumStoryboardID"];
    
    albumViewController.selectionType = selectionType;
    
    [albumViewController setMultipleCompletionBlock:self.completionBlock];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)showActionSheetWithOptionType:(SLPhotoSelectionType)photoSelectionType
{
    NSString *makeString = NSLocalizedString(@"Take Photo", @"");
    
    if (![self isPhotoSelection:photoSelectionType]) makeString = NSLocalizedString(@"Make a video", @"");

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        self.completionBlock(NO, nil);
    }];
    
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:makeString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
            cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            cameraPicker.delegate = self;

            if (![self isPhotoSelection:photoSelectionType]) cameraPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            
            [self presentViewController:cameraPicker animated:YES completion:nil];
        }
    }];

    UIAlertAction *actionCameraRoll = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera Roll", @"")
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
        
        if ([self isMultipleSelection:photoSelectionType]) {
            [self pushToSLAlbumViewControllerWithSelectionType:photoSelectionType == SLMultiplePhotoType ? SLPhotoType : SLVideoType];
            return;
        }
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            if (![self isPhotoSelection:photoSelectionType]) imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    
    [actionSheet addAction:actionCancel];
    [actionSheet addAction:actionCamera];
    [actionSheet addAction:actionCameraRoll];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (BOOL)isPhotoSelection:(SLPhotoSelectionType)photoSelectionType
{
    return photoSelectionType == SLMultiplePhotoType || photoSelectionType == SLSinglePhotoType;
}

- (BOOL)isMultipleSelection:(SLPhotoSelectionType)photoSelectionType
{
    return photoSelectionType == SLMultiplePhotoType || photoSelectionType == SLMultipleVideoType;
}

@end
