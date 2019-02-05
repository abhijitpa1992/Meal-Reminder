//
//  JsonAPICall.m
//  AutoWiz
//
//  Created by Nihal on 9/21/15.
//  Copyright (c) 2015 Nihal Khokhari. All rights reserved.
//

#import "JsonAPICall.h"

#define kRequestTimeOut 30.00

@implementation JsonAPICall

- (void) getDietChart {
    @autoreleasepool {
        
        NSString *stringUrl = [NSString stringWithFormat:@"https://naviadoctors.com/dummy/"];
        
        [JSONManeger JSONRequestWithparameters:nil Request:stringUrl success:^(NSString *request, id JSON) {
            if ([self.delegate respondsToSelector:@selector(didSucceedRequest: jsonData:)]){
                [self.delegate didSucceedRequest:request jsonData:JSON];
            }
        } failure:^(NSString *request, NSError *error) {
            if ([self.delegate respondsToSelector:@selector(didFailedRequest: withError:)]){
                [self.delegate didFailedRequest:request withError:error];
            }
        } typeOfMethod:@"GET"];
    }
}

@end
