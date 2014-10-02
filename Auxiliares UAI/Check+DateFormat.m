//
//  Check+DateFormat.m
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 06-01-14.
//  Copyright (c) 2014 Nicolas Lopez. All rights reserved.
//

#import "Check+DateFormat.h"

@implementation Check (DateFormat)

- (NSString *)stringFromDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormat stringFromDate:self.date];
}

@end
