//
//  NLJEventsViewController.h
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 16-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLJAppDelegate.h"
#import "DAReloadActivityButton.h"
#import "Check+DateFormat.h"

@class NLJEventViewController;

@interface NLJEventsViewController : UITableViewController <NSURLConnectionDataDelegate>

@property (nonatomic,readonly) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSDictionary *events;

@property (strong, nonatomic) NLJEventViewController *detailViewController;

@property (nonatomic, strong) DAReloadActivityButton *reloadButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *buildingsSegmentedControl;
@property (nonatomic) NSInteger selectedBuildingIndex;

@end
