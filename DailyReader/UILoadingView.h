//
//  UILoadingView.h
//  DailyReader
//
//  Created by 施铭 on 14/11/4.
//  Copyright (c) 2014年 SellaMoe. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UILoadingView : UIView

//加载背景图
@property (strong, nonatomic) UIImageView *loadingBackGround;

//加载提示
@property (strong, nonatomic) UILabel *loadingTips;

//压黑的背景
@property (strong, nonatomic) UIView *darkBackground;

@end
