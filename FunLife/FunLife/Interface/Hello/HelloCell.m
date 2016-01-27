//
//  HelloCell.m
//  FunLife
//
//  Created by qianfeng on 15/9/2.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "HelloCell.h"
#import "UIImageView+WebCache.h"
#import "UIViewAdditions.h"
#import "UIButton+AutoWidth.h"
#import "NSString+Frame.h"

@interface HelloCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *genderView;
@property (weak, nonatomic) IBOutlet UILabel *locaionLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *contentFrameView;
@property (weak, nonatomic) IBOutlet UIView *contentFrameLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageFrameViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandButtonHeightConstraint;


@end

@implementation HelloCell

- (void)awakeFromNib {
    // Initialization code
    self.contentFrameView.layer.cornerRadius = 5;
    self.contentFrameLine.layer.cornerRadius = 5;
    self.iconView.layer.cornerRadius = 3;
    self.iconView.clipsToBounds = YES;
    
}

- (void)setData:(HelloData *)data
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:data.iconUrl] placeholderImage:[UIImage imageNamed:@"user"]];
    [self.nameButton setTitle:data.name forState:UIControlStateNormal];
    self.contentLabel.text = data.content;
    self.timeLabel.text = data.time;
    self.genderView.image = [UIImage imageNamed:data.gender==0?@"icon_male":@"icon_female"];
    self.locaionLabel.text = data.city;
    
    [self.expandButton setTitle:data.expanded?@"收起":@"展开" forState:UIControlStateNormal];

    float contentWidth = self.contentView.width - 20;
    [self.imageFrameView setImageArray:data.photoArray withinWidth:contentWidth];
    
    self.nameButtonWidthConstraint.constant = ceil([self.nameButton adjustWidth]);
    self.imageFrameViewHeightConstraint.constant = [ImageFrameView contentHeightWithImages:data.photoArray withinWidth:contentWidth];
    
    float contentHeight = [data.content heightWithFont:self.contentLabel.font withinWidth:contentWidth];
    
    float expandButtonHeight = 0;
    
    if (data.needExpand) {
        if (!data.expanded) {
            contentHeight = 21 * 5;
        }
        
        expandButtonHeight = 30;
    }
    self.contentLabelHeightConstraint.constant = contentHeight;
    self.expandButtonHeightConstraint.constant = expandButtonHeight;

    self.expandButton.hidden = !data.needExpand;
}

@end
