//
//  DietChartModel.m
//  Meal Reminder
//
//  Created by Inspire One on 05/02/19.
//  Copyright © 2019 Inspire One. All rights reserved.
//

#import "DietChartModel.h"

@implementation DietChartModel
@synthesize diet_duration;
@synthesize week_diet_data;

+ (DietChartModel *)initWithModel:(NSDictionary *)dict{
    DietChartModel *model = [[DietChartModel alloc] init];
    
    model.diet_duration = [dict valueForKey:@"diet_duration"];
    model.week_diet_data = [dict valueForKey:@"week_diet_data"];
    
    return model;
}
@end


