//
//  ViewController.m
//  Meal Reminder
//
//  Created by Inspire One on 04/02/19.
//  Copyright © 2019 Inspire One. All rights reserved.
//

#import "ViewController.h"
#import "EMVerticalSegmentedControl.h"
#import "DietTableViewCell.h"
#import "JsonAPICall.h"
#import "DietChartModel.h"
@import EventKit;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, JSONDelegate> {
    DietChartModel *dietModel;
    NSInteger dayIndex;
    EKEventStore *store;
}

@property (weak, nonatomic) IBOutlet UIView *segment_content_view;
@property (weak, nonatomic) IBOutlet UITableView *diet_table_view;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeReminder
                          completion:^(BOOL granted, NSError *error) {
                              // Handle not being granted permission
                          }];
    
    EMVerticalSegmentedControl *control = [[EMVerticalSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, self.segment_content_view.frame.size.width, self.segment_content_view.frame.size.height)];
    control.sectionTitles = @[@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
    [control addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventValueChanged];
    
    [control setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"Value changed in block: %lu", index);
        self->dayIndex = index;
        [self->_diet_table_view reloadData];
    }];
    [self.segment_content_view addSubview:control];
    
    [self getDietChart];
}

- (void)addReminderForDay:(EKWeekday)day withTime:(NSString*)time andTitle:(NSString*)title forSender:(UIView *)sender
{
    NSPredicate *predicate = [store predicateForRemindersInCalendars:nil];
    __block BOOL foundReminder = NO;

    [store fetchRemindersMatchingPredicate:predicate completion:^(NSArray<EKReminder *> * _Nullable reminders) {
        for (EKReminder *reminder in reminders) {
            NSLog(@"%@",reminder.title);
            if ([reminder.title isEqualToString:title]) {
                foundReminder = YES;
                [reminder setTitle:title];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"HH:mm";
                NSDate *date = [formatter dateFromString:time];
                
                EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
                
                [reminder addAlarm:alarm];
                
                EKRecurrenceDayOfWeek *dow = [[EKRecurrenceDayOfWeek alloc] initWithDayOfTheWeek:day weekNumber:1];
                
                NSArray<EKRecurrenceDayOfWeek *> *dow_array = [[NSArray alloc] initWithObjects:dow, nil];
                
                EKRecurrenceRule *recuranceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 daysOfTheWeek:dow_array daysOfTheMonth:NULL monthsOfTheYear:NULL weeksOfTheYear:NULL daysOfTheYear:NULL setPositions:NULL end:[EKRecurrenceEnd recurrenceEndWithEndDate:[NSDate dateWithTimeIntervalSinceNow:31536000*10]]];
                
                [reminder addRecurrenceRule:recuranceRule];
                
                unsigned unitFlags= NSCalendarUnitYear|NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone;
                NSCalendar *gregorian = [[NSCalendar alloc]
                                         initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *dailyComponents=[gregorian components:unitFlags fromDate:date];
                [reminder setDueDateComponents:dailyComponents];
                
                EKCalendar *defaultReminderList = [self->store defaultCalendarForNewReminders];
                
                [reminder setCalendar:defaultReminderList];
                
                NSError *error = nil;
                BOOL success = [self->store saveReminder:reminder
                                            commit:YES
                                             error:&error];
                if (!success) {
                    NSLog(@"Error saving reminder: %@", [error localizedDescription]);
                } else {
                    [[NSUserDefaults standardUserDefaults] setValue:@"EVENT_SAVED" forKey:title];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sender.hidden = YES;
                    });
                }

                break;
            }
        }
        
        if (!foundReminder) {
            EKReminder *reminder = [EKReminder reminderWithEventStore:self->store];
            [reminder setTitle:title];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"HH:mm";
            NSDate *date = [formatter dateFromString:time];
            
            EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
            
            [reminder addAlarm:alarm];
            
            EKRecurrenceDayOfWeek *dow = [[EKRecurrenceDayOfWeek alloc] initWithDayOfTheWeek:day weekNumber:1];
            
            NSArray<EKRecurrenceDayOfWeek *> *dow_array = [[NSArray alloc] initWithObjects:dow, nil];
            
            EKRecurrenceRule *recuranceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 daysOfTheWeek:dow_array daysOfTheMonth:NULL monthsOfTheYear:NULL weeksOfTheYear:NULL daysOfTheYear:NULL setPositions:NULL end:[EKRecurrenceEnd recurrenceEndWithEndDate:[NSDate dateWithTimeIntervalSinceNow:31536000*10]]];
            
            [reminder addRecurrenceRule:recuranceRule];
            
            unsigned unitFlags= NSCalendarUnitYear|NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone;
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *dailyComponents=[gregorian components:unitFlags fromDate:date];
            [reminder setDueDateComponents:dailyComponents];
            
            EKCalendar *defaultReminderList = [self->store defaultCalendarForNewReminders];
            
            [reminder setCalendar:defaultReminderList];
            
            NSError *error = nil;
            BOOL success = [self->store saveReminder:reminder
                                              commit:YES
                                               error:&error];
            if (!success) {
                NSLog(@"Error saving reminder: %@", [error localizedDescription]);
            } else {
                [[NSUserDefaults standardUserDefaults] setValue:@"EVENT_SAVED" forKey:title];
                dispatch_async(dispatch_get_main_queue(), ^{
                    sender.hidden = YES;
                });
            }
        }
    }];
}

