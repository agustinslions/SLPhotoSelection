//
//  SLPhotoView.h
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 23/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void (^SLAssetSelectionBlock)(PHAsset *asset);

@interface SLPhotoView : UIView

@property (copy) SLAssetSelectionBlock selectionBlock;
@property (copy) SLAssetSelectionBlock deselectionBlock;


@property (nonatomic, strong) NSString *selectionNibNameView UI_APPEARANCE_SELECTOR;

- (id)initWithFrame:(CGRect)frame
         withAssets:(PHAsset *)asset
     selectionBlock:(SLAssetSelectionBlock)selectionBlock
      deselectBlock:(SLAssetSelectionBlock)deselectionBlock;

@end
