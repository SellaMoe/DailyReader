//
//  DailyReaderViewController.m
//  LUIView
//
//  Created by 施铭 on 14/10/29.
//  Copyright (c) 2014年 Oran Wu. All rights reserved.
//

#import "DailyReaderViewController.h"
#import "Util.h"
#import "MKNetworkKit/MKNetworkKit.h"
#import "UIToastView.h"
#import "Constant.h"

//按钮高度
static const int BTNS_HEIGHT = 40;

static const float TOAST_DURATION = 1.5f;

@implementation DailyReaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mode = DAY;
        self.btnGruopVisible = YES;
        self.isLoading = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clickCalendarForArticle:)
                                                     name:DATE_SELECTED
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clickCalendarDismissed:)
                                                     name:DISMISS_CALENDAR
                                                   object:nil];
        
        self.colorEgg = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    self.articleBackground = [[UIImageView alloc] initWithFrame:rect];
//    [self.articleBackground setImage:[UIImage imageNamed:ARTICAL_BACKGROUND_DAY]];
    
    rect.origin.y += 20;
    rect.size.height -= 20;
    rect.origin.x += 10;
    rect.size.width -= 20;
    
    self.myTextField = [[UITextView alloc]initWithFrame:rect];
    self.myTextField.scrollEnabled = YES;
    self.myTextField.editable = NO;
    
    self.myTextField.font = [UIFont fontWithName:@"Helvetica Neue" size:24];
    self.myTextField.userInteractionEnabled = YES;
    self.myTextField.showsVerticalScrollIndicator = YES;
    self.myTextField.showsVerticalScrollIndicator = NO;
    self.myTextField.backgroundColor = [UIColor clearColor];
    self.articleBackground.userInteractionEnabled = YES;
    [self.view addSubview:self.articleBackground];
    [self.articleBackground addSubview:self.myTextField];
    
    // Create and initialize a tap gesture
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToTapGesture:)];
    
    // Specify that the gesture must be a single tap
    tapRecognizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
    [self.myTextField addGestureRecognizer:tapRecognizer];
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGRect btnGroupFrame = CGRectMake(0, screenSize.size.height - BTNS_HEIGHT,
                                      screenSize.size.width, BTNS_HEIGHT);
    self.btnsGroup = [[UIView alloc] initWithFrame:btnGroupFrame];
    self.btnsGroup.backgroundColor = [UIColor blackColor];
    
    CGRect buttonRect = [[UIScreen mainScreen] bounds];
    buttonRect.origin.x = 0;
    buttonRect.origin.y = 0;
    buttonRect.size.height = BTNS_HEIGHT;
    buttonRect.size.width = screenSize.size.width / 4;
    
    //切换白天夜晚模式按钮
    self.btnChangeMode = [[UIButton alloc]initWithFrame:buttonRect];
    [self.btnChangeMode setImage:[UIImage imageNamed:ACTION_NIGHT] forState:UIControlStateNormal];
    [self.btnChangeMode addTarget:self action:@selector(switchTextView:) forControlEvents:UIControlEventTouchDown];
    self.btnChangeMode.backgroundColor = [UIColor blackColor];
    [self.btnsGroup addSubview:self.btnChangeMode];
    
    //日历按钮
    buttonRect.origin.x += screenSize.size.width / 4;
    self.btnDate = [[UIButton alloc]initWithFrame:buttonRect];
    [self.btnDate setImage:[UIImage imageNamed:ACTION_CALENDAR] forState:UIControlStateNormal];
    [self.btnDate addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventTouchDown];
    self.btnDate.backgroundColor = [UIColor blackColor];
    [self.btnsGroup addSubview:self.btnDate];

    //随机文章按钮
    buttonRect.origin.x += screenSize.size.width / 4;
    self.btnRefreshArticle = [[UIButton alloc]initWithFrame:buttonRect];
    [self.btnRefreshArticle setImage:[UIImage imageNamed:ACTION_RANDOM] forState:UIControlStateNormal];
    [self.btnRefreshArticle addTarget:self action:@selector(randomArticle:) forControlEvents:UIControlEventTouchDown];
    self.btnRefreshArticle.backgroundColor = [UIColor blackColor];
    [self.btnsGroup addSubview:self.btnRefreshArticle];
    
    //更多按钮
    buttonRect.origin.x += screenSize.size.width / 4;
    self.btnMore = [[UIButton alloc]initWithFrame:buttonRect];
    [self.btnMore setImage:[UIImage imageNamed:ACTION_MORE] forState:UIControlStateNormal];
    [self.btnMore addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchDown];
    self.btnMore.backgroundColor = [UIColor blackColor];
    [self.btnsGroup addSubview:self.btnMore];
    
    [self.view addSubview:self.btnsGroup];
    
    
    //加载当天的文章
    [self refreshArticleForDate:[Util currentDate]];
}

