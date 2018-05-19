//
//  SLPhotoViewController.h
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 22/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "SLAlbumViewController.h"

@interface SLPhotoViewController : UIViewController

@property (nonatomic, strong) PHAssetCollection *assetCollections;
@property (nonatomic, assign) SLSelectionType selectionType;

@property (copy) void (^multipleCompletionBlock)(BOOL, NSMutableArray *);

@end
