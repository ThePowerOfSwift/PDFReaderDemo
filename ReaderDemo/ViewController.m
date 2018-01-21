//
//  ViewController.m
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/20.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import "ViewController.h"
#import <PDFKit/PDFKit.h>

@interface ViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)PDFView * pdfview;

@property(nonatomic,strong)UITextField * textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PDFView * pdfview = [[PDFView alloc]init];
    self.pdfview = pdfview;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    pdfview.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    [self.view addSubview:pdfview];
    
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"pdf"];
    PDFDocument * pdfdocument = [[PDFDocument alloc]initWithURL:url];
    
    pdfview.document = pdfdocument;
    pdfview.displayMode = kPDFDisplaySinglePageContinuous;
    pdfview.autoScales = true;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    [tap requireGestureRecognizerToFail:doubleTap];
}

-(void)tapAction
{
    //接下来做tap输入文字
    [self.textField removeFromSuperview];
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
    [self.view addSubview:self.textField];
    self.textField.backgroundColor = [UIColor orangeColor];
    [self.textField becomeFirstResponder];
    self.textField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self insertTextAnnotation:textField.text];
    return YES;
}

-(void)insertTextAnnotation:(NSString*)text
{
    PDFPage * page = self.pdfview.currentPage;
    
    CGRect frame = self.textField.frame;
    CGRect textFrameInPDF = [self.pdfview convertRect:frame toPage:page];
    
    
    
    PDFAnnotation * annotation = [[PDFAnnotation alloc]initWithBounds:textFrameInPDF forType:PDFAnnotationSubtypeWidget withProperties:nil];
    annotation.font = [UIFont systemFontOfSize:28];
    annotation.widgetFieldType = PDFAnnotationWidgetSubtypeText;
    annotation.widgetStringValue = text;
    annotation.fieldName = text;
    annotation.backgroundColor = [UIColor redColor];
    [page addAnnotation:annotation];
    //现在的目标是让text在PDF中显示出来

    [self.pdfview setNeedsDisplay];
}

-(CGRect)converRect:(CGRect)rect fromInSize:(CGSize)originalSize toInSize:(CGSize)targetSize
{
    rect.size.width *= targetSize.width/originalSize.width;
    rect.size.height *= targetSize.height/originalSize.height;
    rect.origin.x *= targetSize.width/originalSize.width;
    rect.origin.y *= targetSize.height/originalSize.height;
    return rect;
}

-(void)doubleTapAction
{
    NSLog(@"%s",__func__);
    
    [self.textField removeFromSuperview];
    
    PDFPage * page = self.pdfview.currentPage;
    
    NSArray<PDFAnnotation*>* annotationArray = [page annotations];
    
    NSLog(@"%@",annotationArray);
    for (PDFAnnotation * annotation in annotationArray) {
        NSLog(@"%@",annotation.fieldName);
    }
}

-(void)insertCircle
{
    NSLog(@"%s",__func__);
    
    PDFPage * page = self.pdfview.currentPage;
    
    PDFAnnotation * annotation = [[PDFAnnotation alloc]initWithBounds:CGRectMake(0, 0, 500, 500) forType:PDFAnnotationSubtypeCircle withProperties:nil];
    annotation.font = [UIFont systemFontOfSize:18];
    annotation.fieldName = @"ll-fieldName";
    [page addAnnotation:annotation];
    
    [self.pdfview setNeedsDisplay];
}

@end
