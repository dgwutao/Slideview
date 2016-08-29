//
//  BitmapCreater.h
//  SlideView
//
//  Created by Ghost on 8/29/16.
//  Copyright © 2016 axel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BitmapCreater : NSObject

+(void)createBitmapWithText:(NSString*)text to:(UIImageView*)imgView;
@end
