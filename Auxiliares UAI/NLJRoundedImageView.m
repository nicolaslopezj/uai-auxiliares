//
//  NLJRoundedImageView.m
//  Auxiliares UAI
//
//  Created by Nicolás López on 02-10-14.
//  Copyright (c) 2014 Nicolas Lopez. All rights reserved.
//

#import "NLJRoundedImageView.h"

@implementation NLJRoundedImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width /2;
    }
    
    return self;
}

@end
