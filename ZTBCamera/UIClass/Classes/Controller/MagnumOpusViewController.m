//
//  MagnumOpusViewController.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/6/7.
//  Copyright © 2017年 Dreams of Ideal World Co., Ltd. All rights reserved.
//

#import "MagnumOpusViewController.h"

#import "MagnumOpusCell.h"
#import "MagnumOpusDetailViewController.h"

@interface MagnumOpusViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentTableView;

@end

@implementation MagnumOpusViewController

- (UITableView *)contentTableView
{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.showsVerticalScrollIndicator = NO;
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"MagnumOpusCell" bundle:[NSBundle mainBundle]];
        _contentTableView.backgroundColor = [UIColor clearColor];
        _contentTableView.showsVerticalScrollIndicator = NO;
        [_contentTableView registerNib:nib forCellReuseIdentifier:@"IDMagnumOpusCell"];
    }
    return _contentTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"代表作";
    
    [self.view addSubview:self.contentTableView];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;//_contentArray.count
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MagnumOpusCell *cell=[self.contentTableView dequeueReusableCellWithIdentifier:@"IDMagnumOpusCell"];
    if (!cell) {
        cell = [[MagnumOpusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDMagnumOpusCell"];
    }
    [cell buildCellWithItem:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MagnumOpusCell *cell = (MagnumOpusCell *)[self tableView:self.contentTableView cellForRowAtIndexPath:indexPath];
    return [cell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"当前选中了 %ld", indexPath.row);
    MagnumOpusDetailViewController *VC = [[MagnumOpusDetailViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