//切换显示效果
- (void)switchTextView:(UIButton *)sender
{
    switch (self.mode) {
        case DAY:
            self.mode = NIGHT;
            break;
        case NIGHT:
            self.mode = DAY;
        default:
            break;
    }
    [self refreshTextViewColor];
}

- (void)refreshTextViewColor
{
    switch (self.mode) {
        case NIGHT:
//            [self.articleBackground setImage:[UIImage imageNamed:ARTICAL_BACKGROUND_NIGHT]];
//            self.myTextField.textColor = [UIColor whiteColor];
            self.articleBackground.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
            [self.articleBackground setImage:nil];
            self.myTextField.textColor = [UIColor colorWithRed:107.0/255.0 green:107.0/255.0 blue:107.0/255.0 alpha:1.0];
            [self.btnChangeMode setImage:[UIImage imageNamed:ACTION_DAY] forState:UIControlStateNormal];
            break;
        case DAY:
            [self.articleBackground setImage:[UIImage imageNamed:ARTICAL_BACKGROUND_DAY]];
//            self.articleBackground.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
            self.myTextField.textColor = [UIColor blackColor];
            [self.btnChangeMode setImage:[UIImage imageNamed:ACTION_NIGHT] forState:UIControlStateNormal];
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
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGRect rectInWindw = sender.frame;
    rectInWindw.origin.x = screenSize.size.width / 4;
    rectInWindw.origin.y = screenSize.size.height - BTNS_HEIGHT;
    
    [self.btnDate setImage:[UIImage imageNamed:ACTION_CALENDAR_SELECTED] forState:UIControlStateNormal];
    
    [self.pmCC presentCalendarFromView:sender.superview
         permittedArrowDirections:PMCalendarArrowDirectionAny
                  rectInAppWindow:rectInWindw
                         animated:YES];
}

- (void)showMore:(UIButton*)sender
{
    UIToastView *copyright = [[UIToastView alloc] init];
    if (++self.colorEgg % 5 == 0) {
        [copyright setToastType:0 withToast:COLOR_EGG toastTime:TOAST_DURATION];
    }
    else
    {
        [copyright setToastType:0 withToast:COPYRIGHT toastTime:TOAST_DURATION];
    }
    
    [self.view addSubview:copyright];
}

-(void)refreshArticle:(NSDictionary*)articleData
{
    NSString *article = [articleData objectForKey:@"detail"];
    NSString *articleTitle = [articleData objectForKey:@"title"];
    NSString *author = [articleData objectForKey:@"author"];
    
    NSString *textTotal = [[NSString alloc] initWithString:[NSString stringWithFormat:@"\n%@\n\n\t%@\n\n%@", articleTitle, author, article]];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textTotal];
    
    int index = 0;
    //设置标题字体
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]
                range:NSMakeRange(index, articleTitle.length + 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica Neue" size:24.0] range:NSMakeRange(index, articleTitle.length + 1)];
    
    index += (articleTitle.length + 1);
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]
                range:NSMakeRange(index, author.length + 3)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica Neue" size:18.0] range:NSMakeRange(index, author.length + 3)];
    
    index += (author.length + 3);
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]
                range:NSMakeRange(index, article.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica Neue" size:18.0] range:NSMakeRange(index, article.length)];
    self.myTextField.attributedText = str;
    [self refreshTextViewColor];
}

