//
//  SLPhotoCollectionViewCell.h
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 19/5/18.
//  Copyright © 2018 Agustin De Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface SLPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *selectionNibNameView UI_APPEARANCE_SELECTOR;
@property (nonatomic, weak) PHAsset *asset;
@property (nonatomic, assign) BOOL isSelected;

@end
