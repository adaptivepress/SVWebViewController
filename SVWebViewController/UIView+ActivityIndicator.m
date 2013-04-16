//
//  UIView+ActivityIndicator.m
//  AdaptivePressEngine
//
//  Created by Artur Wdowiarski on 11.04.2013.
//  Copyright (c) 2013 AdaptivePress Sp. z o.o. All rights reserved.
//

#import "UIView+ActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static char AVWebViewActvityIndicator;
static char AVWebViewActvityIndicatorBackground;

@implementation UIView (ActivityIndicator)

- (void)setActivityIndicatorBackgroundView:(UIView *)backgroundView {
    [self willChangeValueForKey:@"activityIndicatorBackgroundView"];
    objc_setAssociatedObject(self, &AVWebViewActvityIndicatorBackground,
                             backgroundView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"activityIndicatorBackgroundView"];
}

- (UIView *)activityIndicatorBackgroundView {
    return objc_getAssociatedObject(self, &AVWebViewActvityIndicatorBackground);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    [self willChangeValueForKey:@"activityIndicator"];
    objc_setAssociatedObject(self, &AVWebViewActvityIndicator,
                             activityIndicator,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"activityIndicator"];
}

- (UIActivityIndicatorView *)activityIndicator {
    return objc_getAssociatedObject(self, &AVWebViewActvityIndicator);
}

- (void)startActivityIndicator
{
    if ([self activityIndicator]) {
        return;
    }

    int backgroundEdgeLength = 100;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - backgroundEdgeLength/2,
                                                              self.frame.size.height/2 - backgroundEdgeLength/2,
                                                              backgroundEdgeLength,
                                                              backgroundEdgeLength)];
    
    backgroundView.alpha = 0.85;
    backgroundView.layer.zPosition = 100;
    backgroundView.layer.cornerRadius = 10;
    backgroundView.layer.masksToBounds = YES;
    backgroundView.backgroundColor = [UIColor blackColor];
    
    objc_setAssociatedObject(self, &AVWebViewActvityIndicatorBackground,
                             backgroundView,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [self addSubview:[self activityIndicatorBackgroundView]];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect activityIndicatorFrame = activityIndicator.frame;
    activityIndicator.frame = CGRectMake(self.frame.size.width/2 - activityIndicatorFrame.size.width/2,
                                         self.frame.size.height/2 - activityIndicatorFrame.size.height/2,
                                         activityIndicatorFrame.size.width,
                                         activityIndicatorFrame.size.height);
    
    activityIndicator.layer.zPosition = 101;
    
    objc_setAssociatedObject(self, &AVWebViewActvityIndicator,
                             activityIndicator,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [self addSubview:[self activityIndicator]];
    [[self activityIndicator] startAnimating];
}

- (void)stopActivityIndicator
{
    [[self activityIndicatorBackgroundView] removeFromSuperview];
    [self setActivityIndicatorBackgroundView:nil];
    [[self activityIndicator] removeFromSuperview];
    [self setActivityIndicator:nil];
}

@end