//
//  DietChartModel.h
//  Meal Reminder
//
//  Created by Inspire One on 05/02/19.
//  Copyright © 2019 Inspire One. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DietChartModel : NSObject
@property (strong, nonatomic) NSString *diet_duration;
@property (strong, nonatomic) NSMutableArray *week_diet_data;

+ (DietChartModel *)initWithModel:(DietChartModel *)dietModel;
@end



NS_ASSUME_NONNULL_END
