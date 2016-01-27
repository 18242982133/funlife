//
//  ArticleCellType3.m
//  FunLife
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "ArticleCellType3.h"
#import "UIImageView+WebCache.h"

@interface ArticleCellType3 ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation ArticleCellType3

- (void)setData:(ArticleItemData *)data
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl]];
    self.label1.text = data.title;
    self.label2.text = data.subtitle;
}

@end
