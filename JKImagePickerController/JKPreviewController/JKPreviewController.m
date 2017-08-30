//
//  ProductPhotoViewController.m
//  jiankemall
//
//  Created by jianke2 on 15/10/21.
//  Copyright © 2015年 jianke. All rights reserved.
//

#import "JKPreviewController.h"

#define jkScreenWidth                             ([UIScreen mainScreen].bounds).size.width

#define jkScreenHeight                            ([UIScreen mainScreen].bounds).size.height

@interface JKPreviewController ()<UIScrollViewDelegate>{
    UIScrollView *_pagingScrollView;
    CGFloat lastScale;
    
}
@property (nonatomic,strong) UIView *pageControlSuperView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JKPreviewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, jkScreenWidth, jkScreenHeight)];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    [self setScrollView:self.photos];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewController:)];
    [backView addGestureRecognizer:gesture];
    
    [self setHeaderViews];
   
}
- (void)setScrollView:(NSArray *)PhotoArray {
    _pagingScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, jkScreenWidth, jkScreenHeight-64)];
    _pagingScrollView.contentSize = CGSizeMake(jkScreenWidth * self.photos.count , jkScreenHeight-64);
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.showsHorizontalScrollIndicator = NO;
    _pagingScrollView.contentOffset = CGPointMake(jkScreenWidth *self.blackPageIndex, 0);
    _pagingScrollView.delegate = self;
    [self.view addSubview:_pagingScrollView];
    
    self.view.backgroundColor = [UIColor blackColor];
    for (int i = 0; i < self.photos.count; i++) {
        UITapGestureRecognizer*doubleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UIImage *image = self.photos[i];
        CGFloat scrollViewWidth = jkScreenWidth - 10;
        CGFloat scrollViewHight = (jkScreenWidth-10)/image.size.width *image.size.height;
        
        UIScrollView*scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(jkScreenWidth*i + 5,(jkScreenHeight - scrollViewHight)/2 - 64,scrollViewWidth,scrollViewHight)];
        scrollView.backgroundColor= [UIColor clearColor];
        scrollView.contentSize=CGSizeMake(jkScreenWidth,scrollViewHight);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate=self;
        scrollView.minimumZoomScale=1.0;
        scrollView.maximumZoomScale=2.0;
        [scrollView setZoomScale:1.0];
        
        UIImageView *photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,scrollViewWidth,scrollViewHight)];
        photoImage.userInteractionEnabled = YES;
        photoImage.tag = i + 1;
        photoImage.image = self.photos[i];
        [photoImage addGestureRecognizer:doubleTap];
        [scrollView addSubview:photoImage];
        [_pagingScrollView addSubview:scrollView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewController:)];
        [photoImage addGestureRecognizer:gesture];
        
        [gesture requireGestureRecognizerToFail:doubleTap];
    }

}
- (void)setHeaderViews {
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, jkScreenWidth, 64)];
    blackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:blackView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((jkScreenWidth - 120)/2, 20, 120, 44)];
    self.titleLabel.text = [NSString stringWithFormat:@"%d/%lu",(self.blackPageIndex + 1),(unsigned long)self.photos.count];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
     self.titleLabel.text = [NSString stringWithFormat:@"%d/%lu",(self.blackPageIndex + 1),(unsigned long)self.photos.count];
    [blackView addSubview:self.titleLabel];
    
    UIButton *gobackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gobackBtn.frame = CGRectMake(0, 0, 60, 60);
    gobackBtn.contentEdgeInsets = UIEdgeInsetsMake(33,20, 7, 30);
    [gobackBtn setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [gobackBtn addTarget:self action:@selector(goBackViewController) forControlEvents:UIControlEventTouchUpInside];
    [blackView addSubview:gobackBtn];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(jkScreenWidth - 80, 0, 60, 60);
    deleteButton.contentEdgeInsets = UIEdgeInsetsMake(30,40, 7, 0);
    [deleteButton setImage:[UIImage imageNamed:@"ask_delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
    [blackView addSubview:deleteButton];
    
}
- (void)goBackViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)deletePhoto {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"要删除这张相片吗？"
                                  delegate:(id)self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"删除"
                                  otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}
#pragma mark - actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self.photos removeObjectAtIndex:self.blackPageIndex];
        
        for (int i = 0; i < self.view.subviews.count; i++) {
            if ([self.view.subviews[i] isKindOfClass:[UIScrollView class]]) {
                [self.view.subviews[i] removeFromSuperview];
            }
        }
        [self setScrollView:self.photos];
        
        if (self.photos.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            _pagingScrollView.contentSize = CGSizeMake(jkScreenWidth * self.photos.count, jkScreenHeight - 100);
            _pagingScrollView.contentOffset = CGPointMake(0, 0);
            self.titleLabel.text = [NSString stringWithFormat:@"%d/%lu",(self.blackPageIndex + 1),(unsigned long)self.photos.count];
        }
        
    }
}

#pragma mark - ScrollView delegate
-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{
    for(UIView*view in scrollView.subviews){
        return view;
    }
    return nil;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    _pagingScrollView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation ==UIInterfaceOrientationPortrait||interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown)
    {
        return YES;
    }
    return NO;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    if ([scrollView isKindOfClass:[_pagingScrollView class]]) {
        CGFloat x = scrollView.contentOffset.x;
        if (x == jkScreenWidth || x == -jkScreenWidth) {
            for (UIScrollView *scroll in scrollView.subviews) {
                if ([scroll isKindOfClass:[UIScrollView class]]) {
                    [scroll setZoomScale:1.0];
                }
            }
        }
    }
}
#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer*)gesture{
    static BOOL isChangeGesture;
    static float newScale;
    if (isChangeGesture) {
        newScale = 2.0;
    }else {
        newScale = 1.0;
    }
    isChangeGesture = !isChangeGesture;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [(UIScrollView*)gesture.view.superview zoomToRect:zoomRect animated:YES];
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height= (jkScreenHeight- 100)/ scale;
    zoomRect.size.width= jkScreenWidth/ scale;
    zoomRect.origin.x= center.x- (zoomRect.size.width/2.0);
    zoomRect.origin.y= center.y- (zoomRect.size.height/2.0);
    return zoomRect;
}
- (void)backViewController:(UITapGestureRecognizer *)gesture {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    
    CGRect visibleBounds = _pagingScrollView.bounds;
    NSInteger index = (NSInteger) (floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
    if (index > self.photos.count - 1) index = self.photos.count - 1;
    self.blackPageIndex = (int)index;
    self.titleLabel.text = [NSString stringWithFormat:@"%d/%lu",(self.blackPageIndex + 1),(unsigned long)self.photos.count];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end