- (void)segmentDidChange:(id)sender {
    NSInteger index = ((EMVerticalSegmentedControl *)sender).selectedSegmentIndex;
    NSLog(@"Value changed selector: %lu", index);
    dayIndex = index;
    [_diet_table_view reloadData];
}

- (void) getDietChart {
    JsonAPICall *apicall = [[JsonAPICall alloc] init];
    apicall.delegate = self;
    [apicall getDietChart];
}

- (void)didSucceedRequest:(NSString *)request jsonData:(id)JSON {
    dietModel = [DietChartModel initWithModel:JSON];
    [_diet_table_view reloadData];
}

- (void)didFailedRequest:(NSString *)request withError:(NSError *)error {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self getDietDataForDay:dayIndex].count;
}

- (NSArray *) getDietDataForDay:(NSInteger)index {
    switch (dayIndex) {
        case 0:
            return ((NSArray*)[dietModel.week_diet_data valueForKey:@"sunday"]);
            break;
            
        case 1:
            return ((NSArray*)[dietModel.week_diet_data valueForKey:@"monday"]);
            break;
            
        case 2:
            return ((NSArray*)[dietModel.week_diet_data valueForKey:@"tuesday"]);
            break;
            
        case 3:
            return ((NSArray*)[dietModel.week_diet_data valueForKey:@"wednesday"]);
            break;
            
        case 4:
            return ((NSArray*)[dietModel.week_diet_data valueForKey:@"thursday"]);
            break;
            
        case 5:
            return ((NSArray*)[dietModel.week_diet_data valueForKey:@"friday"]);
            break;
            
        case 6:
            return ((NSArray*)[dietModel.week_diet_data valueForKey:@"saturday"]);
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DietTableViewCell";
    DietTableViewCell *cell = (DietTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.add_reminder.tag = indexPath.row;
    [cell.add_reminder addTarget:self action:@selector(set_reminder:) forControlEvents:UIControlEventTouchUpInside];
    cell.food_name_label.text = [[[self getDietDataForDay:dayIndex] objectAtIndex:indexPath.row] valueForKey:@"food"];
    cell.meal_time_label.text = [[[self getDietDataForDay:dayIndex] objectAtIndex:indexPath.row] valueForKey:@"meal_time"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:cell.food_name_label.text] isEqualToString:@"EVENT_SAVED"]) {
        cell.add_reminder_content_view.hidden = YES;
    } else {
        cell.add_reminder_content_view.hidden = NO;
    }
    return cell;
}

- (IBAction)set_reminder:(UIButton *)sender {
    switch (dayIndex) {
        case 0:
            [self addReminderForDay:EKWeekdaySunday withTime:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"meal_time"] andTitle:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"food"] forSender:[sender superview]];
            break;
            
        case 1:
            [self addReminderForDay:EKWeekdayMonday withTime:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"meal_time"] andTitle:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"food"] forSender:[sender superview]];
            break;
            
        case 2:
            [self addReminderForDay:EKWeekdayTuesday withTime:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"meal_time"] andTitle:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"food"] forSender:[sender superview]];
            break;
            
        case 3:
            [self addReminderForDay:EKWeekdayWednesday withTime:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"meal_time"] andTitle:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"food"] forSender:[sender superview]];
            break;
            
        case 4:
            [self addReminderForDay:EKWeekdayThursday withTime:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"meal_time"] andTitle:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"food"] forSender:[sender superview]];
            break;
            
        case 5:
            [self addReminderForDay:EKWeekdayFriday withTime:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"meal_time"] andTitle:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"food"] forSender:[sender superview]];
            break;
            
        case 6:
            [self addReminderForDay:EKWeekdaySaturday withTime:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"meal_time"] andTitle:[[[self getDietDataForDay:dayIndex] objectAtIndex:sender.tag] valueForKey:@"food"] forSender:[sender superview]];
            break;
            
        default:
            break;
    }
}
@end
