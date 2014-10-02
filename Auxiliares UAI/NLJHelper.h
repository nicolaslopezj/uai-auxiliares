//
//  NLJHelper.h
//  Auxiliares UAI
//
//  Created by Nicolás López on 19-06-14.
//  Copyright (c) 2014 Nicolas Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLJHelper : NSObject

+ (void)setDefaultsValue:(NSObject *)value forKey:(NSString *)key;
+ (NSObject *)defaultsValueForKey:(NSString *)key;
+ (BOOL)isLoggedIn;
+ (NSString *)getAuxId;

+ (void)getEventsWithCallbackBlock:(void (^)(id events))callbackBlock;
+ (void)uploadEvents:(NSArray *)events WithCallbackBlock:(void (^)(id object, NSError *error))callbackBlock;

@end
