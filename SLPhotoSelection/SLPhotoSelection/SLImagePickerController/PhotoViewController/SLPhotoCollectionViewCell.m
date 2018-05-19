//
//  SLPhotoCollectionViewCell.m
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 19/5/18.
//  Copyright © 2018 Agustin De Leon. All rights reserved.
//

#import "SLPhotoCollectionViewCell.h"
#import "SLPhotoManager.h"
#import "SLConstants.h"

@interface SLPhotoCollectionViewCell ()

@property (nonatomic, weak) UIImage *imageAsset;
@property (nonatomic, strong) UIView *selectedUIView;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;

@end

@implementation SLPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    [self loadImageAsset];
}

- (void)loadImageAsset
{
    SLwself;
    
    self.imageAsset = nil;
    
    [SLPhotoManager loadImage:self.asset targetSize:self.photoImageView.frame.size completion:^(UIImage *image, NSDictionary *info) {
        wself.imageAsset = image;
        wself.photoImageView.image = image;
    }];
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (isSelected) {
        
        if (!self.selectedUIView) {
            if (self.selectionNibNameView) {
                self.selectedUIView = [[NSBundle mainBundle] loadNibNamed:self.selectionNibNameView owner:nil options:nil][0];
                self.selectedUIView.frame = self.bounds;
            } else {
                self.selectedUIView = [[UIView alloc] initWithFrame:self.bounds];
                self.selectedUIView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            }

            [self addSubview:self.selectedUIView];

            NSLayoutConstraint *leftButtonXConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.selectedUIView attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual toItem:self attribute:
                                                         NSLayoutAttributeLeft multiplier:1.0 constant:0];
            /* Top space to superview Y*/
            NSLayoutConstraint *leftButtonYConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.selectedUIView attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual toItem:self attribute:
                                                         NSLayoutAttributeTop multiplier:1.0f constant:0];
            
            NSLayoutConstraint *rightButtonXConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.selectedUIView attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual toItem:self attribute:
                                                         NSLayoutAttributeRight multiplier:1.0 constant:0];

            NSLayoutConstraint *bottomButtonXConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.selectedUIView attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual toItem:self attribute:
                                                         NSLayoutAttributeBottom multiplier:1.0 constant:0];
            
            /* 4. Add the constraints to selectedView's superview*/
            [self addConstraints:@[leftButtonXConstraint, leftButtonYConstraint, rightButtonXConstraint, bottomButtonXConstraint]];
        }
        
        self.selectedUIView.hidden = NO;
        
    } else {
        if (self.selectedUIView) self.selectedUIView.hidden = YES;
    }
    
    _isSelected = isSelected;
}

@end
