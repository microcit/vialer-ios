//
//  NSDate+RelativeDate.m
//  Appic
//
//  Created by Reinier Wieringa on 06/11/13.
//  Copyright (c) 2013 Voys. All rights reserved.
//

#import "NSDate+RelativeDate.h"

@implementation NSDate (RelativeDate)

static NSDateFormatter *midnightDateFormatter = nil;
static NSDateFormatter *dayDateFormatter = nil;
static NSDateFormatter *utcDateFormatter = nil;

- (NSString *)relativeDayTimeString {
    if (!midnightDateFormatter) {
        midnightDateFormatter = [[NSDateFormatter alloc] init];
        [midnightDateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    if (!dayDateFormatter) {
        dayDateFormatter = [[NSDateFormatter alloc] init];
        [dayDateFormatter setDateStyle:NSDateFormatterShortStyle];
    }

	NSDate *midnight = [midnightDateFormatter dateFromString:[midnightDateFormatter stringFromDate:self]];
	NSInteger daysAgo = (NSInteger)[midnight timeIntervalSinceNow] / (60 * 60 * 24);
    NSString *day = [dayDateFormatter stringFromDate:self];
	if (daysAgo == 0) {
        day = NSLocalizedString(@"today", nil);
    } else if (daysAgo == -1) {
        day = NSLocalizedString(@"yesterday", nil);
    }
    if (daysAgo > -1) {
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
        return [NSString stringWithFormat:@"%@ at %@", day, [timeFormatter stringFromDate:self]];
    }

    return day;
}

- (NSString *)relativeDayString {
	NSDate *midnight = [midnightDateFormatter dateFromString:[midnightDateFormatter stringFromDate:self]];
	NSInteger daysAgo = (NSInteger)[midnight timeIntervalSinceNow] / (60 * 60 * 24);
    
    NSString *day = [dayDateFormatter stringFromDate:self];

	if (daysAgo == 0) {
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
        day = [[timeFormatter stringFromDate:self] uppercaseString];
    } else if (daysAgo == -1) {
        day = [NSLocalizedString(@"yesterday", nil) capitalizedString];
    }

    return day;
}

- (BOOL)isEmpty {
    return [self timeIntervalSince1970] == 0;
}

- (NSString *)utcString {
    if (!utcDateFormatter) {
        utcDateFormatter = [[NSDateFormatter alloc] init];
        [utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [utcDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    return [utcDateFormatter stringFromDate:self];
}

+ (NSDate *)dateFromUtcString:(NSString *)utcString {
    if (!utcDateFormatter) {
        utcDateFormatter = [[NSDateFormatter alloc] init];
        [utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [utcDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    return [utcDateFormatter dateFromString:utcString];
}

+ (NSDate *)emptyDate {
    return [NSDate dateWithTimeIntervalSince1970:0];
}

@end
