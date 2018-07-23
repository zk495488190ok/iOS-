//
//  KDSectorButton.m
//  koudaizikao
//
//  Created by lsq on 15/12/1.
//  Copyright © 2015年 withustudy. All rights reserved.
//

#import "DivoomTransparencyButton.h"
#import "UIImage+ColorAtPoint.h"
#import "YJFavorEmitterCell.h"

#define kAlphaVisibleThreshold (0.1f)

@interface DivoomTransparencyButton ()

@property (nonatomic, assign) CGPoint previousTouchPoint;
@property (nonatomic, assign) BOOL                      previousTouchHitTestResponse;
@property (nonatomic, strong) UIImage                   *fitImage;
@end

@implementation DivoomTransparencyButton{
    YJFavorEmitterCell *emiter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFitImage:(UIImage *)fitImage
{
    self = [super init];
    if (self) {
        _fitImage = fitImage;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame fitImage:(UIImage *)fitImage
{
    self = [super initWithFrame:frame];
    if (self) {
        _fitImage = fitImage;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)setFiltImage:(UIImage *)image{
    _fitImage = image;
}

- (void)setup {
    [self resetHitTestCache];
    [self layoutIfNeeded];
}

#pragma mark - 判断图片在此点区域是否是透明的

- (BOOL)isAlphaVisibleAtPoint:(CGPoint)point forImage:(UIImage *)image {
    
    CGSize iSize = image.size;
    CGSize bSize = self.bounds.size;
    point.x *= (bSize.width != 0) ? (iSize.width / bSize.width) : 1;
    point.y *= (bSize.height != 0) ? (iSize.height / bSize.height) : 1;
    
    UIColor *pixelColor = [image colorAtPoint2:point];
    
    CGFloat alpha = 0.0;
    
    if ([pixelColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        
        [pixelColor getRed:NULL green:NULL blue:NULL alpha:&alpha];
    } else {
        CGColorRef cgPixelColor = [pixelColor CGColor];
        alpha = CGColorGetAlpha(cgPixelColor);
    }
    return alpha >= kAlphaVisibleThreshold;
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    BOOL superResult = [super pointInside:point withEvent:event];
    if (!superResult) {
        return superResult;
    }
    
    if (CGPointEqualToPoint(point, self.previousTouchPoint)) {
        return self.previousTouchHitTestResponse;
    } else {
        self.previousTouchPoint = point;
    }
    
    BOOL response = NO;
    if (self.currentImage == nil && self.fitImage == nil) {

        response = YES;

    } else if (self.currentImage != nil && self.fitImage == nil) {

        response = [self isAlphaVisibleAtPoint:point forImage:self.currentImage];

    } else if (self.currentImage == nil && self.fitImage != nil) {

        response = [self isAlphaVisibleAtPoint:point forImage:self.fitImage];

    } else {

        if ([self isAlphaVisibleAtPoint:point forImage:self.currentImage]) {
            response = YES;
        } else {
            response = [self isAlphaVisibleAtPoint:point forImage:self.fitImage];
        }
    }
    self.previousTouchHitTestResponse = response;
    if (response && _isShowAnimation) {
        //粒子效果
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startEmitter:point];
        });
    }
    return response;
}

#pragma mark - Helper methods

- (void)startEmitter:(CGPoint)point {
    CGFloat surplusHeight = ([UIScreen mainScreen].bounds.size.width - point.y);
    for (int i = 0; i < 5; i++) {
        emiter = [YJFavorEmitterCell emitterCellWithFrame:CGRectMake(point.x - 25, point.y - 25, 50, 50)
                                                floatArea:CGRectMake(point.x, -surplusHeight, 100,surplusHeight)
                                                    image:[UIImage imageNamed:@"heart"]];
        
        emiter.shiftCycle = 5;
        emiter.risingDuration = 10;
        emiter.risingShiftDuration = 2;
        emiter.fadeOutDuration = 3;
        emiter.fadeOutShiftDuration = 2;
        [self.layer addSublayer:emiter];
        [emiter startAnimation];
    }
}


- (void)resetHitTestCache {
    self.previousTouchPoint = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);
    self.previousTouchHitTestResponse = NO;
}

@end
