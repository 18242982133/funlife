//
//  ArticleCellBase.h
//  FunLife
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleData.h"

@interface ArticleCellBase : UITableViewCell

@property (nonatomic, weak) ArticleItemData * data;

+ (float) cellHeightByType: (NSString *)type;

@end
