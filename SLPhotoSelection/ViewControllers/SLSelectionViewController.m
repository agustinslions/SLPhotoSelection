//
//  SLSelectionViewController.m
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 23/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import "SLSelectionViewController.h"
#import "UIViewController+SLPhotoSelection.h"

@interface SLSelectionViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end

@implementation SLSelectionViewController

#pragma mark - LifeCycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions methods

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SLPhotoSelection methods

- (IBAction)addImageView:(id)sender
{
    switch (self.photoSelectionType) {
        case SLSinglePhotoType: [self singlePhotoSelection];
            break;
        case SLSingleVideoType: [self singleVideoSelection];
            break;
        case SLMultiplePhotoType: [self multiplePhotoSelection];
            break;
        case SLMultipleVideoType: [self multipleVideoSelection];
            break;
        default:
            break;
    }
}

#pragma mark - Private methods

- (void)singlePhotoSelection
{
    __weak UIImageView *imageView = self.imageView;
    
    [self addPhotoWithCompletionHandler:^(BOOL success, id object) {
        if (success) {
            imageView.image = (UIImage *)object;
        }
    }];
}

- (void)singleVideoSelection
{
    __weak UIImageView *imageView = self.imageView;

    [self addVideoWithCompletionHandler:^(BOOL success, id object) {
        if (success) {
            AVPlayerItem *avPlayerItem = [[AVPlayerItem alloc] initWithAsset:(AVAsset *)object];
            AVPlayer *avPlayer = [[AVPlayer alloc] initWithPlayerItem:avPlayerItem];
            AVPlayerLayer *avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
            avPlayerLayer.frame = imageView.bounds;
            [imageView.layer addSublayer:avPlayerLayer];
            [avPlayer seekToTime:kCMTimeZero];
            [avPlayer play];
        }
    }];
}

- (void)multiplePhotoSelection
{
    [self selectMultiplePhotoWithCompletionHandler:^(BOOL success, NSMutableArray *multiplePhotos) {
        
        if (success) {
            float y = 0;
            
            for (PHAsset *asset in multiplePhotos) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, self.scrollView.frame.size.width, self.scrollView.frame.size.width)];
                [self.scrollView addSubview:imageView];
                
                [SLPhotoManager loadImage:asset completion:^(UIImage *image, NSDictionary *info) {
                    imageView.image = image;
                }];
                
                y += self.scrollView.frame.size.width;
            }
            
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,
                                                       self.scrollView.frame.size.width * multiplePhotos.count)];
            
        }
        
    }];
}

- (void)multipleVideoSelection
{
    [[SLPhotoView appearance] setSelectionNibNameView:@"SLCustomSelectedView"];
    
    [self selectMultipleVideoWithCompletionHandler:^(BOOL success, NSMutableArray *multipleVideo) {
        if (success) {
            float y = 0;
            
            for (PHAsset *asset in multipleVideo) {
                UIView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, self.scrollView.frame.size.width, self.scrollView.frame.size.width)];
                [self.scrollView addSubview:contentView];
                
                [SLPhotoManager loadVideo:asset
                               completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
                                   AVPlayer *avPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
                                   AVPlayerLayer *avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
                                   avPlayerLayer.frame = contentView.bounds;
                                   [contentView.layer addSublayer:avPlayerLayer];
                                   [avPlayer seekToTime:kCMTimeZero];
                                   [avPlayer play];
                               }];
                
                y += self.scrollView.frame.size.width;
            }
            
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,
                                                       self.scrollView.frame.size.width * multipleVideo.count)];
        }
    }];
}

@end
