//
//  DOHexKeyboard.m
//
//  Created by durian on 9/3/13.
//  Copyright (c) 2013 durian. All rights reserved.
//

#import "DOKeyboard.h"
#import "DOKConfigurationHex.h"
#import "DOKConfigurationNumericNormal.h"

DOKeyboardKeyTapAction const DOKeyboardKeyTapAdd = ^(DOKeyboard *keyboard, UIButton *key) {
    id<UITextInput> input = keyboard.input;
    [keyboard textInput:input replaceTextAtTextRange:input.selectedTextRange withString:key.currentTitle];
};

DOKeyboardKeyTapAction const DOKeyboardKeyTapDelete = ^(DOKeyboard *keyboard, UIButton *key) {
    id<UITextInput> input = keyboard.input;
    
    UITextRange *selectedTextRange = input.selectedTextRange;
    // Calculate the selected text to delete
    UITextPosition  *startPosition = [input positionFromPosition:selectedTextRange.start offset:-1];
    if (!startPosition) {
        return;
    }
    UITextPosition *endPosition = selectedTextRange.end;
    if (!endPosition) {
        return;
    }
    UITextRange *rangeToDelete = [input textRangeFromPosition:startPosition toPosition:endPosition];
    [keyboard textInput:input replaceTextAtTextRange:rangeToDelete withString:@""];
};

DOKeyboardKeyTapAction const DOKeyboardKeyTapClear = ^(DOKeyboard *keyboard, UIButton *key) {
    id<UITextInput> input = keyboard.input;
    UITextRange *allTextRange = [input textRangeFromPosition:input.beginningOfDocument
                                                   toPosition:input.endOfDocument];
    [keyboard textInput:input replaceTextAtTextRange:allTextRange withString:@""];
};

DOKeyboardKeyTapAction const DOKeyboardKeyTapReturn = ^(DOKeyboard *keyboard, UIButton *key) {
    id<UITextInput> input = keyboard.input;
    
    if ([input isKindOfClass:[UITextField class]]) {
        id<UITextFieldDelegate> delegate = [(UITextField *)input delegate];
        if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
            [delegate textFieldShouldReturn:(UITextField *)input];
        }
    } else if ([input isKindOfClass:[UITextView class]]) {
        [keyboard textInput:input replaceTextAtTextRange:input.selectedTextRange withString:@"\n"];
    }
};

DOKeyboardLayoutBlock const DOKeyboardLayoutDefault = ^(DOKeyboard *keyboard, NSArray *keys) {
    id <DOKConfiguring> config = keyboard.configuration;
    CGSize keyboardSize = config.keyboardSize;
    keyboard.frame = CGRectMake(0, 0, keyboardSize.width, keyboardSize.height);
    
    CGFloat spacing = config.keySpacing;
    CGFloat keyWidth = (config.keyboardSize.width - (config.columnCount - 1) * config.keySpacing) / config.columnCount;
    CGFloat keyHeight = (config.keyboardSize.height - (config.rowCount - 1) * config.keySpacing) / config.rowCount;
    keyWidth = floor(keyWidth);
    keyHeight = floor(keyHeight);
    NSUInteger keyCount = config.keyCount;
    for (int i = 0; i < keyCount; i++) {
        UIButton *key = config.keyAtIndex(keyboard, i);
        DOKKeyFrame frame = config.frameOfKeyAtIndex(keyboard, i);
        DOKKeyOrigin origin = frame.origin;
        DOKKeySpan span = frame.span;
        
        CGPoint originInPoint = CGPointMake(spacing + frame.origin.column * (keyWidth + spacing),
                                     spacing + frame.origin.row * (keyHeight + spacing));
        BOOL isLastKeyAtRow = (origin.row + span.row) == (config.rowCount);
        BOOL isLastKeyAtColumn = (origin.column + span.column) == (config.columnCount);
        CGFloat widthInPoint = isLastKeyAtColumn ? (keyboardSize.width - originInPoint.x) : keyWidth;
        CGFloat heightInPoint = isLastKeyAtRow ? (keyboardSize.height - originInPoint.y) : keyHeight;
        CGRect frameInPoint = CGRectMake(originInPoint.x, originInPoint.y, widthInPoint, heightInPoint);

        key.frame = frameInPoint;
    }
};

@implementation DOKeyboard

- (instancetype)initWithconfiguration:(id<DOKConfiguring>)configuration {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _configuration = configuration;
        NSMutableArray *keys = [NSMutableArray array];
        for (int i = 0; i < _configuration.keyCount; i++) {
            UIButton *key = _configuration.keyAtIndex(self, i);
            [keys addObject:key];
        }
        _keys = [NSArray arrayWithArray:keys];
        [keys enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
            [self addSubview:obj];
            [obj addTarget:self action:@selector(keyTapped:) forControlEvents:UIControlEventTouchUpInside];
        }];
        configuration.layout(self, keys);
    }
    
    return self;
}

+ (DOKeyboard *)keyboardWithType:(DOKeyboardType)type {
    DOKeyboard *keyboard;
    
    if (type == DOKeyboardTypeHex) {
        DOKConfigurationHex *configuration = [[DOKConfigurationHex alloc] init];
        keyboard = [[DOKeyboard alloc] initWithconfiguration:configuration];
    } else if (type == DOKeyboardTypeNumericNormal) {
        DOKConfigurationNumericNormal *configuration = [[DOKConfigurationNumericNormal alloc] init];
        keyboard = [[DOKeyboard alloc] initWithconfiguration:configuration];
    } else {
        [NSException raise:@"Failure to new keyboard" format:@"Could not create keyboard with type:%d", type];
    }
    
    return keyboard;
}

- (void)setInput:(id<UITextInput>)input {
    _input = input;
    [_input performSelector:@selector(setInputView:) withObject:self];
}

- (NSUInteger)indexOfKey:(UIButton *)key {
    return [_keys indexOfObject:key];
}

- (void)keyTapped:(UIButton *)key {
    DOKeyboardKeyTapAction action = _configuration.keyTapped(self, key);
    action(self, key);
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
    NSInteger startPos = [textInput offsetFromPosition:textInput.beginningOfDocument
                                                         toPosition:textRange.start];
    NSInteger length = [textInput offsetFromPosition:textRange.start
                                                         toPosition:textRange.end];
    NSRange selectedRange = NSMakeRange(startPos, length);
    
    if ([self textInput:textInput shouldChangeCharactersInRange:selectedRange withString:string]) {
        // Make the replacement:
        [textInput replaceRange:textRange withText:string];
    }
}

@end
