//
//  ViewController.m
//  转盘Demo
//
//  Created by JackX on 2020/5/21.
//  Copyright © 2020 App. All rights reserved.
//

#import "ViewController.h"
#import "LuckyWheel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    LuckyWheel *wheel = [[LuckyWheel alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.width)];
    wheel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [wheel StartRotation];
    [self.view addSubview:wheel];
    // Do any additional setup after loading the view.
}


@end
