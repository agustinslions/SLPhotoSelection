//
//  SLPhotoView.h
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 23/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void (^ImageSelectionBlock)(UIImage *image);
typedef void (^VideoSelectionBlock)(PHAsset *video);

@interface SLPhotoView : UIView

@property (copy) ImageSelectionBlock selectionBlock;
@property (copy) ImageSelectionBlock deselectionBlock;

@property (copy) VideoSelectionBlock selectionVideoBlock;
@property (copy) VideoSelectionBlock deselectionVideoBlock;

@property (nonatomic, strong) NSString *selectionNibNameView UI_APPEARANCE_SELECTOR;

- (id)initWithFrame:(CGRect)frame
         withAssets:(PHAsset *)asset
     selectionBlock:(ImageSelectionBlock)selectionBlock
      deselectBlock:(ImageSelectionBlock)deselectionBlock;

- (id)initWithFrame:(CGRect)frame
         withAssets:(PHAsset *)asset
selectionVideoBlock:(VideoSelectionBlock)selectionVideoBlock
 deselectVideoBlock:(VideoSelectionBlock)deselectionVideoBlock;

@end
