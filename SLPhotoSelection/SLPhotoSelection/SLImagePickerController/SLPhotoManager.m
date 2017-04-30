//
//  SLPhotoManager.m
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 24/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import "SLPhotoManager.h"

@implementation SLPhotoManager

#pragma mark - Authorization method

+ (void)requestAuthorizationCompletion:(void(^)())completion failure:(void(^)())failure
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        if (completion) completion();
    } else {
        //No permission. Trying to normally request it
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (status != PHAuthorizationStatusAuthorized) {
                    //User don't give us permission. Showing alert with redirection to settings
                    //Getting description string from info.plist file
                    NSString *accessDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:accessDescription
                                                                                             message:NSLocalizedString(@"Go to settings to change the permissions",@"")
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                                           style:UIAlertActionStyleCancel
                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                             if (failure) failure();
                                                                         }];
                    [alertController addAction:cancelAction];
                    
                    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        if (failure) failure();
                        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                                               options:@{}
                                                     completionHandler:nil];
                        } else {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        }
                    }];
                    [alertController addAction:settingsAction];
                    
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                } else {
                    if (completion) completion();
                }
            });
        }];
    }
}

+ (NSMutableArray *)getAlbumsWithFilesType:(SLSelectionType)selectionType
{
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    
    //set up fetch options, mediaType is image.
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    switch (selectionType) {
        case SLPhotoType: options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
            break;
        case SLVideoType: options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeVideo];
            break;
        default:
            break;
    }
    
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    
    for (PHAssetCollection *assetCollection in smartAlbums) {
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
        if (assetsFetchResult.count > 0) [assets addObject:assetCollection];
    }
    
    return assets;
}

+ (NSMutableArray *)getPHAssetsForAssetCollection:(PHAssetCollection *)assetCollection
                                    withFilesType:(SLSelectionType)selectionType
{
    NSMutableArray *libraryAssets = [NSMutableArray array];
    
    //set up fetch options, mediaType is image.
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    switch (selectionType) {
        case SLPhotoType: options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
            break;
        case SLVideoType: options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeVideo];
            break;
        default:
            break;
    }
    
    PHFetchResult *collectionResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    
    [collectionResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        [libraryAssets addObject:asset];
    }];
    
    return libraryAssets;
}

+ (void)loadImage:(PHAsset *)asset completion:(void(^)(UIImage *image, NSDictionary *info))completion
{
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    
    [manager requestImageForAsset:asset
                       targetSize:PHImageManagerMaximumSize
                      contentMode:PHImageContentModeDefault
                          options:requestOptions
                    resultHandler:completion];
}

+ (void)loadFirstThumbnailForAssetCollection:(PHAssetCollection *)assetCollection
                               withFilesType:(SLSelectionType)selectionType
                                  completion:(void(^)(UIImage *image, NSDictionary *info))completion
{
    PHAsset *asset = [SLPhotoManager getPHAssetsForAssetCollection:assetCollection withFilesType:selectionType][0];
    [SLPhotoManager loadImage:asset completion:completion];
}

+ (void)loadVideo:(PHAsset *)asset
       completion:(void(^)(AVPlayerItem *playerItem, NSDictionary *info))completion;
{
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset
                                                       options:nil
                                                 resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            if (completion) {
                                                                completion(playerItem, info);
                                                            }
                                                        });
                                                 }];
}

@end
