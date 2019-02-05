
//  JSONManeger.m
//  AutoWiz
//
//  Created by Nihal on 10/1/15.
//  Copyright (c) 2015 Nihal Khokhari. All rights reserved.
//

#import "JSONManeger.h"

@implementation JSONManeger

+ (void)JSONRequestWithparameters:(NSDictionary *)parameters Request:(NSString *)urlRequest success:(void (^)(NSString *, id))success failure:(void (^)(NSString *, NSError *))failure typeOfMethod:(NSString *)type{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if ([type isEqualToString:@"POST"]) {
        [manager POST:urlRequest parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//            NSLog(@"JSON: %@", responseObject);
            success(urlRequest,responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
            failure(urlRequest,error);
        }];
    } else {
        [manager GET:urlRequest parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"JSON: %@", responseObject);
            success(urlRequest,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"Error: %@", error);
            failure(urlRequest,error);
        }];
    }
}

@end
