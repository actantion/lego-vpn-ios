//
//  BaseTableViewController.m
//  PlayGame
//
//  Created by admin on 2020/10/28.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageIndex = 1;
    self.pageSize = 10;
    self.bShowFresh = false;
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    
    [self.view addSubview:self.tableView];
    [self registCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets padding = UIEdgeInsetsMake(self.vwNavigation.height, 0, 0, 0);
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(padding).priority(999);
        }];
    }];
    
    self.dataArray = [[NSMutableArray alloc] init];
    [self loadUI];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
}
- (void)hiddenNavigation{
    [super hiddenNavigation];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets padding = UIEdgeInsetsMake(-20, 0, 0, 0);
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(padding);
        }];
    }];
}
- (void)addRefreshLoading{
    
//    @weakify(self);
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        @strongify(self);
//        self.pageIndex = 1;
//        [self loadData];
//    }];
//    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
//        @strongify(self);
//        self.pageIndex++;
//        [self loadData];
//    }];
}
- (void)reloadTableView
{
//    if (self.bShowFresh == false) {
//        self.tableView.mj_header = nil;
//        self.tableView.mj_footer = nil;
//    }else{
//        if (self.dataArray.count != self.pageSize*self.pageIndex) {
//            self.tableView.mj_footer = nil;
//        }
//    }
    [self.tableView reloadData];
}
- (void)loadData
{
    
}
- (void)loadUI{
    NSLog(@"子类未重写\"loadUI\"方法设置界面");
    assert(1);
}
- (void)registCell{
    [self.tableView registCell:@"UISpaceCell"];
    [self.tableView registCell:@"UITipsCell"];
    [self.tableView registCell:@"UITextFiledCell"];
    [self.tableView registCell:@"UIVerificationCodeCell"];
    [self.tableView registCell:@"UIConfirnBtnCell"];
    [self.tableView registCell:@"UIForgetRegistCell"];
    [self.tableView registCell:@"UILabelButtonCell"];
    [self.tableView registCell:@"UILineCell"];
    [self.tableView registCell:@"UIImageLabelSelectCell"];
    [self.tableView registCell:@"UILabelContentCell"];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UIBaseModel* model = self.dataArray[indexPath.row];
    if ([model.type  isEqual: @(UISpaceType)]) {
        return [tableView reloadCell:@"UISpaceCell" withModel:model withBlock:nil];
    }else if([model.type  isEqual: @(UILineType)]){
        return [tableView reloadCell:@"UILineCell" withModel:model withBlock:nil];
    }else if([model.type  isEqual: @(UITipsType)]){
        return [tableView reloadCell:@"UITipsCell" withModel:model withBlock:nil];
    }else{
        return [[UITableViewCell alloc] init];
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
