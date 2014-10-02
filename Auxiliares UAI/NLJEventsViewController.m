//
//  NLJEventsViewController.m
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 16-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import "NLJEventsViewController.h"
#import "NLJEventViewController.h"
#import "Event.h"
#import "NLJEventCell.h"
#import "NLJCircleView.h"
#import "NLJHelper.h"
#import "NLJLoginViewController.h"
#import "ChameleonFramework/Chameleon.h"
#import "UIImage+NLJWithColor.h"

@implementation NLJEventsViewController

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _reloadButton = [[DAReloadActivityButton alloc] init];
    _reloadButton.showsTouchWhenHighlighted = NO;
    [_reloadButton addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_reloadButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Salir" style:UIBarButtonItemStyleBordered target:self action:@selector(logout:)];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (NLJEventViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    if ([NLJHelper isLoggedIn]) {
        [self downloadData];
    } else {
        [self showLoginView];
    }
    
}

- (void)logout:(id)sender
{
    [NLJHelper setDefaultsValue:@"" forKey:@"aux_id"];
    [self showLoginView];
}

- (void)showLoginView
{
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NLJLoginViewController* loginViewController = [mainstoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)startNetworkIndicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (![_reloadButton isAnimating]) {
        [_reloadButton startAnimating];
    }
}

- (void)endNetworkIndicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_reloadButton stopAnimating];
}

#pragma mark - Events Manipulation

- (void)downloadData
{
    [self startNetworkIndicator];
    [NLJHelper getEventsWithCallbackBlock:^(id events) {
        if ([events isKindOfClass:[NSDictionary class]]) {
            _events = events;
            [self updateBuildings];
        }
        
        NSLog(@"Events Downloaded");
        [self endNetworkIndicator];
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [self uploadData];
    }];
}

- (void)uploadData
{
    NSArray *events = [self checksReadyToUpload];
    
    if (events.count == 0) {
        NSLog(@"No checks to upload");
        return;
    }
    
    [self startNetworkIndicator];
    [NLJHelper uploadEvents:events WithCallbackBlock:^(id object, NSError *error) {
        [self endNetworkIndicator];
        
        if (error) {
            NSLog(@"Error uploading data: \"%@\"", error.localizedDescription);
        } else {
            if ([[[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding] isEqualToString:@"OK"]) {
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:[NSEntityDescription entityForName:@"Check" inManagedObjectContext:self.managedObjectContext]];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploaded != %@", [NSNumber numberWithBool:YES]];
                [request setPredicate:predicate];
                
                NSArray *checks = [self.managedObjectContext executeFetchRequest:request error:nil];
                
                for (Check *check in checks) {
                    check.uploaded = [NSNumber numberWithBool:YES];
                }
                [self.managedObjectContext save:nil];
                
                [self.detailViewController configureView];
                NSLog(@"Checks uploaded correctly");
            } else {
                NSLog(@"Error with response: \"%@\"", [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding]);
            }
        }
    }];
}

- (void)updateBuildings
{
    NSArray *keys = self.events.allKeys;

    while(self.buildingsSegmentedControl.numberOfSegments > 0)
    {
        [self.buildingsSegmentedControl removeSegmentAtIndex:0 animated:NO];
    }
    
    for (int i = 0; i < keys.count; i++) {
        NSLog(@"Building: %@", [keys objectAtIndex:i]);
        [self.buildingsSegmentedControl insertSegmentWithTitle:[keys objectAtIndex:i] atIndex:i animated:NO];
    }
}

- (NSInteger)getSelectedBuilding
{
    NSInteger selected = 0;
    if (self.selectedBuildingIndex <= self.buildingsSegmentedControl.numberOfSegments) {
        selected = self.selectedBuildingIndex;
    }
    
    self.buildingsSegmentedControl.selectedSegmentIndex = selected;
    return selected;
}

- (IBAction)selectedBuildingSegmentedControlValueChanged:(id)sender {
    self.selectedBuildingIndex = self.buildingsSegmentedControl.selectedSegmentIndex;
    [self.tableView reloadData];
}

