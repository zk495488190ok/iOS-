//
//  KDSectorButton.h
//  koudaizikao
//
//  Created by lsq on 15/12/1.
//  Copyright © 2015年 withustudy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DivoomTransparencyButton : UIButton

@property (nonatomic, assign) BOOL  isShowAnimation;

- (instancetype)initWithFitImage:(UIImage *)fitImage;

- (void) setFiltImage:(UIImage *)image;
@end
