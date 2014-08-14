//
//  MainViewController.m
//  ASIHTTPRequest-Demo
//
//  Created by Jakey on 14-7-22.
//  Copyright (c) 2014年 Jakey. All rights reserved.
//

#import "MainViewController.h"

#import "NewsViewController.h"
#import "APIClient.h"
#import "User.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"主页";
}
-(void)loadUserData{
    
    NSDictionary *param = @{@"username": @"skyfox",@"password":@"123"};
    
   [User getUser:param withBlock:^(User *user, NSError *error) {
       if (error) {
           NSLog(@"网络请求失败");
           return;
       }
       self.userName.text = user.username?:@"";
       self.qq.text = user.userqq?:@"";
       self.email.text = user.useremail?:@"";
   }];
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newsTouched:(id)sender {
    NewsViewController *news = [[NewsViewController alloc]init];
    [self.navigationController pushViewController:news animated:YES];
}

- (IBAction)touched:(id)sender {
    [self loadUserData];
}

//下载
- (IBAction)downFileTouhed:(id)sender {
    
    [[APIClient sharedClient] DownloadFile:@"http://www.baidu.com/img/bdlogo.png" writeTo:[Util documentsPath] fileName:@"bdlog.png" progress:^(float progress) {
        
    } successBlock:^(NSString *savePath) {
        
    } failedBlock:^(NSError *error) {
        
    }];
}
//断点续传
- (IBAction)resumeDownTouched:(id)sender {
    [[APIClient sharedClient] DownloadFile:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V3.1.2.dmg" writeTo:[Util documentsPath] fileName:@"QQ_V3.1.2.dmg" progress:^(float progress) {
        NSLog(@"下载已完成：%.2f/100",progress*100);

    } successBlock:^(NSString *savePath) {
        NSLog(@"下载成功 savePath：%@",savePath);
        
    } failedBlock:^(NSError *error) {
        
    }];
}
@end
