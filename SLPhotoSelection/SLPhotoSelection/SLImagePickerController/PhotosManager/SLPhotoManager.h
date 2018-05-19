//
//  SLPhotoManager.h
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 24/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef enum {
    SLPhotoType,
    SLVideoType,
    SLAllType
} SLSelectionType;

typedef void (^SLCompletionBlock)(void);
typedef void (^SLFailureBlock)(void);

@interface SLPhotoManager : NSObject

/**
 This method manages the authorization to allow access to the photos and videos of the device.
 @param completion
 The completion is executed when the authorization was allowed by the user.
 @param failure
 The failure is executed when the authorization wasn't allowed by the user.
*/
+ (void)requestAuthorizationCompletion:(SLCompletionBlock)completion
                               failure:(SLFailureBlock)failure;

+ (void)requestNotAuthorizedCompletion:(SLCompletionBlock)completion
                               failure:(SLFailureBlock)failure;

+ (NSMutableArray *)getAlbumsWithFilesType:(SLSelectionType)selectionType;

+ (NSMutableArray *)getPHAssetsForAssetCollection:(PHAssetCollection *)assetCollection
                                    withFilesType:(SLSelectionType)selectionType;

/**
 This method getting a UIImage from a PHAsset. This can called when the process of all methods are finish to get a thumbnail of the PHAsset.
 @param asset
 The asset is PHAsset selected.
 @param completion
 The completion this method return an image and dictionary with all info of the PHAsset.
 */
+ (void)loadImage:(PHAsset *)asset
       targetSize:(CGSize)targetSize
       completion:(void(^)(UIImage *image, NSDictionary *info))completion;


+ (void)loadFirstThumbnailForAssetCollection:(PHAssetCollection *)assetCollection
                                  targetSize:(CGSize)targetSize
                               withFilesType:(SLSelectionType)selectionType
                                  completion:(void(^)(UIImage *image, NSDictionary *info))completion;

+ (void)loadVideo:(PHAsset *)asset
       completion:(void(^)(AVPlayerItem *playerItem, NSDictionary *info))completion;

@end
