//
//  DOKConfigurationNumericNormal.m
//  Sample
//
//  Created by olive on 1/8/14.
//  Copyright (c) 2014 durian. All rights reserved.
//

#import "DOKConfigurationNumericNormal.h"
#import "DOKeyboardHelpers.h"

@implementation DOKConfigurationNumericNormal

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _keyCount = 16;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGSize keyboardSize = (CGSize){screenWidth, 216};
        _keyboardSize = keyboardSize;
        _keySpacing = 1;
        
        _columnCount = 4;
        _rowCount = 4;
        
        
        NSMutableArray *keys = [NSMutableArray array];
        NSMutableArray *keyFrames = [NSMutableArray array];
        // create and layout the top three rows
        NSArray *keyNames = @[@"7", @"8", @"9", @"-/+",
                              @"4", @"5", @"6", @"clear",
                              @"1", @"2", @"3", @"*",
                              @".", @"0", @" ", @"return"];
        NSUInteger DOKeyboardKeyTypePositiveOrNegative = 201;
        for (int row = 0; row < 4; row++) {
            for (int column = 0; column < 4; column++) {
                NSString *keyName = keyNames[row * 4 + column];
                UIButton *key;
                if ([keyName isEqualToString:@"-/+"]) {
                    key = createKeyWithText(@"-/+");
                    key.tag = DOKeyboardKeyTypePositiveOrNegative;
                } else if ([keyName isEqualToString:@"clear"]) {
                    key = createKeyWithText(@"clear");
                    key.tag = DOKeyboardKeyTypeClear;
                } else if ([keyName isEqualToString:@"*"]) {
                    key = createKeyWithImage([UIImage imageNamed:@"delete.png"]);
                    key.tag = DOKeyboardKeytypeDelete;
                } else if ([keyName isEqualToString:@"return"]) {
                    key = createKeyWithText(@"return");
                    key.tag = DOKeyboardKeyTypeReturn;
                } else {
                    key = createKeyWithNormal(keyName);
                    key.tag = DOKeyboardKeyTypeAdd;
                }
                [keys addObject:key];
                DOKKeyFrame frame;
                frame.origin = (DOKKeyOrigin){row, column};
                frame.span = (DOKKeySpan){1, 1};
                [keyFrames addObject:[NSValue value:&frame withObjCType:@encode(DOKKeyFrame)]];
            }
        }
        
        _keyAtIndex = ^(DOKeyboard *keyboard, NSUInteger index) {
            return keys[index];
        };
        _frameOfKeyAtIndex = ^(DOKeyboard *keyboard, NSUInteger index) {
            NSValue *value = keyFrames[index];
            DOKKeyFrame frame;
            [value getValue:&frame];
            return frame;
        };
        
        _layout = DOKeyboardLayoutDefault;
        
        _keyTapped = ^(DOKeyboard *keyboard, UIButton *key) {
            NSUInteger tag = key.tag;
            if (tag == DOKeyboardKeyTypeClear) {
                return DOKeyboardKeyTapClear;
            } else if (tag == DOKeyboardKeytypeDelete) {
                return DOKeyboardKeyTapDelete;
            } else if (tag == DOKeyboardKeyTypeReturn) {
                return DOKeyboardKeyTapReturn;
            } else if (tag == DOKeyboardKeyTypePositiveOrNegative){
                DOKeyboardKeyTapAction action = ^(DOKeyboard *keyboard, UIButton *key) {
                    id<UITextInput> input = keyboard.input;
                    
                    UITextRange *selectedTextRange = input.selectedTextRange;
                    // Calculate the selected text to delete
                    UITextPosition  *startPosition = [input positionFromPosition:selectedTextRange.start offset:-1];
                    if (!startPosition) {
                        [keyboard textInput:input replaceTextAtTextRange:input.selectedTextRange withString:@"-"];
                        return;
                    }
                    UITextPosition *endPosition = selectedTextRange.end;
                    if (!endPosition) {
                        return;
                    }
                    UITextRange *lastCharactorRange = [input textRangeFromPosition:startPosition toPosition:endPosition];
                    NSString *lastCharactor = [input textInRange:lastCharactorRange];
                    if ([lastCharactor isEqualToString:@"-"]) {
                        [keyboard textInput:keyboard.input replaceTextAtTextRange:lastCharactorRange withString:@""];
                    } else {
                        [keyboard textInput:input replaceTextAtTextRange:input.selectedTextRange withString:@"-"];
                    }
                };
                return action;
            } else {
                return DOKeyboardKeyTapAdd;
            }
        };
    }
    
    return self;
}

@end
