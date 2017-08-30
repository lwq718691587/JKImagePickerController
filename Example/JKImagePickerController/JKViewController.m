//
//  JKViewController.m
//  JKImagePickerController
//
//  Created by liuweiqiang on 08/30/2017.
//  Copyright (c) 2017 liuweiqiang. All rights reserved.
//

#import "JKViewController.h"
#import <JKImagePickerController/TZImagePickerController.h>
#import <JKImagePickerController/JKPreviewController.h>
@interface JKViewController ()<TZImagePickerControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photoArr;

@end

@implementation JKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoArr = [NSMutableArray arrayWithCapacity:5];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btn:(id)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount: 9  delegate:self];
    imagePickerVc.navigationBar.tintColor = [UIColor redColor];
    [imagePickerVc setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,NSArray<NSDictionary *> *infos){
        [self.photoArr addObjectsFromArray:photos];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}
- (IBAction)btnFun2:(id)sender {
    
    JKPreviewController *askPhotoViewController = [[JKPreviewController alloc] init];
    askPhotoViewController.photos = self.photoArr;
    askPhotoViewController.blackPageIndex = 1;
    
    [self.navigationController pushViewController:askPhotoViewController animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
