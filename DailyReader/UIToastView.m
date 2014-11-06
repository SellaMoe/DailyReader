//
//  UILoadingView.m
//  DailyReader
//
//  Created by 施铭 on 14/11/4.
//  Copyright (c) 2014年 SellaMoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIToastView.h"

//加载菊花的大小
static const float ACTIVITY_VIEW_SIZE = 40.0f;

//弹出框的宽度
static const float TOAST_WIDTH = 256;

//弹出框高度
static const int TOAST_HEIGHT = 64;

NSString *LOADING_TIPS = @"加载中";

#define UIColorMakeRGBA(nRed, nGreen, nBlue, nAlpha) [UIColor colorWithRed:(nRed)/255.0f \
green:(nGreen)/255.0f \
blue:(nBlue)/255.0f \
alpha:nAlpha]

@implementation UIToastView

- (id)init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    return self;
}

-(void) setToastType:(int)toastType withToast:(NSString*)toast toastTime:(float)duration
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.frame = screenRect;
    self.backgroundColor = UIColorMakeRGBA(0, 0, 0, 0.3);
    
    self.loadingBackGround = [[UIImageView alloc] initWithFrame:CGRectMake((screenRect.size.width - TOAST_WIDTH) / 2, (screenRect.size.height - TOAST_HEIGHT) / 2, TOAST_WIDTH, TOAST_HEIGHT)];
    [self.loadingBackGround setImage:[UIImage imageNamed:@"background.png"]];
    [self addSubview:self.loadingBackGround];
    
    if (toastType == 1)
    {
        UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView  alloc ]
                                                          initWithFrame:CGRectMake(self.loadingBackGround.frame.size.width / 8 - ACTIVITY_VIEW_SIZE / 2, self.loadingBackGround.frame.size.height / 2 - ACTIVITY_VIEW_SIZE / 2, ACTIVITY_VIEW_SIZE, ACTIVITY_VIEW_SIZE)];
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [activityIndicatorView startAnimating];
        [self.loadingBackGround addSubview:activityIndicatorView];
    }
    
    self.loadingTips = [[UILabel alloc] initWithFrame:self.loadingBackGround.frame];
    [self.loadingTips setText:toast];
    self.loadingTips.textColor = [UIColor whiteColor];
    [self.loadingTips setTextAlignment:NSTextAlignmentCenter];
    self.loadingTips.center = CGPointMake(self.loadingBackGround.frame.size.width / 2,
                                          self.loadingBackGround.frame.size.height / 2);
    
    
    [self.loadingBackGround addSubview:self.loadingTips];
    
    
    if (duration > 0)
    {
        [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(hide:) userInfo:nil repeats:NO];
    }
}

- (void)hide:(NSTimer *)timer
{
    [self removeFromSuperview];
}

@end

