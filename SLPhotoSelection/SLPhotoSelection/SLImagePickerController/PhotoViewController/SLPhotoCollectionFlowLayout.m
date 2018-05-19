//
//  SLPhotoCollectionFlowLayout.m
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 19/5/18.
//  Copyright © 2018 Agustin De Leon. All rights reserved.
//

#import "SLPhotoCollectionFlowLayout.h"

@implementation SLPhotoCollectionFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0.0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        [self setSectionInset:UIEdgeInsetsZero];
        
    }
    return self;
}

- (CGSize)itemSize
{
    NSInteger numberOfColumns = 4;
    
    CGFloat itemWidth =  (CGRectGetWidth(self.collectionView.frame) / numberOfColumns);
    CGFloat itemHeight = itemWidth;
    
    return CGSizeMake(itemWidth, itemHeight);
}

@end
