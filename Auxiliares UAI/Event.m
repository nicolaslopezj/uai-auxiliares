//
//  Event.m
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 16-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import "Event.h"
#import "Check.h"
#import "NLJHelper.h"

@implementation Event

- (id)initFromDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        
        _classId         = [NSNumber numberWithInt:[[dictionary objectForKey:@"idclase"] intValue]] ;
        _name            = [dictionary objectForKey:@"evento"];
        _startDate       = [self dateFromString:[dictionary objectForKey:@"fechaHoraInicio"]];
        _endDate         = [self dateFromString:[dictionary objectForKey:@"fechaHoraFin"]];
        _room            = [dictionary objectForKey:@"sala"];
        _lastEditDate    = [self dateFromString:[dictionary objectForKey:@"ultimaModificacion"]];
        __description     = [dictionary objectForKey:@"descripcion"];
        _attendant       = [dictionary objectForKey:@"responsable"];
        _teacherRut      = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"profeRut"]];
        _teacherName     = [dictionary objectForKey:@"profeNombre"];
        _teacherLastName = [dictionary objectForKey:@"profeApellido"];
        _helperRut       = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"ayudanteRut"]];
        _helperName      = [dictionary objectForKey:@"ayudanteNombre"];
        _helperLastName  = [dictionary objectForKey:@"ayudanteApellido"];
        _module          = [dictionary objectForKey:@"modulo"];
    }
    
    return self;
}

- (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormat dateFromString:string];;
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormat stringFromDate:date];
}

- (BOOL)isCheckedinManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Check" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event = %@", self.classId];
    [request setPredicate:predicate];
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:nil];
    return ((count != NSNotFound) ? count : 0) > 0;
}

- (void)deleteCheckInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (![self isCheckedinManagedObjectContext:managedObjectContext]) {
        NSLog(@"Tried to delete a check that not exists");
        return;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Check" inManagedObjectContext:managedObjectContext]];
    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event = %@", self.classId];
    [request setPredicate:predicate];
    
    NSArray *checks = [managedObjectContext executeFetchRequest:request error:nil];

    for (NSManagedObject *check in checks) {
        [managedObjectContext deleteObject:check];
    }
    [managedObjectContext save:nil];
}

- (void)toggleCheckInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (!([self.classId integerValue] > 0)) return;
    
    if ([self isCheckedinManagedObjectContext:managedObjectContext]) {
        [self deleteCheckInManagedObjectContext:managedObjectContext];
        return;
    }
    
    Check *check = [NSEntityDescription insertNewObjectForEntityForName:@"Check" inManagedObjectContext:managedObjectContext];
    check.aux_id = [NLJHelper getAuxId];
    check.comment = @"";
    check.date = [NSDate date];
    check.type = @"Check";
    check.event = self.classId;
    check.uploaded = [NSNumber numberWithBool:NO];
    
    NSError *error;
    [managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error saving %@", error.localizedDescription);
    }
}

- (void)toggleCheckInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withComment:(NSString *)comment
{
    if (!([self.classId integerValue] > 0)) return;
    
    if ([self isCheckedinManagedObjectContext:managedObjectContext]) {
        [self deleteCheckInManagedObjectContext:managedObjectContext];
        return;
    }
    
    Check *check = [NSEntityDescription insertNewObjectForEntityForName:@"Check" inManagedObjectContext:managedObjectContext];
    check.aux_id = [NLJHelper getAuxId];
    check.comment = comment;
    check.date = [NSDate date];
    check.type = @"ComCheck";
    check.event = self.classId;
    check.uploaded = [NSNumber numberWithBool:NO];
    
    [managedObjectContext save:nil];
}

- (Check *)checkInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Check" inManagedObjectContext:managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event = %@", self.classId];
    [request setPredicate:predicate];
    
    NSArray *checks = [managedObjectContext executeFetchRequest:request error:nil];
    
    for (Check *check in checks) {
        return check;
    }
    return nil;
}

@end
