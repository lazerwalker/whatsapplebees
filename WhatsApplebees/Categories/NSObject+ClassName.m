//
//  NSObject+ClassName.m
//  WhatsApplebees
//
//  Created by Michael Walker on 4/1/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "NSObject+ClassName.h"

@implementation NSObject (ClassName)

+ (NSString *)className {
    return NSStringFromClass(self);
}
@end
