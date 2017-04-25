//
//  SLAlbumViewController.h
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 22/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLPhotoManager.h"

@interface SLAlbumViewController : UIViewController

@property (nonatomic, assign) SLSelectionType selectionType;

@property (copy) void (^multipleCompletionBlock)(BOOL, NSMutableArray *);

@end
