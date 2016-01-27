//
//  Fun2Cell.m
//  FunLife
//
//  Created by qianfeng on 15/9/1.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "Fun2Cell.h"
#import "UIImageView+WebCache.h"

@interface Fun2Cell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageButtonHeightConstraint;

@property (nonatomic, weak) UIImageView * contentImageView;

@end

@implementation Fun2Cell

- (void)awakeFromNib {
    // Initialization code
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.imageButton.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageButton addSubview:imageView];
    
    self.contentImageView = imageView;
}

- (void)setData:(Funny2Data *)data
{
    _data = data;
    
    self.contentLabel.text = data.content;
    self.fromLabel.text = [@"来自" stringByAppendingString: data.source];
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:data.previewImageUrl]];
    
    UIImage * image = [UIImage imageNamed:@"icon_bookmark"];
    if (self.data.bookmarked) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    [self.bookmarkButton setImage:image forState:UIControlStateNormal];
    
    BOOL hasImage = data.previewImageUrl.length!=0;
    
    self.imageButtonHeightConstraint.constant = hasImage ? 128 : 0;
    
    self.imageButton.hidden = !hasImage;
    
    [self updateConstraintsIfNeeded];
}

- (IBAction)imageButtonClicked:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellImageButtonClicked:withData:)]) {
        [self.delegate cellImageButtonClicked:self withData:self.data];
    }
}

- (IBAction)bookmarkButtonClicked:(UIButton *)sender
{
    self.data.bookmarked = !self.data.bookmarked;
    
    UIImage * image = [UIImage imageNamed:@"icon_bookmark"];
    if (self.data.bookmarked) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    [self.bookmarkButton setImage:image forState:UIControlStateNormal];
}

@end
