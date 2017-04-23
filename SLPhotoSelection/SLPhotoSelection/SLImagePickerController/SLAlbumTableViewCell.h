//
//  SLAlbumTableViewCell.h
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 22/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLAlbumTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *photoAlbumImage;
@property (nonatomic, weak) IBOutlet UILabel *albumNameLabel;

@end
