//
//  SLAlbumViewController.m
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 22/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import "SLAlbumViewController.h"
#import "SLAlbumTableViewCell.h"
#import "SLPhotoViewController.h"

#import <Photos/Photos.h>

@interface SLAlbumViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *albumSelections;

@end

@implementation SLAlbumViewController

#pragma mark - LifeCycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpNavigationBarButton];
    
    [SLPhotoManager requestAuthorizationCompletion:^{
        [self getAlbumsAssets];
    } failure:^{
        if (self.multipleCompletionBlock) {
            self.multipleCompletionBlock(NO, nil);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SetUp Methods

- (void)setUpNavigationBarButton
{
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                     target:self
                                                                                     action:@selector(cancelAction)];
    [self.navigationItem setRightBarButtonItem:cancelBarButton];
}

- (void)getAlbumsAssets
{
    self.albumSelections = [SLPhotoManager getAlbumsWithFilesType:self.selectionType];
    
    [self.tableView reloadData];
}

#pragma mark - Action methods

- (void)cancelAction
{
    if (self.multipleCompletionBlock) {
        self.multipleCompletionBlock(NO, nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.albumSelections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"albumCellIdentifier";
    SLAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[SLAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PHAssetCollection *assetCollection = self.albumSelections[indexPath.row];
    
    cell.albumNameLabel.text = [assetCollection localizedTitle];
    
    [SLPhotoManager loadFirstThumbnailForAssetCollection:assetCollection
                                           withFilesType:self.selectionType
                                              completion:^(UIImage *image, NSDictionary *info) {
                                                  cell.photoAlbumImage.image = image;
                                              }];
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"photoSegueIdentifier"
                              sender:@{@"assetsCollection" : self.albumSelections[indexPath.row]}];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"photoSegueIdentifier"]) {
        SLPhotoViewController *photoViewController = [segue destinationViewController];
        photoViewController.assetCollections = sender[@"assetsCollection"];
        photoViewController.selectionType = self.selectionType;
        photoViewController.multipleCompletionBlock = self.multipleCompletionBlock;
    }
}

@end
