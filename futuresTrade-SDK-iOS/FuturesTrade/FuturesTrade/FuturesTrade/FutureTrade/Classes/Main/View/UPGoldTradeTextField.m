//
//  UPTextField.m
//  TestUPGoldTradeSDK
//
//  Created by LiuLian on 16/12/28.
//  Copyright © 2016年 ShenzhenYoupinFinancialService. All rights reserved.
//

#import "UPGoldTradeTextField.h"

@interface UPGoldTradeTextField () {
    BOOL isCursorShowing;
}

@property (nonatomic, strong) UILabel *cursorLabel;

@end

@implementation UPGoldTradeTextField

static NSString * const UPGoldTradeTextFieldCursor = @"∣";

- (void)dealloc {
    [self hideCursor];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
}

- (void)initCursorLabel {
    if (!_cursorLabel) {
        _cursorLabel = [[UILabel alloc] init];
        _cursorLabel.backgroundColor = [UIColor clearColor];
        _cursorLabel.textColor = [UIColor blueColor];
        UIFontDescriptor *fontDesc = self.font.fontDescriptor;
        NSNumber *fontSize = [fontDesc objectForKey:@"NSFontSizeAttribute"];
        _cursorLabel.font = [UIFont boldSystemFontOfSize:fontSize.floatValue + 2];
    }
}

- (void)showCursor {
    [self resetCursorShowingStatus];
    [self showCursorPeriodicity];
}

- (void)showCursorPeriodicity {
    [self cancelShowingCursor];
    [self initCursorLabel];
    if (!_cursorLabel.superview) {
        [self addSubview:_cursorLabel];
    }
    if (isCursorShowing) {
        _cursorLabel.text = @"";
        _cursorLabel.frame = CGRectZero;
    } else {
        NSTextAlignment alignment = self.textAlignment;
        _cursorLabel.text = UPGoldTradeTextFieldCursor;
        CGFloat cursorWidth = [self cursorWidth];
        UILabel *displayLabel = [self valueForKeyPath:@"displayLabel"];
        NSString *displayString = displayLabel.text;
        CGFloat displayWidth = [self widthWithContent:displayString font:displayLabel.font];
        CGRect cursorFrame = CGRectMake(displayLabel.frame.origin.x + displayWidth, displayLabel.frame.origin.y, cursorWidth, self.frame.size.height);
        if (NSTextAlignmentCenter == alignment) {
            cursorFrame = CGRectMake(self.frame.size.width/2 + displayWidth/2 - 1.0, displayLabel.frame.origin.y, cursorWidth, self.frame.size.height);
        } else if (NSTextAlignmentRight == alignment) {
            cursorFrame = CGRectMake(self.frame.size.width - cursorWidth, displayLabel.frame.origin.y, cursorWidth, self.frame.size.height);
        }
        if (!displayLabel.superview) {
            UILabel *placeholderLabel = [self valueForKeyPath:@"placeholderLabel"];
            if (placeholderLabel && placeholderLabel.superview) {
                CGFloat placeholderWidth = [self widthWithContent:placeholderLabel.text font:placeholderLabel.font];
                cursorFrame = CGRectMake(placeholderLabel.frame.origin.x - cursorWidth > 0 ?: 0, placeholderLabel.frame.origin.y, cursorWidth, self.frame.size.height);
                if (NSTextAlignmentCenter == alignment) {
                    cursorFrame = CGRectMake(self.frame.size.width/2 - placeholderWidth/2 - 1.0, displayLabel.frame.origin.y, cursorWidth, self.frame.size.height);
                } else if (NSTextAlignmentRight == alignment) {
                    cursorFrame = CGRectMake(self.frame.size.width/2 + placeholderWidth/2, displayLabel.frame.origin.y, cursorWidth, self.frame.size.height);
                }
            } else {
                cursorFrame = CGRectMake(5, cursorFrame.origin.y, cursorWidth, self.frame.size.height);
                if (NSTextAlignmentCenter == alignment) {
                    cursorFrame = CGRectMake(self.frame.size.width/2 - 1.0, displayLabel.frame.origin.y, cursorWidth, self.frame.size.height);
                } else if (NSTextAlignmentRight == alignment) {
                    cursorFrame = CGRectMake(self.frame.size.width/2, displayLabel.frame.origin.y, cursorWidth, self.frame.size.height);
                }
            }
        }
        if (cursorFrame.origin.y < 0) {
            cursorFrame.origin.y = 0;
        }
        _cursorLabel.frame = cursorFrame;
    }
    isCursorShowing = !isCursorShowing;
    [self performSelector:@selector(showCursorPeriodicity) withObject:nil afterDelay:0.5];
}

- (CGFloat)cursorWidth {
    return [self widthWithContent:UPGoldTradeTextFieldCursor font:_cursorLabel.font];
}

- (CGFloat)widthWithContent:(NSString *)content font:(UIFont *)font {
    if (content && font) {
        CGRect rect = [content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
        return rect.size.width;
    }
    return 0;
}

- (void)hideCursor {
    [self cancelShowingCursor];
    if (_cursorLabel) {
        if (_cursorLabel.superview) {
            [_cursorLabel removeFromSuperview];
        }
        _cursorLabel = nil;
    }
}

- (void)cancelShowingCursor {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(showCursorPeriodicity) object:nil];
}

- (void)resetCursorShowingStatus {
    isCursorShowing = YES;
}

@end
