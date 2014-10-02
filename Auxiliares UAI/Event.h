//
//  Event.h
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 16-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Check;

@interface Event : NSObject

@property (nonatomic, strong) NSNumber * classId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDate   * startDate;
@property (nonatomic, strong) NSDate   * endDate;
@property (nonatomic, strong) NSString * room;
@property (nonatomic, strong) NSDate   * lastEditDate;
@property (nonatomic, strong) NSString * _description;
@property (nonatomic, strong) NSString * attendant;
@property (nonatomic, strong) NSString * teacherRut;
@property (nonatomic, strong) NSString * teacherName;
@property (nonatomic, strong) NSString * teacherLastName;
@property (nonatomic, strong) NSString * helperRut;
@property (nonatomic, strong) NSString * helperName;
@property (nonatomic, strong) NSString * helperLastName;
@property (nonatomic, strong) NSString * module;

- (id)initFromDictionary:(NSDictionary *)dictionary;
- (BOOL)isCheckedinManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)deleteCheckInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)toggleCheckInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)toggleCheckInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext withComment:(NSString *)comment;
- (Check *)checkInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
