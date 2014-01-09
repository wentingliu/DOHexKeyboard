//
//  DOKConfigurationGeneral.m
//  Sample
//
//  Created by olive on 1/8/14.
//  Copyright (c) 2014 durian. All rights reserved.
//

#import "DOKeyboardHelpers.h"

CGSize const DOKeyboardNormalSize = (CGSize){320, 216};
CGSize const DOKKeyNormalSize = (CGSize){63, 53};
CGFloat const DOKKeyNormalSpace = 1;

UIImage *createImageWithColor(UIColor *color) {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
};

UIButton *createKey(UIImage *background,
                    UIImage *highlightedBackground,
                    CGSize size,
                    UIImage *keyImage,
                    NSString *text,
                    UIColor *textColor,
                    UIFont *font) {
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
    
    if (keyImage) {
        [key setImage:keyImage forState:UIControlStateNormal];
    }
    if (text) {
        [key setTitle:text forState:UIControlStateNormal];
    }
    if (textColor) {
        [key setTitleColor:textColor forState:UIControlStateNormal];
    }
    if (font) {
        key.titleLabel.font = font;
    }
    
    return key;
};

static UIImage *background;
static UIImage *highlightedBackground;
static UIFont *fontForNumberNormal;
static UIFont *fontForNumberHex;
static UIFont *fontForText;
static UIColor *textColor;

void initializeKeyConfiguration() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (background == nil) {
            background = createImageWithColor([UIColor whiteColor]);
            highlightedBackground = createImageWithColor([UIColor colorWithWhite:0.80 alpha:1]);
        }
        
        if (fontForNumberNormal == nil) {
            fontForNumberNormal = [UIFont fontWithName:@"HelveticaNeue-Light" size:29.5];
            fontForNumberHex = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
            fontForText = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        }
        
        
        if (textColor == nil) {
            textColor = [UIColor colorWithWhite:0.1 alpha:1];
        }
    });
}

UIButton *createKeyWithHex(NSString *hexCharactor) {
    initializeKeyConfiguration();
    UIButton *key = createKey(background, highlightedBackground, CGSizeZero, nil, hexCharactor, textColor, fontForNumberHex);
    [key sizeToFit];
    return key;
}

UIButton *createKeyWithNormal(NSString *normalCharactor) {
    initializeKeyConfiguration();
    UIButton *key = createKey(background, highlightedBackground, CGSizeZero, nil, normalCharactor, textColor, fontForNumberNormal);
    [key sizeToFit];
    return key;
}

UIButton *createKeyWithText(NSString *longText) {
    initializeKeyConfiguration();
    UIButton *key = createKey(background, highlightedBackground, CGSizeZero, nil, longText, textColor, fontForText);
    [key sizeToFit];
    return key;
}

UIButton *createKeyWithImage(UIImage *image) {
    initializeKeyConfiguration();
    UIButton *key = createKey(background, highlightedBackground, CGSizeZero, image, nil, nil, nil);
    [key sizeToFit];
    return key;
}


