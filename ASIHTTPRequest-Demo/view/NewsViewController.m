//
//  NewsViewController.m
//  ASIHTTPRequest-Demo
//
//  Created by Jakey on 14-7-22.
//  Copyright (c) 2014年 Jakey. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCell.h"
#import "NewsDetailViewController.h"
#import "APIClient.h"
@interface NewsViewController ()

@end

@implementation NewsViewController

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
    self.title = @"资讯";
    self.dataArray = [NSMutableArray array];
    
    //假数据
    NSMutableArray *testarray = [NSMutableArray array];
    for (int i=0; i<20; i++) {
        NSDictionary *dic = @{@"topictitle": [NSString stringWithFormat:@"title==%d",i]};
        [testarray addObject:dic];
    }
    [self.dataArray addObjectsFromArray:testarray];
    
    [self loadData];
}

-(void)loadData{
   

}

#pragma mark -
#pragma -mark tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"newscell";
    [self.myTableView registerClass:[NewsCell class] forCellReuseIdentifier:CellIdentifier];
    [self.myTableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    NewsCell *cell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:@"newscell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.newstitle.text=[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"topictitle"];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsDetailViewController *detail = [[NewsDetailViewController alloc]init];
     [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
