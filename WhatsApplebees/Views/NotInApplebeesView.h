//
//  NotInApplebeesView.h
//  WhatsApplebees
//
//  Created by Michael Walker on 4/1/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotInApplebeesView : UIView

@property (copy, nonatomic) void (^toggleBlock)(void);
@property (copy, nonatomic) void (^locateBlock)(void);

@end
