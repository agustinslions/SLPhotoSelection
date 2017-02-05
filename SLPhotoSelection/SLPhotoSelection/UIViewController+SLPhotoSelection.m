//
//  UIViewController+SLPhotoSelection.m
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 5/2/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import "UIViewController+SLPhotoSelection.h"
#import <objc/runtime.h>

@implementation UIViewController (SLPhotoSelection)

static char UIB_PROPERTY_KEY;

#pragma mark - Getter and setter methods

- (void)setCompletionBlock:(void (^)(BOOL, UIImage *))completionBlock
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(BOOL, UIImage *))completionBlock
{
    return (void (^)(BOOL, UIImage *))objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

#pragma mark - Publick methods

- (void)addPhotoWithCompletionHandler:(void (^)(BOOL, UIImage *))completionHandler
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
            picker1.delegate = self;
            [self presentViewController:picker1 animated:YES completion:nil];
        }
    }]];
    
    self.completionBlock = completionHandler;
    
    [self presentViewController:actionSheet animated:YES completion:nil];
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
    UIImage * selectedImage = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
    self.completionBlock(YES, selectedImage);
}

@end
