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

- (void)setCompletionBlock:(void (^)(BOOL, id))completionBlock
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(BOOL, id))completionBlock
{
    return (void (^)(BOOL, id))objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

- (void)setMultipleCompletionBlock:(void (^)(BOOL, NSMutableArray *))completionBlock
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(BOOL, NSMutableArray *))multipleCompletionBlock
{
    return (void (^)(BOOL, NSMutableArray *))objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

#pragma mark - Publick methods

- (void)addPhotoWithCompletionHandler:(void (^)(BOOL, id))completionHandler
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        self.completionBlock(NO, nil);
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Camera Roll", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
            picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker1.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
            picker1.delegate = self;
            [self presentViewController:picker1 animated:YES completion:nil];
        }
    }]];
    
    self.completionBlock = completionHandler;
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)addVideoWithCompletionHandler:(void(^)(BOOL success, id))completionHandler
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        self.completionBlock(NO, nil);
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Make a video", @"")
                                                    style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Camera Roll", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
            picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker1.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
            picker1.delegate = self;
            [self presentViewController:picker1 animated:YES completion:nil];
        }
    }]];
    
    self.completionBlock = completionHandler;
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)selectMultiplePhotoWithCompletionHandler:(void(^)(BOOL success, NSMutableArray *multiplePhotos))completionHandler
{
    self.multipleCompletionBlock = completionHandler;
    
    SLAlbumViewController *albumViewController = [[UIStoryboard storyboardWithName:@"SLImagePicker" bundle:nil] instantiateViewControllerWithIdentifier:@"AlbumStoryboardID"];
    
    albumViewController.selectionType = SLPhotoType;

    [albumViewController setMultipleCompletionBlock:^(BOOL success, NSMutableArray *multiplePhotos) {
        if (self.multipleCompletionBlock) {
            self.multipleCompletionBlock(success, multiplePhotos);
        }
    }];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)selectMultipleVideoWithCompletionHandler:(void(^)(BOOL success, NSMutableArray *multipleVideo))completionHandler
{
    self.multipleCompletionBlock = completionHandler;
    
    SLAlbumViewController *albumViewController = [[UIStoryboard storyboardWithName:@"SLImagePicker" bundle:nil] instantiateViewControllerWithIdentifier:@"AlbumStoryboardID"];
    
    albumViewController.selectionType = SLVideoType;
    
    [albumViewController setMultipleCompletionBlock:^(BOOL success, NSMutableArray *multipleVideo) {
        if (self.multipleCompletionBlock) {
            self.multipleCompletionBlock(success, multipleVideo);
        }
    }];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
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
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage * selectedImage = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
        self.completionBlock(YES, selectedImage);
    }
    else if ([mediaType isEqualToString:@"public.movie"]){
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        AVAsset *avAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        
        self.completionBlock(YES, avAsset);
    }
}

@end
