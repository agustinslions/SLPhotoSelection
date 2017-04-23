//
//  SLHomeViewController.m
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 23/4/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import "SLHomeViewController.h"
#import "SLSelectionViewController.h"

@interface SLHomeViewController ()

@end

@implementation SLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SLSelectionViewController *selectionViewController = [segue destinationViewController];

    if ([[segue identifier] isEqualToString:@"singlePhotoSegue"]) {
        selectionViewController.photoSelectionType = SLSinglePhotoType;
    } else if ([[segue identifier] isEqualToString:@"singleVideoSegue"]) {
        selectionViewController.photoSelectionType = SLSingleVideoType;
    } else if ([[segue identifier] isEqualToString:@"multipleVideoSegue"]) {
        selectionViewController.photoSelectionType = SLMultipleVideoType;
    } else if ([[segue identifier] isEqualToString:@"multiplePhotoSegue"]) {
        selectionViewController.photoSelectionType = SLMultiplePhotoType;
    }
}

@end
