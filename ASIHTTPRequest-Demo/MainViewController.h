//
//  MainViewController.h
//  ASIHTTPRequest-Demo
//
//  Created by Jakey on 14-7-22.
//  Copyright (c) 2014年 Jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MainViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *qq;
@property (weak, nonatomic) IBOutlet UILabel *email;

- (IBAction)newsTouched:(id)sender;
- (IBAction)touched:(id)sender;
- (IBAction)downFileTouhed:(id)sender;
- (IBAction)resumeDownTouched:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *request;
@end
