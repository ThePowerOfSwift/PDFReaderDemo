//
//  OutlineController.m
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/26.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import "OutlineController.h"
#import "LLTextCell.h"

@interface OutlineController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property(nonatomic,strong)UITableView * tableView;

@end

@implementation OutlineController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.contentView.bounds;
}

-(void)setAnnotationArray:(NSArray<NSArray<PDFAnnotation *> *> *)annotationArray
{
    _annotationArray = annotationArray;
    
    [self.tableView reloadData];
}

-(UITableView *)tableView
{
    if (self.contentView && !_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.tableFooterView = [[UIView alloc]init];
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
}

- (IBAction)dismiss
{
    [self.presentingViewController dismissViewControllerAnimated:self completion:nil];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.annotationArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.annotationArray[section].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.annotationArray[indexPath.section][indexPath.row].type;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @(section).stringValue;
}
@end
