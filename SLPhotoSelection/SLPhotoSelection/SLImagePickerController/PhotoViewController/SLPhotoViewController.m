//
//  SLPhotoViewController.m
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 22/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import "SLPhotoViewController.h"
#import "SLConstants.h"
#import "SLPhotoCollectionViewCell.h"
#import "SLPhotoCollectionFlowLayout.h"

#define kItemsPerLine       3
#define kWidthImageView     (self.view.frame.size.width / kItemsPerLine)

@interface SLPhotoViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, strong) NSMutableArray *selectedPhotoArray;

@end

@implementation SLPhotoViewController

#pragma mark - LifeCycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initializeAttributes];
    [self setupPhotoImages];
    [self setupNavigationBarButton];
    
    [self setupCollectionView];
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

#pragma mark - Setup methods

- (void)setupPhotoImages
{
    self.photoArray = [SLPhotoManager getPHAssetsForAssetCollection:self.assetCollections
                                                      withFilesType:self.selectionType];
}

- (void)setupNavigationBarButton
{
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:self
                                                                                   action:@selector(doneAction)];
    [self.navigationItem setRightBarButtonItem:doneBarButton];
}

- (void)setupCollectionView
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"SLPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SLPhotoCollectionViewCellReusableIdentifier"];

    self.collectionView.collectionViewLayout = [[SLPhotoCollectionFlowLayout alloc] init];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.photoArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLPhotoCollectionViewCell *cell = (SLPhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SLPhotoCollectionViewCellReusableIdentifier" forIndexPath:indexPath];
    [cell setAsset:self.photoArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLPhotoCollectionViewCell *cell = (SLPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setIsSelected:!cell.isSelected];
    if (cell.isSelected) {
        [self selection:cell.asset];
    } else {
        [self deselection:cell.asset];
    }
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
    BLOCK_EXEC_MAIN_THREAD(self.multipleCompletionBlock, YES, self.selectedPhotoArray);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
