//
//  SLPhotoView.m
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 23/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import "SLPhotoView.h"
#import "SLPhotoManager.h"

@interface SLPhotoView ()

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *imageAsset;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIView *selectedUIView;
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation SLPhotoView

- (id)initWithFrame:(CGRect)frame
         withAssets:(PHAsset *)asset
     selectionBlock:(SLAssetSelectionBlock)selectionBlock
      deselectBlock:(SLAssetSelectionBlock)deselectionBlock
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.isSelected = NO;
        
        self.selectionBlock = selectionBlock;
        self.deselectionBlock = deselectionBlock;
        
        self.asset = asset;
        [self setUp];
    }
    
    return self;
}

- (void)setUp
{
    [self loadImageAsset];
    [self loadButtonAction];
}

- (void)loadImageAsset
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:imageView];
    
    [SLPhotoManager loadImage:self.asset completion:^(UIImage *image, NSDictionary *info) {
        self.imageAsset = image;
        imageView.image = image;
    }];
}

- (void)loadButtonAction
{
    if (!self.actionButton) {
        self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionButton.frame = self.bounds;
        [self.actionButton addTarget:self action:@selector(selectionButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.actionButton];
    }
}

- (void)selectionButton
{
    if (!self.imageAsset) return;
    
    if (self.isSelected) {
        
        self.isSelected = NO;
        
        if (self.deselectionBlock) {
            self.deselectionBlock(self.asset);
        }

    } else {
        self.isSelected = YES;
        
        if (self.selectionBlock) {
            self.selectionBlock(self.asset);
        }
    }
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
            [self bringSubviewToFront:self.actionButton];
        }

        self.selectedUIView.hidden = NO;
        
    } else {
        if (self.selectedUIView) self.selectedUIView.hidden = YES;
    }
    
    _isSelected = isSelected;
}

@end
