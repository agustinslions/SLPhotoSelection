//
//  SLPhotoViewController.m
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 22/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import "SLPhotoViewController.h"
#import "SLPhotoView.h"

#define kWidthImageView     (self.view.frame.size.width / 3)

@interface SLPhotoViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, strong) NSMutableArray *selectedPhotoArray;

@end

@implementation SLPhotoViewController

#pragma mark - LifeCycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initializeAttributes];
    [self setUpPhotoImages];
    [self setUpNavigationBarButton];
    
    
    [self setUpScrollImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize methods

- (void)initializeAttributes
{
    self.selectedPhotoArray = [NSMutableArray array];
}

- (void)setUpPhotoImages
{
    NSMutableArray *libraryAssets = [NSMutableArray array];
    
    //set up fetch options, mediaType is image.
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    switch (self.selectionType) {
        case SLPhotoType: options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
            break;
        case SLVideoType: options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeVideo];
            break;
        default:
            break;
    }
    
    PHFetchResult *collectionResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollections options:options];
    
    [collectionResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        [libraryAssets addObject:asset];
    }];
    
    self.photoArray = libraryAssets;
}

- (void)setUpNavigationBarButton
{
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:self
                                                                                   action:@selector(doneAction)];
    [self.navigationItem setRightBarButtonItem:doneBarButton];
}

#pragma mark - Setup methods

- (void)setUpScrollImages
{
    for (int i = 0; i < [self.photoArray count]; i++) {
        CGRect frame = CGRectMake((i % 3) * kWidthImageView, kWidthImageView * (int)(i/3), kWidthImageView, kWidthImageView);
        
        SLPhotoView *photoView;
        
        if (self.selectionType == SLPhotoType) {
            photoView = [[SLPhotoView alloc] initWithFrame:frame
                                                withAssets:self.photoArray[i]
                                            selectionBlock:^(UIImage *image) {
                                                [self selection:image];
                                            } deselectBlock:^(UIImage *image) {
                                                [self deselection:image];
                                            }];
        } else {
            photoView = [[SLPhotoView alloc] initWithFrame:frame withAssets:self.photoArray[i]
                                       selectionVideoBlock:^(PHAsset *video) {
                                           [self selection:video];
                                       } deselectVideoBlock:^(PHAsset *video) {
                                           [self deselection:video];
                                       }];
                         
        }
        
        [self.scrollView addSubview:photoView];
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, kWidthImageView * self.photoArray.count)];
}

#pragma mark - Actions methods

- (void)selection:(id)object
{
    [self.selectedPhotoArray addObject:object];
}

- (void)deselection:(id)object
{
    [self.selectedPhotoArray removeObject:object];
}

- (void)doneAction
{
    if (self.multipleCompletionBlock) {
        self.multipleCompletionBlock(YES, self.selectedPhotoArray);
        self.multipleCompletionBlock = nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
