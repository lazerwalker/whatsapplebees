//
//  MessageInputView.h
//  WhatsApplebees
//
//  Created by Michael Walker on 3/6/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Message;

@interface MessageInputView : UIView

@property (copy, nonatomic) void (^sentMessageCompletionBlock)(Message *);

@end
