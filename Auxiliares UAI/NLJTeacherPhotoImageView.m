//
//  NLJTeacherPhotoImageView.m
//  Auxiliares UAI
//
//  Created by Nicolás López on 02-10-14.
//  Copyright (c) 2014 Nicolas Lopez. All rights reserved.
//

#import "NLJTeacherPhotoImageView.h"

@implementation NLJTeacherPhotoImageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
    }
    
    return self;
}

@end
