//
//  Util.m
//  DailyReader
//
//  Created by 施铭 on 14/10/31.
//  Copyright (c) 2014年 SellaMoe. All rights reserved.
//

#import "Util.h"

int date[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

//月份
static const int MONTH_NUM = 12;

@implementation Util

+ (NSString*) randomDate
{
    int randMonth = (arc4random() % (MONTH_NUM)) + 1;
    int randDay = (arc4random() % (date[randMonth - 1])) + 1;
    
    NSString *astring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"2014-%d-%d", randMonth, randDay]];
    
//    return astring;
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDateString = [dateformatter stringFromDate:currentDate];

    unsigned units = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [myCal components:units fromDate:currentDate];
    NSInteger currentMonth = [comp month];
    NSInteger currentDay = [comp day];
    
    if (randMonth > currentMonth)
    {
        return self.randomDate;
    }
    else if (randMonth == currentMonth)
    {
        if (randDay > currentDay)
        {
            return self.randomDate;
        }
        else
        {
            return astring;
        }
    }
    else
    {
        return astring;
    }
}

+ (NSString*) currentDate
{
    NSDate *currentDate = [NSDate date];
    unsigned units = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [myCal components:units fromDate:currentDate];
    NSInteger currentYear = [comp year];
    NSInteger currentMonth = [comp month];
    NSInteger currentDay = [comp day];
    
    NSString *currentDateString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%ld-%ld-%ld", currentYear, currentMonth, (long)currentDay]];
    
    return currentDateString;
}

@end