- (NSArray *)checksReadyToUpload
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Check" inManagedObjectContext:self.managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploaded == %@", [NSNumber numberWithBool:NO]];
    [request setPredicate:predicate];
    
    NSArray *checksObject = [self.managedObjectContext executeFetchRequest:request error:nil];
    NSMutableArray *checks = [[NSMutableArray alloc] init];
    for (Check *check in checksObject) {
        [checks addObject:[[NSDictionary alloc] initWithObjects:@[[check.event stringValue],
                                                                [check stringFromDate],
                                                                check.type,
                                                                check.comment]
                                                        forKeys:@[@"idclases",
                                                                @"fechaHoraChequeo",
                                                                @"tipoChequeo",
                                                                @"Comentario"]]];
    }
    
    return [NSArray arrayWithArray:checks];
}

- (void)reloadData:(id)sender
{
    [self downloadData];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return [(NLJAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSegments = [self.buildingsSegmentedControl numberOfSegments];
    if (numberOfSegments == 0) {
        return 0;
    }
    
    NSString *key = [self.buildingsSegmentedControl titleForSegmentAtIndex:[self getSelectedBuilding]];
    return [[[self.events objectForKey:key] allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *buildingKey = [self.buildingsSegmentedControl titleForSegmentAtIndex:[self getSelectedBuilding]];
    NSArray *keys = [[self.events objectForKey:buildingKey] allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *moduleKey = [sortedKeys objectAtIndex:section];
    
    return [@"Modulo " stringByAppendingString:moduleKey];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *buildingKey = [self.buildingsSegmentedControl titleForSegmentAtIndex:[self getSelectedBuilding]];
    NSArray *keys = [[self.events objectForKey:buildingKey] allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *moduleKey = [sortedKeys objectAtIndex:section];
    
    return [[[self.events objectForKey:buildingKey] objectForKey:moduleKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NLJEventCell *cell = (NLJEventCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *buildingKey = [self.buildingsSegmentedControl titleForSegmentAtIndex:[self getSelectedBuilding]];
    NSArray *keys = [[self.events objectForKey:buildingKey] allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *moduleKey = [sortedKeys objectAtIndex:indexPath.section];
    
    Event *event = [[[self.events objectForKey:buildingKey] objectForKey:moduleKey] objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = event.name;
    cell.roomLabel.text = event.room;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    cell.dateLabel.text = [[[dateFormat stringFromDate:event.startDate]
                           stringByAppendingString:@" - "]
                           stringByAppendingString:[dateFormat stringFromDate:event.endDate]];
    
    BOOL isChecked = [event isCheckedinManagedObjectContext:self.managedObjectContext];
    BOOL hasComment = event._description.length > 0;
    
    if (isChecked) {
        cell.colorView.alpha = 0.0f;
        cell.selectedLineView.backgroundColor = FlatBlueDark;
        [cell.colorView setPushingHaloVisible:NO];
    } else if (hasComment) {
        cell.colorView.alpha = 1.0f;
        cell.colorView.backgroundColor = FlatRed;
        cell.selectedLineView.backgroundColor = FlatRed;
        [cell.colorView setPushingHaloVisible:YES];
    } else {
        cell.colorView.alpha = 1.0f;
        cell.colorView.backgroundColor = FlatBlueDark;
        cell.selectedLineView.backgroundColor = FlatBlueDark;
        [cell.colorView setPushingHaloVisible:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *buildingKey = [self.buildingsSegmentedControl titleForSegmentAtIndex:[self getSelectedBuilding]];
    NSArray *keys = [[self.events objectForKey:buildingKey] allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *moduleKey = [sortedKeys objectAtIndex:indexPath.section];
    
    Event *event = [[[self.events objectForKey:buildingKey] objectForKey:moduleKey] objectAtIndex:indexPath.row];
    self.detailViewController.event = event;
    self.detailViewController.masterViewController = self;
}


@end