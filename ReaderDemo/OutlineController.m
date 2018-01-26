//
//  OutlineController.m
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/26.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import "OutlineController.h"

@interface OutlineController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property(nonatomic,strong)UITableView * tableView;

@end

@implementation OutlineController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(UITableView *)tableView
{
    if (self.contentView && !_tableView) {
//        _tableView = [UITableView alloc]initWithFrame: style:<#(UITableViewStyle)#>
    }
}

- (IBAction)dismiss
{
    [self.presentedViewController dismissViewControllerAnimated:self completion:nil];
}
@end
