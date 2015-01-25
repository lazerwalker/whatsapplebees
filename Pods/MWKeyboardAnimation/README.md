MWKeyboardAnimation
===================
A category on UIView that adds a single class method to animate a block with the same timing and animation curve as UIKeyboard given a keyboard will show/hide notification.


Installation
------------
Via [CocoaPods](http://cocoapods.org):

    pod "MWKeyboardAnimation"

If you're not using CocoaPods, you should be able to just drag the two files in the `Classes` folder into your project.


Usage
-----
```objective-c
#import <UIView+MWKeyboardAnimation.h>

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView animateWithKeyboardNotification:notification animations:^(CGRect keyboardFrame) {
        someView.frameHeight -= CGRectGetHeight(keyboardFrame);
    }];
}
```

Contact
-------
Mike Walker

* https://github.com/lazerwalker
* [@lazerwalker](https://twitter.com/lazerwalker)
* mike@lazerwalker.com


License
-------
[MIT License](https://github.com/lazerwalker/MWKeyboardAnimation/blob/master/LICENSE).