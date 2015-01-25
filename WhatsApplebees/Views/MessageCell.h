//
//  MessageCell.h
//  WhatsApplebees
//
//  Created by Michael Walker on 3/6/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@class Message;

@interface MessageCell : UITableViewCell

@property (strong, nonatomic) Message *message;
@property (assign, nonatomic) BOOL showsDayHeader;

+ (UIFont *)font;
+ (CGFloat)messageWidth;

@end
