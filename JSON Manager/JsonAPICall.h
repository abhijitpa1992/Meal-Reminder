//
//  JsonAPICall.h
//  AutoWiz
//
//  Created by Nihal on 9/21/15.
//  Copyright (c) 2015 Nihal Khokhari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "JSONManeger.h"
#import "AFNetworking.h"

@protocol JSONDelegate <NSObject>
//success
-(void)didSucceedRequest:(NSString *)request jsonData:(id)JSON;
//failure
-(void)didFailedRequest:(NSString *)request withError:(NSError *)error;
@end

@interface JsonAPICall : NSObject
@property (nonatomic, weak) id <JSONDelegate> delegate;

#pragma mark - LOCATION OF 1 VEHICLE
- (void)getDietChart;

@end
