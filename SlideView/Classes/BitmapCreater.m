//
//  BitmapCreater.m
//  SlideView
//
//  Created by Ghost on 8/29/16.
//  Copyright © 2016 axel. All rights reserved.
//

#import "BitmapCreater.h"

@implementation BitmapCreater

+(void)createBitmapWithText:(NSString*)text to:(UIImageView*)imgView{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary*attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
                                   NSParagraphStyleAttributeName:paragraphStyle,
                                   NSForegroundColorAttributeName:[UIColor blackColor]};
        CGRect rect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        UIGraphicsBeginImageContext(rect.size);
        //CGContextRef context = UIGraphicsGetCurrentContext();
        [text drawWithRect:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            imgView.frame = rect;
            imgView.image = nil;
            imgView.image = temp;
        });
    });
}
@end
