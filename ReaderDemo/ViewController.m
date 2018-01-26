//
//  ViewController.m
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/20.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import "ViewController.h"
#import <PDFKit/PDFKit.h>
#import "LLTestView.h"

@interface ViewController ()

@property(nonatomic,strong)PDFView * pdfview;

@property(nonatomic,strong)LLTestView * testView;

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
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    [tap requireGestureRecognizerToFail:doubleTap];
}


-(void)tapAction:(UITapGestureRecognizer*)tapGes
{
    UIMenuController * menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO];
    
    [self.testView removeFromSuperview];
//    [self insertTextWidget];
    /*
    //接下来做tap输入文字
    [self.textField removeFromSuperview];
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
    [self.view addSubview:self.textField];
    self.textField.backgroundColor = [UIColor orangeColor];
    [self.textField becomeFirstResponder];
    self.textField.delegate = self;
    */
}

-(void)doubleTapAction:(UIGestureRecognizer*)ges
{
    NSLog(@"%s",__func__);
    
    UIMenuController * menu = [UIMenuController sharedMenuController];
    if (menu.menuVisible) {
        [menu setMenuVisible:NO];
        [self.testView removeFromSuperview];
    }
    else
    {
        CGPoint touchPoint = [ges locationInView:self.view];
        
        [self.testView removeFromSuperview];
        self.testView = [[LLTestView alloc]init];
        CGFloat width = 70;
        CGFloat height = 40;
        self.testView.frame = CGRectMake(touchPoint.x - width/2, touchPoint.y - height/2, width, height);
        [self.view addSubview:self.testView];
        self.testView.backgroundColor = [UIColor greenColor];
        
        [self.testView becomeFirstResponder];
        UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"TextWidget" action:@selector(insertTextWidget)];
        UIMenuItem * item2 = [[UIMenuItem alloc]initWithTitle:@"Text" action:@selector(insertText)];
        menu.menuItems = @[item1,item2];
        
        [menu setTargetRect:CGRectMake(0, 0, 80, 50) inView:self.testView];
        
        [menu setMenuVisible:YES animated:YES];
    }

//    [self.textField removeFromSuperview];
//
//    PDFPage * page = self.pdfview.currentPage;
//
//    NSArray<PDFAnnotation*>* annotationArray = [page annotations];
//
//    NSLog(@"%@",annotationArray);
//    for (PDFAnnotation * annotation in annotationArray) {
//        NSLog(@"%@",annotation.fieldName);
//    }
}

//PDFAnnotationSubtypeWidget
-(void)insertTextWidget
{
    [self.testView removeFromSuperview];
    
    PDFPage * page = self.pdfview.currentPage;
    
    CGRect frame = self.testView.frame;
    CGRect textFrameInPDF = [self.pdfview convertRect:frame toPage:page];
    
    PDFAnnotation * annotation = [[PDFAnnotation alloc]initWithBounds:textFrameInPDF forType:PDFAnnotationSubtypeWidget withProperties:nil];
    annotation.font = [UIFont systemFontOfSize:28];
    annotation.widgetFieldType = PDFAnnotationWidgetSubtypeText;
    annotation.alignment = NSTextAlignmentCenter;
    annotation.backgroundColor = [UIColor orangeColor];
    [page addAnnotation:annotation];
    [self.pdfview setNeedsDisplay];
}

-(void)insertText
{
    [self.testView removeFromSuperview];

    __weak typeof(self) weakSelf = self;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"输入要插入的文本" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * textField = [[alert textFields] firstObject];
        
        NSString * string = textField.text;
        CGSize sizeOfString = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        PDFPage * page = weakSelf.pdfview.currentPage;
        CGRect frame = weakSelf.testView.frame;
        frame.size = sizeOfString;
        CGRect textFrameInPDF = [weakSelf.pdfview convertRect:frame toPage:page];
        PDFAnnotation * annotation = [[PDFAnnotation alloc]initWithBounds:textFrameInPDF forType:PDFAnnotationSubtypeFreeText withProperties:nil];
        annotation.font = [UIFont systemFontOfSize:14];
        annotation.contents = textField.text;
        annotation.alignment = NSTextAlignmentCenter;
        [page addAnnotation:annotation];
        [self.pdfview setNeedsDisplay];

    }];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入文本";
    }];
    
    [alert addAction:cancleAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
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
