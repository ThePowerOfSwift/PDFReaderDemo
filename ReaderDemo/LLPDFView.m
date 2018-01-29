//
//  LLPDFView.m
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/27.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import "LLPDFView.h"

@interface LLPDFView()

@end

@implementation LLPDFView

-(void)drawPage:(PDFPage *)page toContext:(CGContextRef)context
{
    [super drawPage:page toContext:context];
    
    if ([self.activeAnnotate.page isEqual:page]) {
        if (CGSizeEqualToSize(CGSizeZero, self.activeAnnotate.bounds.size))
            return;
        
        CGRect leftTop = CGRectMake(self.activeAnnotate.bounds.origin.x - 5, self.activeAnnotate.bounds.origin.y - 5, 10, 10);
        CGRect rightTop = CGRectMake(self.activeAnnotate.bounds.origin.x + self.activeAnnotate.bounds.size.width - 5, self.activeAnnotate.bounds.origin.y - 5, 10, 10);
        CGRect leftBottom = CGRectMake(self.activeAnnotate.bounds.origin.x - 5, self.activeAnnotate.bounds.origin.y + self.activeAnnotate.bounds.size.height - 5, 10, 10);
        CGRect rightBottom = CGRectMake(self.activeAnnotate.bounds.origin.x + self.activeAnnotate.bounds.size.width - 5, self.activeAnnotate.bounds.origin.y+ self.activeAnnotate.bounds.size.height - 5, 10, 10);
        CGFloat lineWidth = 3;
        CGColorRef color = [UIColor redColor].CGColor;
        
        NSArray<NSValue*>* rectArr = @[[NSValue valueWithCGRect:leftTop],[NSValue valueWithCGRect:rightTop],[NSValue valueWithCGRect:leftBottom],[NSValue valueWithCGRect:rightBottom]];
        
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, color);
        CGContextSetLineWidth(context, lineWidth);
        for (int i = 0; i < 4; i++) {
            CGRect rect = rectArr[i].CGRectValue;
            CGContextStrokeRect(context, CGRectInset(rect, -0.5 * lineWidth, -0.5 * lineWidth));
        }
        CGContextRestoreGState(context);
    }
}
@end
