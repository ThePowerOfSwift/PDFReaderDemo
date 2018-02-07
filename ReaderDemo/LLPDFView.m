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
    
    if ([self.activeAnnotate.page isEqual:page] && self.activeAnnotate.shouldDisplay) {
        if (CGSizeEqualToSize(CGSizeZero, self.activeAnnotate.bounds.size))
            return;
        
        CGRect leftTop = CGRectMake(self.activeAnnotate.bounds.origin.x - _widthOfAnnotateScale/2, self.activeAnnotate.bounds.origin.y - _widthOfAnnotateScale/2, _widthOfAnnotateScale, _widthOfAnnotateScale);
        CGRect rightTop = CGRectMake(self.activeAnnotate.bounds.origin.x + self.activeAnnotate.bounds.size.width - _widthOfAnnotateScale/2, self.activeAnnotate.bounds.origin.y - _widthOfAnnotateScale/2, _widthOfAnnotateScale, _widthOfAnnotateScale);
        CGRect leftBottom = CGRectMake(self.activeAnnotate.bounds.origin.x - _widthOfAnnotateScale/2, self.activeAnnotate.bounds.origin.y + self.activeAnnotate.bounds.size.height - _widthOfAnnotateScale/2, _widthOfAnnotateScale, _widthOfAnnotateScale);
        CGRect rightBottom = CGRectMake(CGRectGetMaxX(self.activeAnnotate.bounds) - _widthOfAnnotateScale/2, CGRectGetMaxY(self.activeAnnotate.bounds) - _widthOfAnnotateScale/2, _widthOfAnnotateScale, _widthOfAnnotateScale);
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
        CGContextStrokeRect(context,self.activeAnnotate.bounds);
        CGContextRestoreGState(context);
    }
}

-(void)setActiveAnnotate:(PDFAnnotation *)activeAnnotate
{
    _activeAnnotate = activeAnnotate;
    
    if (activeAnnotate) {
        self.userInteractionEnabled = NO;
    }
    else
    {
        self.userInteractionEnabled = YES;
    }
}
@end
