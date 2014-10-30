//
//  DailyReaderViewController.m
//  LUIView
//
//  Created by 施铭 on 14/10/29.
//  Copyright (c) 2014年 Oran Wu. All rights reserved.
//

#import "DailyReaderViewController.h"
#import "Manager/HttpClientManager.h"

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
    
    NSURL *url = [NSURL URLWithString:@"http://www.magicapp.cn/app/tonight/get_article.php?date=2014-10-26"];
    NSString* showData = [[HttpClientManager sharedInstance] requestPost:url];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.origin.y += 20;
    rect.size.height -= 60;
    self.myTextField = [[UITextView alloc]initWithFrame:rect];
    self.myTextField.scrollEnabled = YES;
    self.myTextField.editable = NO;
    self.myTextField.text= showData;
//    self.myTextField.text = @"\t新浪体育讯　北京时间10月28日，俄克拉荷马雷霆队再次遭受打击，球队两名后场雷吉-杰克逊和杰里米-兰姆都在训练中受伤，他们目前只有9名健康球员。\n\n\t兰姆伤到了背部，而杰克逊则是扭伤了右脚踝，杰克逊的伤看上去更重一些，他是在两名队友的搀扶下才能离开训练场。雷霆的揭幕战是10月30日客场对阵步行者，现在还不确定这两名伤兵是否可以赶上揭幕战。此前杜兰特就是在训练中遭遇右脚第五跖骨骨折，预计可能缺阵超过8周的时间。现雷后场可能只剩威少苦撑，但他上赛季因为大伤初愈，场均出场时间只有30分钟，如果大幅增加出场时间，对他也未必是一件好事。\n\n\t雷霆也不是联盟唯一饱受伤病困扰的球队，洛杉矶湖人队已经有8名球员先后遭遇不同程度的伤病，球队中也只剩9人健康，而印第安纳步行者队除了核心乔治赛季报销，另两名主力乔治-希尔[微博]和大卫-韦斯特也确定无缘揭幕战。";
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
    UIButton* button1 = [[UIButton alloc]initWithFrame:buttonRect];
    [button1 setImage:[UIImage imageNamed:@"tabbar_client.png"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"tabbar_client_selected.png"] forState:UIControlStateSelected];
    [button1 addTarget:self action:@selector(hideTextView:) forControlEvents:UIControlEventTouchDown];
    button1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:button1];
    
    buttonRect.origin.x += screenSize.size.width / 4;
    UIButton* button2 = [[UIButton alloc]initWithFrame:buttonRect];
    [button2 setImage:[UIImage imageNamed:@"tabbar_info.png"] forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:button2];

    buttonRect.origin.x += screenSize.size.width / 4;
    UIButton* button3 = [[UIButton alloc]initWithFrame:buttonRect];
    [button3 setImage:[UIImage imageNamed:@"tabbar_more.png"] forState:UIControlStateNormal];
    button3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:button3];
    
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

@end