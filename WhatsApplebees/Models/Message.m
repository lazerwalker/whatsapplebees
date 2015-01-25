//
//  Message.m
//  WhatsApplebees
//
//  Created by Michael Walker on 3/6/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Message.h"
#import <Parse/PFObject+Subclass.h>

@implementation Message
@dynamic message, date;

+ (NSString *)parseClassName {
    return @"Message";
}

+ (void)load {
    [self registerSubclass];
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    });

    return _dateFormatter;
}

- (NSDateFormatter *)timeFormatter {
    static NSDateFormatter *_timeFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _timeFormatter = [NSDateFormatter new];
        _timeFormatter.timeStyle = NSDateFormatterShortStyle;
    });

    return _timeFormatter;
}


- (NSString *)time {
    return [self.timeFormatter stringFromDate:self.date];
}

- (NSString *)day {
    return [self.dateFormatter stringFromDate:self.date];
}


@end