-(void) requestPost: (NSString*) url
{
    if (self.isLoading)
    {
        return;
    }
    //加载框
    UIToastView *image = [[UIToastView alloc] init];
    [image setToastType:1 withToast:LOADING toastTime:0];
    [self.view addSubview:image];
    self.isLoading = YES;
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:SERVER_HOST customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:url params:nil httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation)
    {
        NSData* received = [operation responseData];
//        NSLog(@"response : %@", received);
        NSString *jsonString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary* arrayResult =[dic objectForKey:@"DATA"];
        //存在文章，直接刷新
        if (arrayResult != nil)
        {
            [self refreshArticle:arrayResult];
            
            [self.pmCC dismissCalendarAnimated:YES];
            [self.btnDate setImage:[UIImage imageNamed:ACTION_CALENDAR] forState:UIControlStateNormal];
        }
        //文章不存在，给出提示
        else
        {
            UIToastView *noArticle = [[UIToastView alloc] init];
            [noArticle setToastType:0 withToast:NOARTICLE toastTime:TOAST_DURATION];
            [self.view addSubview:noArticle];
        }
        
        [image removeFromSuperview];
        self.isLoading = NO;
     } errorHandler:^(MKNetworkOperation *errorOP, NSError *err)
     {
         NSLog(@"MKNET 请求错误 : %@", [err localizedDescription]);
         UIToastView *noNetWork = [[UIToastView alloc] init];
         [noNetWork setToastType:0 withToast:DISCONNECTED toastTime:TOAST_DURATION];
         [self.view addSubview:noNetWork];
         
         [image removeFromSuperview];
         self.isLoading = NO;
     }];
    [engine enqueueOperation:op];
}

- (void)respondToTapGesture:(UIGestureRecognizer*)sender
{
    [self hideButtonGroup];
}

- (void) clickCalendarForArticle:(NSNotification *) notice
{
    NSString *selectedDate = [notice object];
    
    [self refreshArticleForDate:selectedDate];
}

- (void) clickCalendarDismissed:(NSNotification *) notice
{
    [self.pmCC dismissCalendarAnimated:YES];
    [self.btnDate setImage:[UIImage imageNamed:ACTION_CALENDAR] forState:UIControlStateNormal];
}

- (void)refreshArticleForDate:(NSString*) date
{
    NSString *formatedURL = [[NSString alloc] initWithString:[NSString stringWithFormat:DATE_FORMAT, date]];
    
    NSURL *url = [NSURL URLWithString:formatedURL];
    [self requestPost:formatedURL];
//    NSDictionary *articleData = [[HttpClientManager sharedInstance] requestPost:url];
}

//随机刷新一篇文章
- (void)randomArticle:(UIButton *)sender
{
    NSString *randomDate = [Util randomDate];
    [self refreshArticleForDate:randomDate];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//隐藏或显示按钮
-(void) hideButtonGroup
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:0];
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
  //  NSURL *url = [NSURL URLWithString:formatedURL];
  //  NSString* showData = [[HttpClientManager sharedInstance] requestPost:url];
    //当前可见，隐藏按钮
    if (self.btnGruopVisible)
    {
        self.btnsGroup.center = CGPointMake(screenSize.size.width / 2, screenSize.size.height + (BTNS_HEIGHT / 2));
    }
    //不可见，显示按钮
    else
    {
        self.btnsGroup.center = CGPointMake(screenSize.size.width / 2, screenSize.size.height - (BTNS_HEIGHT / 2));
    }
    self.btnGruopVisible = !self.btnGruopVisible;

    [UIView commitAnimations];
}

@end