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

@interface SLPhotoManager : NSObject

+ (void)requestAuthorizationCompletion:(void(^)())completion
                               failure:(void(^)())failure;

+ (NSMutableArray *)getAlbumsWithFilesType:(SLSelectionType)selectionType;

+ (NSMutableArray *)getPHAssetsForAssetCollection:(PHAssetCollection *)assetCollection
                                    withFilesType:(SLSelectionType)selectionType;

+ (void)loadImage:(PHAsset *)asset
       completion:(void(^)(UIImage *image, NSDictionary *info))completion;

+ (void)loadFirstThumbnailForAssetCollection:(PHAssetCollection *)assetCollection
                               withFilesType:(SLSelectionType)selectionType
                                  completion:(void(^)(UIImage *image, NSDictionary *info))completion;

@end
