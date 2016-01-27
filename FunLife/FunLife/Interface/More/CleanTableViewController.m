//
//  CleanTableViewController.m
//  FunLife
//
//  Created by qianfeng on 15/9/2.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "CleanTableViewController.h"
#import "SDImageCache.h"

@interface CleanTableViewController ()
{
    NSTimer * timer;
    float angle;
}

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation CleanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    
    [self performSelector:@selector(autoClose) withObject:nil afterDelay:5];
}

- (void) onTimer: (NSTimer *) timer_
{
    self.iconView.transform = CGAffineTransformMakeRotation(angle * M_PI / 180);
    
    angle += 2;
    if (angle>360) {
        angle = 0;
    }
    
}

- (void) autoClose
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageCleaned" object:nil];
    
    [[SDImageCache sharedImageCache] clearMemory];
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [timer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
