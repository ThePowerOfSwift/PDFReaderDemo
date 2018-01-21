//
//  ViewController.m
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/20.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import "ViewController.h"
#import <PDFKit/PDFKit.h>

@interface ViewController ()

@property(nonatomic,strong)PDFView * pdfview;

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
    NSLog(@"%s",__func__);
    
    PDFPage * page = self.pdfview.currentPage;
    
    PDFAnnotation * annotation = [[PDFAnnotation alloc]initWithBounds:CGRectMake(0, 0, 500, 500) forType:PDFAnnotationSubtypeCircle withProperties:nil];
    annotation.font = [UIFont systemFontOfSize:18];
    annotation.fieldName = @"ll-fieldName";
    [page addAnnotation:annotation];
    
    [self.pdfview setNeedsDisplay];
}

-(void)doubleTapAction
{
    NSLog(@"%s",__func__);
    PDFPage * page = self.pdfview.currentPage;
    
    NSArray<PDFAnnotation*>* annotationArray = [page annotations];
    
    NSLog(@"%@",annotationArray);
    for (PDFAnnotation * annotation in annotationArray) {
        NSLog(@"%@",annotation.fieldName);
    }
}
@end
