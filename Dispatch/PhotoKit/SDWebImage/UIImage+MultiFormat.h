//
//  UIImage+MultiFormat.h
//  SDWebImage
//
//  Created by Olivier Poitrey on 07/06/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FLAnimatedImage.h"

#define isFLGIF(A) [A isMemberOfClass:[FLAnimatedImage class]]

@interface UIImage (MultiFormat)

+ (UIImage *)sd_imageWithData:(NSData *)data;

@end
