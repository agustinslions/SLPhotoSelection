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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestAuthorizationCompletion:^{
        [self getAlbumsAssets];
    } failure:^{
        if (self.multipleCompletionBlock) {
            self.multipleCompletionBlock(NO, nil);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)requestAuthorizationCompletion:(void(^)())completion failure:(void(^)())failure
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        if (completion) completion();
    } else {
        //No permission. Trying to normally request it
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{

                if (status != PHAuthorizationStatusAuthorized) {
                    //User don't give us permission. Showing alert with redirection to settings
                    //Getting description string from info.plist file
                    NSString *accessDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:accessDescription
                                                                                              message:@"To give permissions tap on 'Change Settings' button"
                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                           style:UIAlertActionStyleCancel
                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                             if (failure) failure();
                                                                         }];
                    [alertController addAction:cancelAction];
                    
                    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Change Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        if (failure) failure();
                        //TODO:
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
//                                                           options:nil
//                                                 completionHandler:nil];
                    }];
                    [alertController addAction:settingsAction];
                    
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                } else {
                    if (completion) completion();
                }
            });
        }];
    }
}

- (void)getAlbumsAssets
{
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    
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
    
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    
    for (PHAssetCollection *assetCollection in smartAlbums) {
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
        if (assetsFetchResult.count > 0) [assets addObject:assetCollection];
    }
    
    self.albumSelections = assets;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.albumSelections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"albumCellIdentifier";
    SLAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[SLAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PHAssetCollection *assetCollection = self.albumSelections[indexPath.row];
    
    cell.albumNameLabel.text = [assetCollection localizedTitle];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"photoSegueIdentifier"
                              sender:@{@"assetsCollection" : self.albumSelections[indexPath.row]}];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"photoSegueIdentifier"]) {
        SLPhotoViewController *photoViewController = [segue destinationViewController];
        photoViewController.assetCollections = sender[@"assetsCollection"];
        photoViewController.selectionType = self.selectionType;
        photoViewController.multipleCompletionBlock = self.multipleCompletionBlock;
    }
}

@end
