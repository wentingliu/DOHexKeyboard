//
//  DOHexKeyboard.h
//
//  Created by durian on 9/3/13.
//  Copyright (c) 2013 durian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DOHexKeyboard : UIView {
}

@property (nonatomic, strong) UIButton *clearKey;
@property (nonatomic, strong) UIButton *deleteKey;
@property (nonatomic, strong) UIButton *returnKey;

@property (nonatomic, strong) id<UITextInput> input;

@end
