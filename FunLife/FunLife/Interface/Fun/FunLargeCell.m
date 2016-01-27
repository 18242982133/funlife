//
//  FunLargeCell.m
//  FunLife
//
//  Created by qianfeng on 15/8/31.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "FunLargeCell.h"
#include "UIImageView+WebCache.h"
#import "UIViewAdditions.h"

@interface FunLargeCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation FunLargeCell

- (void)setData:(FunData *)data
{
    [self.scrollView removeAllSubviews];
    
    self.label.text = data.title;
    
    float x = 0;
    for (NSString * url in data.imageArray) {
        CGRect frame = CGRectMake(x, 0, self.contentView.width, self.contentView.height);
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        [self.scrollView addSubview:imageView];
        x += self.contentView.width;
    }
    
    self.pageControl.numberOfPages = data.imageArray.count;
    self.pageControl.currentPage = 0;
    
    self.scrollView.contentSize = CGSizeMake(x, self.contentView.height);
    self.scrollView.delegate = self;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger newIndex = self.scrollView.contentOffset.x / self.scrollView.width;
    if (newIndex>=0) {
        self.pageControl.currentPage = newIndex;
    }
}

@end
