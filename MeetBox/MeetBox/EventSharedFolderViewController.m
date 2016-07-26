//
//  EventSharedFolderViewController.m
//  MeetBox
//
//  Created by drophack on 7/25/16.
//  Copyright © 2016 Erik Hope. All rights reserved.
//

#import "EventSharedFolderViewController.h"

@interface EventSharedFolderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *folderName;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EventSharedFolderViewController

- (id)initWithFolderName:(NSString *)folderName
{
    if (self = [super init]) {
        _folderName = folderName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UITableView *t = self.tableView;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[t]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(t)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[t]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(t)]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ID"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.folderName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
