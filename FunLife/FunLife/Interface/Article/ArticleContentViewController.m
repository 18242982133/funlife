//
//  ArticleContentViewController.m
//  FunLife
//
//  Created by qianfeng on 15/9/10.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "ArticleContentViewController.h"
#import "ArticleData.h"

@interface ArticleContentViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *prevBarButton;

@end

@implementation ArticleContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ArticleItemData * item = self.data[self.index];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.url]];
    
    [self.webView loadRequest: request];
    
    self.nextBarButton.enabled = (self.index!=self.data.count-1);
    self.prevBarButton.enabled = self.index>0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextBarButtonClicked:(UIBarButtonItem *)sender {
    self.index ++;
    if (self.index>=self.data.count) {
        self.index = self.data.count - 1;
        self.nextBarButton.enabled = NO;
    }
    
    self.prevBarButton.enabled = YES;
    
    ArticleItemData * item = self.data[self.index];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.url]];
    
    [self.webView loadRequest: request];

}

- (IBAction)prevBarButtonClicked:(UIBarButtonItem *)sender {
    self.index --;
    if (self.index==0) {
        self.prevBarButton.enabled = NO;
    }
    
    self.nextBarButton.enabled = YES;
    
    ArticleItemData * item = self.data[self.index];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.url]];
    
    [self.webView loadRequest: request];

}

@end
