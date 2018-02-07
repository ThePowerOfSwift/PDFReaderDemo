//
//  LLAnnotationTextField.m
//  ReaderDemo
//
//  Created by 李璐 on 2018/2/7.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import "LLAnnotationTextField.h"

@implementation LLAnnotationTextField

-(instancetype)initWithAnnotate:(PDFAnnotation*)annotate pdfview:(PDFView *)pdfview
{
    if (self = [super init]) {
        _annotate = annotate;
        [_annotate setShouldDisplay:NO];
        _pdfview = pdfview;
        
        _textField = [[UITextField alloc]init];
        [pdfview addSubview:_textField];
        
        [self updateUI];
        [_textField becomeFirstResponder];
    }
    return self;
}

-(void)updateUI
{
    CGRect annotateFrame = [_pdfview convertRect:_annotate.bounds fromPage:_pdfview.currentPage];
    _textField.frame = annotateFrame;
    
    _textField.font = _annotate.font;
    _textField.textColor = _annotate.fontColor;
    _textField.text = _annotate.contents;
}
@end
