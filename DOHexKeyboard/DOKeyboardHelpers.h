//
//  DOKConfigurationGeneral.h
//  Sample
//
//  Created by olive on 1/8/14.
//  Copyright (c) 2014 durian. All rights reserved.
//

#import "DOKeyboard.h"

extern CGSize const DOKKeyNormalSize; // (63, 53)
extern CGFloat const DOKKeyNormalSpace; // 1

// Some helper fucntions
extern UIImage *createImageWithColor(UIColor *color);
extern UIButton *createKey(UIImage *background,
                           UIImage *highlightedBackground,
                           CGSize size,
                           UIImage *keyImage,
                           NSString *text,
                           UIColor *textColor,
                           UIFont *font);

extern UIButton *createKeyWithHex(NSString *hexCharactor);
extern UIButton *createKeyWithNormal(NSString *normalCharactor);
extern UIButton *createKeyWithText(NSString *longText);
extern UIButton *createKeyWithImage(UIImage *image);


