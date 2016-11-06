//
//  SBDefines.m
//  SoapBox
//
//  Created by Bogdan Shcherbyna on 2/25/15.
//  Copyright (c) 2015 Bohdan Shcherbyna. All rights reserved.
//

#import "Defines.h"

@implementation Defines



//Get timestamp for this day`s 00-00
+ (NSNumber *)getDayTimestampByTimestamp: (double) timestamp
{
    NSDate * now = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    //    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *dayTime = [calendar dateFromComponents:components];
    
    return [NSNumber numberWithDouble:[dayTime timeIntervalSince1970]];
}


+ (NSString *)appServer
{
    
    return LIVE_SERVER_URL;
}

#pragma mark - text filed validation
+ (BOOL)checkForValidationAnEmail:(NSString *)email
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validateFieldText:(NSString *)text
{
    if (text.length < 1) {
        return NO;
    }
    return YES;
}

@end
