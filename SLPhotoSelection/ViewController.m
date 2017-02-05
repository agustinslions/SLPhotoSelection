//
//  ViewController.m
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 5/2/17.
//  Copyright © 2017 Agustin De Leon. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+SLPhotoSelection.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SLPhotoSelection methods

- (IBAction)addImageView:(id)sender
{
    __weak UIImageView *imageView = self.imageView;
    
    [self addPhotoWithCompletionHandler:^(BOOL success, UIImage *image) {
        if (success) {
            imageView.image = image;
        }
    }];
}

@end
