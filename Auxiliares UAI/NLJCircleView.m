//
//  NLJCircleView.m
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 26-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import "NLJCircleView.h"

@implementation NLJCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.layer.masksToBounds = NO;
        
        halo = [PulsingHaloLayer layer];
        halo.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        halo.radius = self.frame.size.width * 1.5f;
        [self.layer addSublayer:halo];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    halo.backgroundColor = backgroundColor.CGColor;
}

- (void)setPushingHaloVisible:(BOOL)visible
{
    if (visible) {
        halo.radius = self.frame.size.width;
    } else  {
        halo.radius = 0;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
