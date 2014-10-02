//
//  NLJCircleView.h
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 26-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PulsingHaloLayer.h"

@interface NLJCircleView : UIView
{
    PulsingHaloLayer *halo;
}

- (void)setPushingHaloVisible:(BOOL)visible;

@end
