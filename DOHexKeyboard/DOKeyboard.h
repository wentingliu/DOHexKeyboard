//
//  DOHexKeyboard.h
//
//  Created by durian on 9/3/13.
//  Copyright (c) 2013 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class DOKeyboard;

typedef enum {
    DOKeyboardTypeHex,
    DOKeyboardTypeNumericNormal
} DOKeyboardType;

typedef enum {
    DOKeyboardKeyTypeCustomized,
    DOKeyboardKeyTypeAdd,
    DOKeyboardKeytypeDelete,
    DOKeyboardKeyTypeClear,
    DOKeyboardKeyTypeReturn
} DOKeyboardKeyType;

// The action block when key is tapped.
typedef void(^DOKeyboardKeyTapAction) (DOKeyboard *keyboard, UIButton *key);
// Here are some default implementations about text adding, deleting, and clearing, returning.
extern DOKeyboardKeyTapAction const DOKeyboardKeyTapAdd; // Add key's title to inputview's text.
extern DOKeyboardKeyTapAction const DOKeyboardKeyTapDelete; // Delete one charactor of inputview'text.
extern DOKeyboardKeyTapAction const DOKeyboardKeyTapClear; // Clear all content of inputview.
extern DOKeyboardKeyTapAction const DOKeyboardKeyTapReturn; // Return

typedef struct {
    NSUInteger row;
    NSUInteger column;
} DOKKeyOrigin;

typedef struct {
    NSUInteger row;
    NSUInteger column;
} DOKKeySpan;

// DOKKeyFrame is a rect in coordinate of keys.
// Suppose a keyboard with 4 rows and 5 columns, and there are 20 keys, so keyboard's size is {4, 5},
// the first key's DOKKeyFrame is {0, 0, 1, 1}, the last key's is {3, 4, 1, 1}.
// If there is a key that spans two column then span of it is {1, 2}.
typedef struct {
    DOKKeyOrigin origin;
    DOKKeySpan span;
} DOKKeyFrame;

typedef UIButton * (^DOKeyboardKeyBlock)(DOKeyboard *keyboard, NSUInteger index);
typedef DOKKeyFrame (^DOKeyboardKeyFrameBlock)(DOKeyboard *keyboard, NSUInteger index);
typedef void (^DOKeyboardLayoutBlock) (DOKeyboard *keyboard, NSArray *keys);
extern DOKeyboardLayoutBlock const DOKeyboardLayoutDefault;

typedef DOKeyboardKeyTapAction (^DOKeyboardKeyTappedBlock) (DOKeyboard *keyboard, UIButton *button);


@protocol DOKConfiguring <NSObject>

@property (nonatomic) CGSize keyboardSize;
@property (nonatomic) CGFloat keySpacing;
@property (nonatomic) NSUInteger keyCount;
@property (nonatomic) NSUInteger columnCount;
@property (nonatomic) NSUInteger rowCount;
@property (nonatomic, readonly) DOKeyboardKeyBlock keyAtIndex;
@property (nonatomic, readonly) DOKeyboardKeyFrameBlock frameOfKeyAtIndex;
@property (nonatomic, readonly) DOKeyboardKeyTappedBlock keyTapped;
@property (nonatomic, readonly) DOKeyboardLayoutBlock layout;

@end


@interface DOKeyboard : UIView {
    id<DOKConfiguring> _configuration;
    
    NSArray *_keys;
}

@property (nonatomic, strong) id<UITextInput> input;
@property (nonatomic, readonly) id<DOKConfiguring> configuration;

- (instancetype)initWithconfiguration:(id<DOKConfiguring>)configuration;

+ (DOKeyboard *)keyboardWithType:(DOKeyboardType)type;

- (NSUInteger)indexOfKey:(UIButton *)key;

- (void)textInput:(id <UITextInput>)textInput replaceTextAtTextRange:(UITextRange *)textRange withString:(NSString *)string;

@end
