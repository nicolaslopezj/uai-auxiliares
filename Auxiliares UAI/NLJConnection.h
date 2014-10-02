//
//  NLJConnection.h
//  Auxiliares UAI
//
//  Created by Nicolás López on 19-06-14.
//  Copyright (c) 2014 Nicolas Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLJConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSURLConnection * internalConnection;
    NSMutableData * container;
}

-(id)initWithRequest:(NSURLRequest *)req;

@property (nonatomic,copy)NSURLConnection * internalConnection;
@property (nonatomic,copy)NSURLRequest *request;
@property (nonatomic,copy)void (^completitionBlock) (id obj, NSError * err);


-(void)start;

@end
