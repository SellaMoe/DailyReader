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

@property (strong, nonatomic) UITextView *myTextField;
@property enum DayNightMode mode;
@property (nonatomic, strong) PMCalendarController *pmCC;


@end