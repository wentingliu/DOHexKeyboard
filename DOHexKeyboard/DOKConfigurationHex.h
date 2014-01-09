//
//  DOKeyboardHex.h
//  Sample
//
//  Created by olive on 1/7/14.
//  Copyright (c) 2014 durian. All rights reserved.
//

#import "DOKeyboard.h"

@interface DOKConfigurationHex : NSObject <DOKConfiguring> {
}

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
