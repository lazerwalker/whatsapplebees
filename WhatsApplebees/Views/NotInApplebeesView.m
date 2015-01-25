//
//  NotInApplebeesView.m
//  WhatsApplebees
//
//  Created by Michael Walker on 4/1/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "NotInApplebeesView.h"
#import "NSObject+ClassName.h"

#import <CoreText/CTStringAttributes.h>

@interface NotInApplebeesView ()

@property (weak, nonatomic) IBOutlet UIButton *toggleButton;
@property (weak, nonatomic) IBOutlet UILabel *notInApplebeesLabel;
@property (weak, nonatomic) IBOutlet UIButton *findButton;

@end

@implementation NotInApplebeesView

- (id)init {
    NSArray *nibs = [NSBundle.mainBundle loadNibNamed:self.class.className owner:self options:nil];
    return nibs[0];
}

- (void)awakeFromNib {
#ifdef DEBUG
    self.toggleButton.hidden = NO;
#endif

    self.notInApplebeesLabel.attributedText = ({
        NSString *string = @"You're Not At Applebee's®!";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];

        [attrString addAttributes:@{
                                    (id)kCTSuperscriptAttributeName: @"1",
                                    NSFontAttributeName:[UIFont fontWithName:self.notInApplebeesLabel.font.familyName size:14.0],
                                    NSBaselineOffsetAttributeName: @"11"
                                    
                                    }
                            range:NSMakeRange(24, 1)];
        attrString;
    });

    NSAttributedString *buttonString = ({
        NSString *string = @"Find Nearest Applebee's®";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];

        [attrString addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:NSMakeRange(0, attrString.length)];

        [attrString addAttributes:@{
                                    (id)kCTSuperscriptAttributeName: @"1",
                                    NSFontAttributeName:[UIFont fontWithName:self.notInApplebeesLabel.font.familyName size:12.0],
                                    NSBaselineOffsetAttributeName: @"2"

                                    }
                            range:NSMakeRange(23, 1)];
        attrString;
    });
    [self.findButton setAttributedTitle:buttonString forState:UIControlStateNormal];

}

- (IBAction)didTapToggleButton:(id)sender {
    if (self.toggleBlock) {
        self.toggleBlock();
    }
}

- (IBAction)didTapLocateButton:(id)sender {
    if (self.locateBlock) {
        self.locateBlock();
    }
}
@end
