//
//  MessageCell.m
//  WhatsApplebees
//
//  Created by Michael Walker on 3/6/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"
#import "NSObject+ClassName.h"

#import <UIView+MWLayoutHelpers.h>

static UIFont *font;
static CGFloat messageWidth;

@interface MessageCell ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end

@implementation MessageCell

+ (void)initialize {
    NSArray *nib = [NSBundle.mainBundle loadNibNamed:self.className owner:self options:nil];
    MessageCell *cell = nib[0];
    font = cell.messageLabel.font;
    messageWidth = cell.messageLabel.width;
}

+ (UIFont *)font {
    return font;
}

+ (CGFloat)messageWidth {
    return messageWidth;
}

- (void)prepareForReuse {
    self.showsDayHeader = NO;
}

- (void)awakeFromNib {
    self.dayLabel.hidden = YES;
}

- (void)setMessage:(Message *)message {
    _message = message;
    self.messageLabel.text = message.message;
    self.timestampLabel.text = message.time;
    self.dayLabel.text = message.day;
}

- (void)setShowsDayHeader:(BOOL)showsDayHeader {
    if (showsDayHeader && !_showsDayHeader) {
        self.messageLabel.top += 20;
        self.timestampLabel.top += 20;
        self.dayLabel.hidden = NO;
    } else if (!showsDayHeader && _showsDayHeader){
        self.messageLabel.top -= 20;
        self.timestampLabel.top -= 20;
        self.dayLabel.hidden = YES;
    }

    _showsDayHeader = showsDayHeader;
}

@end
