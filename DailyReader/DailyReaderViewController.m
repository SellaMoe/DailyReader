//
//  DailyReaderViewController.m
//  LUIView
//
//  Created by 施铭 on 14/10/29.
//  Copyright (c) 2014年 Oran Wu. All rights reserved.
//

#import "DailyReaderViewController.h"
#import "Manager/HttpClientManager.h"
#import "Util.h"

NSString *DATE_FORMAT = @"http://www.magicapp.cn/app/tonight/get_article.php?date=%@";

@implementation DailyReaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mode = DAY;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.origin.y += 20;
    rect.size.height -= 60;
    self.myTextField = [[UITextView alloc]initWithFrame:rect];
    self.myTextField.scrollEnabled = YES;
    self.myTextField.editable = NO;
    
    self.myTextField.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:20];
    self.myTextField.userInteractionEnabled = YES;
    self.myTextField.showsVerticalScrollIndicator = YES;
    self.myTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTextField];
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGRect buttonRect = [[UIScreen mainScreen] bounds];
    buttonRect.origin.y = buttonRect.size.height - 40;
    buttonRect.size.height = 40;
    buttonRect.size.width = screenSize.size.width / 4;
    
    UIButton *btnChangeMode = [[UIButton alloc]initWithFrame:buttonRect];
    [btnChangeMode setImage:[UIImage imageNamed:@"tabbar_client.png"] forState:UIControlStateNormal];
    [btnChangeMode addTarget:self action:@selector(hideTextView:) forControlEvents:UIControlEventTouchDown];
    btnChangeMode.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnChangeMode];
    
    buttonRect.origin.x += screenSize.size.width / 4;
    UIButton *btnDate = [[UIButton alloc]initWithFrame:buttonRect];
    [btnDate setImage:[UIImage imageNamed:@"tabbar_info.png"] forState:UIControlStateNormal];
    [btnDate addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventTouchDown];
    btnDate.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnDate];

    buttonRect.origin.x += screenSize.size.width / 4;
    UIButton *btnRefreshArticle = [[UIButton alloc]initWithFrame:buttonRect];
    [btnRefreshArticle setImage:[UIImage imageNamed:@"tabbar_more.png"] forState:UIControlStateNormal];
    [btnRefreshArticle addTarget:self action:@selector(refreshArticle:) forControlEvents:UIControlEventTouchDown];
    btnRefreshArticle.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnRefreshArticle];
    
    buttonRect.origin.x += screenSize.size.width / 4;
    UIButton* button4 = [[UIButton alloc]initWithFrame:buttonRect];
    [button4 setImage:[UIImage imageNamed:@"tabbar_product.png"] forState:UIControlStateNormal];
    button4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:button4];
}

- (void)hideTextView:(UIButton *)sender
{
    switch (self.mode) {
        case DAY:
            self.myTextField.backgroundColor = [UIColor grayColor];
            self.mode = NIGHT;
            break;
        case NIGHT:
            self.myTextField.backgroundColor = [UIColor whiteColor];
            self.mode = DAY;
            break;
        default:
            break;
    }
}

- (void)showDate:(UIButton *)sender
{
    self.pmCC = [[PMCalendarController alloc] init];
    self.pmCC.delegate = self;
    self.pmCC.mondayFirstDayOfWeek = YES;
    
    [self.pmCC presentCalendarFromView:sender
         permittedArrowDirections:PMCalendarArrowDirectionAny
                         animated:YES];
}

- (void)refreshArticle:(UIButton *)sender
{
    NSString *randomDate = [Util randomDate];
    
    NSString *formatedURL = [[NSString alloc] initWithString:[NSString stringWithFormat:DATE_FORMAT, randomDate]];
    
    NSLog(randomDate);
    
    NSURL *url = [NSURL URLWithString:formatedURL];
    NSString* showData = [[HttpClientManager sharedInstance] requestPost:url];
    self.myTextField.text = showData;
}

@end