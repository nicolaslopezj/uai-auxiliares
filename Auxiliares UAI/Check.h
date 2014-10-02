//
//  Check.h
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 29-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Check : NSManagedObject

@property (nonatomic, retain) NSString * aux_id;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * event;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * uploaded;

@end
