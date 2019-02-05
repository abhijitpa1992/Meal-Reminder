//
//  JSONManeger.h
//  AutoWiz
//
//  Created by Nihal on 10/1/15.
//  Copyright (c) 2015 Nihal Khokhari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface JSONManeger : NSObject

+ (void)JSONRequestWithparameters:(NSDictionary *)parameters Request:(NSString *)urlRequest
                       success:(void (^)(NSString *request,id JSON))success
                       failure:(void (^)(NSString *request, NSError* error))failure typeOfMethod:(NSString *)type;


@end
