//
//  ModalPushTransition.m
//  FunLife
//
//  Created by qianfeng on 15/9/10.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "ModalPushTransition.h"

@implementation ModalPushTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * destionationViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect targetRect = [transitionContext finalFrameForViewController:destionationViewController];
    
    if (self.push) {
        destionationViewController.view.frame = CGRectOffset(targetRect, [UIScreen mainScreen].bounds.size.width, 0);
    }
    else {
        destionationViewController.view.frame = CGRectOffset(targetRect, -[UIScreen mainScreen].bounds.size.width, 0);
    }
    
    UIView * view = [transitionContext containerView];
    [view addSubview:destionationViewController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ destionationViewController.view.frame = targetRect; }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
    
    
//    [UIView animateWithDuration:0.4
//                     animations:^{
//                         destionationViewController.view.frame = targetRect;
//                     } completion:^(BOOL finished) {
//                         [transitionContext completeTransition:YES];
//                     }];
}

@end
