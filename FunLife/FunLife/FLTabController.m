//
//  FLTabController.m
//  FunLife
//
//  Created by qianfeng on 15/8/31.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "FLTabController.h"

@interface FLTabController ()

@end

@implementation FLTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.tintColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
    
    UITabBarItem * item0 = self.tabBar.items[0];
    item0.selectedImage = [UIImage imageNamed:@"tab_funselected"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
