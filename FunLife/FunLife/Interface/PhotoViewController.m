//
//  PhotoViewController.m
//  FunLife
//
//  Created by qianfeng on 15/9/6.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "UIViewAdditions.h"

@interface PhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray * imageViewArray = [NSMutableArray arrayWithCapacity:self.urlArray.count];
    for (NSString * url in self.urlArray) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imageView];
        UIActivityIndicatorView * aiv =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [imageView addSubview:aiv];
        [aiv startAnimating];
        [aiv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView.mas_centerX);
            make.centerY.equalTo(imageView.mas_centerY);
        }];

        [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [aiv stopAnimating];
        }];
        
        [imageViewArray addObject:imageView];
    }
    
    for (NSInteger i=0; i<imageViewArray.count; i++) {
        UIImageView * imageView = imageViewArray[i];
        UIImageView * lastView = i==0 ? nil : imageViewArray[i-1];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_top);
            if (!lastView) {
                make.left.equalTo(self.scrollView.mas_left);
            }
            else {
                make.left.equalTo(lastView.mas_right);
            }
            
            make.width.equalTo(self.scrollView.mas_width);
            make.height.equalTo(self.scrollView.mas_height);
        }];
    }
    
    self.pageControl.numberOfPages = self.urlArray.count;
    self.pageControl.currentPage = self.index;
    self.scrollView.delegate = self;
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onTapped: (UITapGestureRecognizer *) gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*self.urlArray.count, self.scrollView.height);
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.width*self.pageControl.currentPage, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger newIndex = self.scrollView.contentOffset.x / self.scrollView.width;
    if (newIndex>=0) {
        self.pageControl.currentPage = newIndex;
    }
}

-(BOOL)shouldAutorotate {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
