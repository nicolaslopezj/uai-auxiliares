//
//  NLJMasterViewController.h
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 16-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NLJDetailViewController;

#import <CoreData/CoreData.h>

@interface NLJMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NLJDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
