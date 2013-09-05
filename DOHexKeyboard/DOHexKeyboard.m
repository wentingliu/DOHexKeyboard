//
//  DOHexKeyboard.m
//
//  Created by durian on 9/3/13.
//  Copyright (c) 2013 durian. All rights reserved.
//

#import "DOHexKeyboard.h"

static CGSize const kKeyboardSize = {320, 216};
static CGSize const kKeySize = {63, 53};
static CGFloat const kKeySpace = 1;

@implementation DOHexKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    // set frame
    self.frame = (CGRect){CGPointZero, kKeyboardSize};
    
    self.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1];
    
    UIImage *(^createImage)(UIColor *color) = ^(UIColor *color) {
        CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    };
    
    // define button creation block
    UIButton *(^createKey)(UIImage *background, UIImage *highlightedBackground, CGSize size, NSString *text, UIFont *font, UIImage *image) = ^(UIImage *background, UIImage *highlightedBackground, CGSize size, NSString *text, UIFont *font, UIImage *image) {
        UIButton *key = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = {CGPointZero, size};
        key.frame = frame;
        
        if (background) {
            [key setBackgroundImage:background forState:UIControlStateNormal];
        }
        if (highlightedBackground) {
            [key setBackgroundImage:highlightedBackground forState:UIControlStateHighlighted];
        }

        [key.layer setCornerRadius:1];
        
//        key.layer.shadowOffset = CGSizeMake(0, 1);
//        static UIColor *shadowColor;
//        if (shadowColor == nil) {
//            shadowColor = [UIColor colorWithWhite:0.15 alpha:1];
//        }
//        key.layer.masksToBounds = YES;
//        key.layer.shadowRadius = 0.5;
//        key.layer.shadowOpacity = 1;
//        key.layer.shadowColor = [shadowColor CGColor];
        
        if (image) {
            [key setImage:image forState:UIControlStateNormal];
        }
        
        static UIColor *textColor;
        static UIColor *highlightTextColor;
        if (textColor == nil) {
            textColor = [UIColor colorWithWhite:0.1 alpha:1];
            highlightTextColor = [UIColor colorWithRed:0 green:155 blue:239 alpha:1];
        }
        
        if (text) {
            [key setTitle:text forState:UIControlStateNormal];
            [key setTitleColor:textColor forState:UIControlStateNormal];
//            [key setTitleColor:highlightTextColor forState:UIControlStateHighlighted];
            key.titleLabel.font = font;
        }
        
        return key;
    };
    
    static UIImage *background;
    static UIImage *highlightedBackground;
    if (background == nil) {
        background = createImage([UIColor whiteColor]);
        highlightedBackground = createImage([UIColor colorWithWhite:0.80 alpha:1]);
    }
    
    static UIFont *fontForNumberNormal;
    static UIFont *fontForNumberHex;
    static UIFont *fontForText;
    if (fontForNumberNormal == nil) {
        fontForNumberNormal = [UIFont fontWithName:@"HelveticaNeue-Light" size:29.5];
        fontForNumberHex = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
        fontForText = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    }

    // create and layout the top three rows
    NSArray *keyNames = @[@"7", @"8", @"9", @"A", @"B",
                          @"4", @"5", @"6", @"C", @"D",
                          @"1", @"2", @"3", @"E", @"F"];
    for (int row = 0; row < 3; row++) {
        CGPoint origin = CGPointMake(0, row * (kKeySpace + kKeySize.height));
        for (int column = 0; column < 5; column++) {
            NSString *keyName = keyNames[row * 5 + column];
            UIFont *font = [keyName compare:@"9"] == NSOrderedDescending ? fontForNumberHex : fontForNumberNormal;
            CGSize size = kKeySize;
            // increase last column key size with kKeySpace
            if (column == 5) {
                size.width += kKeySpace;
            }
            UIButton *key = createKey(background, highlightedBackground, size, keyName, font, nil);
            [key addTarget:self action:@selector(numberKeyClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:key];
            key.frame = (CGRect){origin, key.frame.size};
            
            origin.x += kKeySize.width + kKeySpace;
        }
    }
    
    // create "clear", "0", "delete" and "return" keys
    _clearKey = createKey(background, highlightedBackground, kKeySize, @"clear", fontForText, nil);
    UIButton *zeroKey = createKey(background, highlightedBackground, kKeySize, @"0", fontForNumberNormal, nil);
    _deleteKey = createKey(background, highlightedBackground, kKeySize, nil, nil, [UIImage imageNamed:@"delete.png"]);
    CGSize returnKeySize = {kKeySize.width * 2 + kKeySpace, kKeySize.height};
    _returnKey = createKey(background, highlightedBackground, returnKeySize, @"return", fontForText, nil);
    
    [_clearKey addTarget:self action:@selector(clearKeyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [zeroKey addTarget:self action:@selector(numberKeyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteKey addTarget:self action:@selector(deleteKeyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_returnKey addTarget:self action:@selector(returnKeyClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // layout last row
    NSArray *lastRowKeys = @[_clearKey, zeroKey, _deleteKey, _returnKey];
    NSUInteger keyCount = [lastRowKeys count];
    CGPoint origin = {0, 3 * (kKeySpace + kKeySize.height)};
    for (int i = 0; i < keyCount; i++) {
        UIButton *key = lastRowKeys[i];
        CGSize size = key.frame.size;
        size.height += kKeySpace;
        if (i == (keyCount - 1)) {
            size.width += kKeySpace;
        }
        key.frame = (CGRect){origin, size};
        [self addSubview:key];
        
        origin.x += key.frame.size.width + kKeySpace;
    }
}

- (void)setInput:(id<UITextInput>)input {
    _input = input;
    [_input performSelector:@selector(setInputView:) withObject:self];
}

- (void)numberKeyClicked:(UIButton *)key {
    [self textInput:_input replaceTextAtTextRange:_input.selectedTextRange withString:key.currentTitle];
}

- (void)clearKeyClicked:(UIButton *)clearKey {
    UITextRange *allTextRange = [_input textRangeFromPosition:_input.beginningOfDocument
                                                   toPosition:_input.endOfDocument];
    
    [self textInput:_input replaceTextAtTextRange:allTextRange withString:@""];
}

- (void)deleteKeyClicked:(UIButton *)deleteKey {
    UITextRange *selectedTextRange = _input.selectedTextRange;
    // Calculate the selected text to delete
    UITextPosition  *startPosition = [_input positionFromPosition:selectedTextRange.start offset:-1];
    if (!startPosition) {
        return;
    }
    UITextPosition *endPosition = selectedTextRange.end;
    if (!endPosition) {
        return;
    }
    UITextRange *rangeToDelete = [_input textRangeFromPosition:startPosition toPosition:endPosition];
    [self textInput:_input replaceTextAtTextRange:rangeToDelete withString:@""];
}

- (void)returnKeyClicked:(UIButton *)returnKey {
    if ([_input isKindOfClass:[UITextField class]]) {
        id<UITextFieldDelegate> delegate = [(UITextField *)_input delegate];
        if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
            [delegate textFieldShouldReturn:(UITextField *)_input];
        }
    } else if ([_input isKindOfClass:[UITextView class]]) {
        [self textInput:_input replaceTextAtTextRange:_input.selectedTextRange withString:@"\n"];
    }
}

// Check delegate methods to see if we should change the characters in range
- (BOOL)textInput:(id <UITextInput>)textInput shouldChangeCharactersInRange:(NSRange)range withString:(NSString *)string
{
    if ([textInput isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)textInput;
        if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            if (![textField.delegate textField:textField
                 shouldChangeCharactersInRange:range
                             replacementString:string]) {
                return NO;
            }
        }
    } else if ([textInput isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)textInput;
        if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            if (![textView.delegate textView:textView
                     shouldChangeTextInRange:range
                             replacementText:string]) {
                return NO;
            }
        }
    }
    return YES;
}

// Replace the text of the textInput in textRange with string if the delegate approves
- (void)textInput:(id <UITextInput>)textInput replaceTextAtTextRange:(UITextRange *)textRange withString:(NSString *)string {
    // Calculate the NSRange for the textInput text in the UITextRange textRange:
    int startPos = [textInput offsetFromPosition:textInput.beginningOfDocument
                                                         toPosition:textRange.start];
    int length = [textInput offsetFromPosition:textRange.start
                                                         toPosition:textRange.end];
    NSRange selectedRange = NSMakeRange(startPos, length);
    
    if ([self textInput:textInput shouldChangeCharactersInRange:selectedRange withString:string]) {
        // Make the replacement:
        [textInput replaceRange:textRange withText:string];
    }
}

@end
