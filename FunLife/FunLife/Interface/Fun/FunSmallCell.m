//
//  FunSmallCell.m
//  FunLife
//
//  Created by qianfeng on 15/8/31.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "FunSmallCell.h"
#import "UIImageView+WebCache.h"

static NSDictionary * colorMap = nil;

@interface FunSmallCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation FunSmallCell

+ (void)initialize
{
    colorMap = @{@"文化":[UIColor blueColor],
                 @"逗逼":[UIColor orangeColor],
                 @"音乐":[UIColor redColor],
                 @"绘画":[UIColor greenColor],
                 @"娱乐":[UIColor purpleColor],
                 };
}

- (void)awakeFromNib
{
    self.tagLabel.layer.cornerRadius = 3;
    self.tagLabel.clipsToBounds = YES;
}

- (void)setData:(FunData *)data
{
    self.title.text = data.title;
    self.subtitle.text = data.subtitle;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:data.imageArray[0]]];
    
    self.tagLabel.text = data.tag;
    self.tagLabel.backgroundColor = colorMap[data.tag];
}

@end
