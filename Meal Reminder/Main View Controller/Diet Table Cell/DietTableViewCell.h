//
//  DietTableViewCell.h
//  Meal Reminder
//
//  Created by Inspire One on 05/02/19.
//  Copyright © 2019 Inspire One. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DietTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *food_name_label;
@property (weak, nonatomic) IBOutlet UILabel *meal_time_label;
@property (weak, nonatomic) IBOutlet UIButton *add_reminder;
@property (weak, nonatomic) IBOutlet UIView *add_reminder_content_view;

@end

NS_ASSUME_NONNULL_END
