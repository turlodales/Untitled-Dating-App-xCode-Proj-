//
//  Defines.h
//  Taheer
//
//  Created by Bogdan Shcherbyna on 2/25/15.
//  Copyright (c) 2015 DYC Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

//api paths
//#define UPLOAD_VIDEO @"video"


#define LIVE_SERVER_URL @""


#define ONE_MINUTE 60
#define ONE_HOUR 3600
#define ONE_DAY 86400
#define ONE_WEEK 604800
#define ONE_MONTH 2630880
#define ONE_YEAR 31536000


@interface Defines : NSObject


+ (NSNumber *)getDayTimestampByTimestamp: (double) timestamp;

+ (NSString *)appServer;

+ (BOOL)checkForValidationAnEmail:(NSString *)email;

+ (BOOL)validateFieldText:(NSString *)text;

@end