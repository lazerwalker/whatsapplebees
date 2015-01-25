//
//  Message.h
//  WhatsApplebees
//
//  Created by Michael Walker on 3/6/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Parse/Parse.h>

@interface Message : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *date;

- (NSString *)time;
- (NSString *)day;

@end
