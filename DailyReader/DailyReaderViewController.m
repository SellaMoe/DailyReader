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
#import "UILoadingView.h"

NSString *SERVER_HOST = @"www.magicapp.cn";
NSString *DATE_FORMAT = @"app/tonight/get_article.php?date=%@";

NSString *DATE_SELECTED = @"DateSelected";

//按钮高度
static const int BTNS_HEIGHT = 40;

@implementation DailyReaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mode = DAY;
        self.btnGruopVisible = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clickCalendarForArticle:)
                                                     name:DATE_SELECTED
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    self.articleBackground = [[UIImageView alloc] initWithFrame:rect];
    [self.articleBackground setImage:[UIImage imageNamed:@"article_background_day.jpg"]];
    
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
    
    CGRect buttonRect = [[UIScreen mainScreen] bounds];
    buttonRect.origin.x = 0;
    buttonRect.origin.y = 0;
    buttonRect.size.height = BTNS_HEIGHT;
    buttonRect.size.width = screenSize.size.width / 4;
    
    UIButton *btnChangeMode = [[UIButton alloc]initWithFrame:buttonRect];
    [btnChangeMode setImage:[UIImage imageNamed:@"tabbar_client.png"] forState:UIControlStateNormal];
    [btnChangeMode addTarget:self action:@selector(switchTextView:) forControlEvents:UIControlEventTouchDown];
    btnChangeMode.backgroundColor = [UIColor whiteColor];
    [self.btnsGroup addSubview:btnChangeMode];
    
    buttonRect.origin.x += screenSize.size.width / 4;
    UIButton *btnDate = [[UIButton alloc]initWithFrame:buttonRect];
    [btnDate setImage:[UIImage imageNamed:@"tabbar_info.png"] forState:UIControlStateNormal];
    [btnDate addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventTouchDown];
    btnDate.backgroundColor = [UIColor whiteColor];
    [self.btnsGroup addSubview:btnDate];

    buttonRect.origin.x += screenSize.size.width / 4;
    UIButton *btnRefreshArticle = [[UIButton alloc]initWithFrame:buttonRect];
    [btnRefreshArticle setImage:[UIImage imageNamed:@"tabbar_more.png"] forState:UIControlStateNormal];
    [btnRefreshArticle addTarget:self action:@selector(randomArticle:) forControlEvents:UIControlEventTouchDown];
    btnRefreshArticle.backgroundColor = [UIColor whiteColor];
    [self.btnsGroup addSubview:btnRefreshArticle];
    
    buttonRect.origin.x += screenSize.size.width / 4;
    UIButton* button4 = [[UIButton alloc]initWithFrame:buttonRect];
    [button4 setImage:[UIImage imageNamed:@"tabbar_product.png"] forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(hideButtons:) forControlEvents:UIControlEventTouchDown];
    button4.backgroundColor = [UIColor whiteColor];
    [self.btnsGroup addSubview:button4];
    
    [self.view addSubview:self.btnsGroup];
    
    //刷新今天的文章
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
            [self.articleBackground setImage:[UIImage imageNamed:@"article_background_night.jpg"]];
            self.myTextField.textColor = [UIColor whiteColor];
            break;
        case DAY:
            [self.articleBackground setImage:[UIImage imageNamed:@"article_background_day.jpg"]];
            self.myTextField.textColor = [UIColor blackColor];
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
    
    [self.pmCC presentCalendarFromView:sender.superview
         permittedArrowDirections:PMCalendarArrowDirectionAny
                  rectInAppWindow:rectInWindw
                         animated:YES];
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
    //加载框
    UILoadingView *image = [[UILoadingView alloc] init];
    [self.view addSubview:image];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"www.magicapp.cn" customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:url params:nil httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation)
    {
        NSData* received = [operation responseData];
        NSLog(@"response : %@", received);
        NSString *jsonString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary* arrayResult =[dic objectForKey:@"DATA"];
        if (arrayResult != nil)
        {
            [self refreshArticle:arrayResult];
        }
        
        [image removeFromSuperview];
         
     } errorHandler:^(MKNetworkOperation *errorOP, NSError *err)
     {
         NSLog(@"MKNET 请求错误 : %@", [err localizedDescription]);
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

- (void) hideButtons:(UIButton *)sender
{
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