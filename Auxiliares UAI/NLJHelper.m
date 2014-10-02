//
//  NLJHelper.m
//  Auxiliares UAI
//
//  Created by Nicolás López on 19-06-14.
//  Copyright (c) 2014 Nicolas Lopez. All rights reserved.
//

#import "NLJHelper.h"
#import "NLJConnection.h"
#import "Event.h"

#define uploadURL @"http://firma.uai.cl/auxiliares/checkin.php"
#define downloadURL @"http://firma.uai.cl/auxiliares/clasesTablet.php"

@implementation NLJHelper

+ (void)setDefaultsValue:(NSObject *)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (NSObject *)defaultsValueForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (BOOL)isLoggedIn
{
    return [(NSString *)[self defaultsValueForKey:@"aux_id"] length] > 0;
}

+ (NSString *)getAuxId
{
    return (NSString *)[self defaultsValueForKey:@"aux_id"];
}

+ (void)getEventsWithCallbackBlock:(void (^)(id events))callbackBlock
{
    NSLog(@"Downloading events...");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [NSString stringWithFormat:@"%@?aux_id=%@", downloadURL, [NLJHelper getAuxId]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: url]];
        NSError *error;
        id events;
        
        if(data != nil){
            events = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        } else {
            NSLog(@"Data is nil");
        }
        
        if (error) {
            NSLog(@"Error downloading events: \"%@\"", error.localizedDescription);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([events isKindOfClass:[NSArray class]]) {
                callbackBlock([self parseEventsArray:events]);
            } else {
                callbackBlock(events);
            }
            
        });
    });
}

+ (NSDictionary *)parseEventsArray:(NSArray *)events
{
    NSLog(@"Parsing events");
    NSMutableDictionary *loadedEvents = [[NSMutableDictionary alloc] init];
    for (NSDictionary *_event in events) {
        Event *event = [[Event alloc] initFromDictionary:_event];
        NSArray *stringArray = [event.room componentsSeparatedByString:@"-"];
        
        NSMutableDictionary *mutableBuildingEventsWithKey;
        
        if ([[loadedEvents objectForKey:[stringArray objectAtIndex:1]] isKindOfClass:[NSDictionary class]]) {
            mutableBuildingEventsWithKey = [[loadedEvents objectForKey:[stringArray objectAtIndex:1]] mutableCopy];
        } else {
            mutableBuildingEventsWithKey = [[NSMutableDictionary alloc] init];
        }
        
        NSMutableArray *mutableEventsWithKey;
        if ([[mutableBuildingEventsWithKey objectForKey:event.module] isKindOfClass:[NSArray class]]) {
            mutableEventsWithKey = [[mutableBuildingEventsWithKey objectForKey:event.module] mutableCopy];
        } else {
            mutableEventsWithKey = [[NSMutableArray alloc] init];
        }
        
        [mutableEventsWithKey addObject:event];
        [mutableBuildingEventsWithKey setObject:[NSArray arrayWithArray:mutableEventsWithKey] forKey:event.module];
        
        [loadedEvents setObject:[NSDictionary dictionaryWithDictionary:mutableBuildingEventsWithKey] forKey:[stringArray objectAtIndex:1]];
        
    }
    
    NSDictionary *newEvents = [NSDictionary dictionaryWithDictionary:loadedEvents];
    
    newEvents = [self sortedDictionary:newEvents];
    
    NSMutableDictionary *sortedEvents = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < newEvents.allKeys.count; i++) {
        NSString *building = [newEvents.allKeys objectAtIndex:i];
        NSDictionary *module = [newEvents objectForKey:building];
        [sortedEvents setObject:[self sortedDictionary:module] forKey:building];
    }
    
    return sortedEvents;
}

+ (NSDictionary *)sortedDictionary:(NSDictionary *)dictionary
{
    NSArray *myKeys = [dictionary allKeys];
    NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableDictionary *sortedValues = [[NSMutableDictionary alloc] init];
    
    for(id key in sortedKeys) {
        id object = [dictionary objectForKey:key];
        [sortedValues setObject:object forKey:key];
    }
    
    return [NSDictionary dictionaryWithDictionary:sortedValues];
}

+ (void)uploadEvents:(NSArray *)events WithCallbackBlock:(void (^)(id object, NSError *error))callbackBlock
{
    NSLog(@"Uploading checks...");

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:uploadURL]];
    [request setHTTPMethod:@"POST"];
    
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:events options:kNilOptions error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"json" forHTTPHeaderField:@"Data-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[JSONData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:JSONData];
    
    NLJConnection *connection = [[NLJConnection alloc]initWithRequest:request];
    [connection setCompletitionBlock:^(id obj, NSError *err) {
        NSLog(@"Connection stopped");
        callbackBlock(obj, err);
    }];
    [connection start];
    NSLog(@"Starting connection...");
}

@end
