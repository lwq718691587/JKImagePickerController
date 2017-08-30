//
//  ProductPhotoViewController.h
//  jiankemall
//
//  Created by jianke2 on 15/10/21.
//  Copyright © 2015年 jianke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKPreviewController : UIViewController


/**
 不需要删除回调
 */
+ (UINavigationController *)createWith:(NSMutableArray *)photos
                        blackPageIndex:(int)blackPageIndex;


/**
 需要删除回调
 */
+ (UINavigationController *)createWith:(NSMutableArray *)photos
                        blackPageIndex:(int)blackPageIndex
                    deleteSuccessBlcok:(void(^)(NSMutableArray * photos))deleteSuccessBlcok;

@property (nonatomic, copy) void(^deleteSuccess)(NSMutableArray * photos);

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, assign) int blackPageIndex;




@end
