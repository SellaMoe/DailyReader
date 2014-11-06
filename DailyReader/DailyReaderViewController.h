//
//  DialyReaderViewController.h
//  LUIView
//
//  Created by 施铭 on 14/10/29.
//  Copyright (c) 2014年 Oran Wu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PMCalendarController.h"

@interface DailyReaderViewController : UIViewController

//夜晚模式切换
enum DayNightMode
{
    DAY = 0,
    NIGHT = 1
};

@property (nonatomic) int colorEgg;

@property (strong, nonatomic) UITextView *myTextField;
@property enum DayNightMode mode;
@property (strong, nonatomic) PMCalendarController *pmCC;
@property (strong, nonatomic) UIView *btnsGroup;

//切换白天夜晚模式按钮
@property (strong, nonatomic) UIButton *btnChangeMode;

//随机文章按钮
@property (strong, nonatomic) UIButton *btnRefreshArticle;

//日历按钮
@property (strong, nonatomic) UIButton *btnDate;

//更多功能按钮
@property (strong, nonatomic) UIButton *btnMore;
@property (strong, nonatomic) UIImageView *articleBackground;
@property (nonatomic) BOOL btnGruopVisible;

//当前是否在加载状态
@property (nonatomic) BOOL isLoading;

@end