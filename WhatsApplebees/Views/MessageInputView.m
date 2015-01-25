//
//  MessageInputView.m
//  WhatsApplebees
//
//  Created by Michael Walker on 3/6/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "MessageInputView.h"
#import "Message.h"

#import <UIView+MWLayoutHelpers.h>
#import <UIView+FLKAutoLayout.h>

@interface MessageInputView ()<UITextViewDelegate>
@property (strong, nonatomic) UITextView *input;

@end

@implementation MessageInputView

- (id)init {
    self = [super init];
    if (!self) return nil;

    [self render];

    return self;
}

- (void)render {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.frame];
    [self addSubview:toolbar];
    [toolbar alignToView:self];

    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(didTapSendButton:)];

    self.input = [[UITextView alloc] initWithFrame:CGRectZero];
    self.input.width = 230.0;
    self.input.height = 30.0;

    self.input.layer.cornerRadius = 5.f;
    self.input.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f].CGColor;
    self.input.layer.borderWidth = 1.f;
    self.input.delegate = self;

    UIBarButtonItem *inputItem = [[UIBarButtonItem alloc] initWithCustomView:self.input];

    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    [toolbar setItems:@[flexible, inputItem, done] animated:NO];
}

- (void)didTapSendButton:(id)sender {
    Message *message = [Message object];
    message.message = self.input.text;
    message.date = [NSDate date];
    [message saveInBackground];

    [self.input resignFirstResponder];
    if (self.sentMessageCompletionBlock) {
        self.sentMessageCompletionBlock(message);
    }

    self.input.text = @"";
    [self textView:self.input shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@""];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];

    CGRect boundingRect = [newString boundingRectWithSize:CGSizeMake(textView.width, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:textView.typingAttributes
                                                  context:nil];
    CGFloat newHeight = ceil(boundingRect.size.height) + 16;

    CGFloat diff = newHeight - textView.height;
    textView.height = newHeight;
    self.height += diff;
    self.y -= diff;

    return YES;
}
@end
