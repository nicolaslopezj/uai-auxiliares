//
//  NLJEventCell.m
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 23-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import "NLJEventCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation NLJEventCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        self.selectedLineView.alpha = 1.0f;
    } else {
        self.selectedLineView.alpha = 0.0f;
    }
}

@end
