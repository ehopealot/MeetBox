//
//  GoogleCalendarEventDetailViewController.m
//  MeetBox
//
//  Created by Erik Hope on 7/25/16.
//  Copyright © 2016 Erik Hope. All rights reserved.
//

#import "GoogleCalendarEventDetailViewController.h"
#import "GTLRCalendar.h"

@interface GoogleCalendarEventDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GTLRCalendar_Event *event;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation GoogleCalendarEventDetailViewController

- (id)initWithEvent:(GTLRCalendar_Event *)event
{
    self = [super init];
    if (self) {
        _event = event;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        return [_event.attendees count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Summary";
    } else if (section == 2){
        return @"Attendees";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    cell.detailTextLabel.text = nil;
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.section == 0) {
        cell.textLabel.text = _event.summary;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"Create shared folder";
        cell.textLabel.textColor = [UIColor blueColor];
    } else if (indexPath.section == 2) {
        GTLRCalendar_EventAttendee *attendee = _event.attendees[indexPath.item];
        if (attendee.displayName) {
            cell.textLabel.text = attendee.displayName;
            cell.detailTextLabel.text = attendee.email;
        } else {
            cell.textLabel.text = attendee.email;
        }
    }
    return cell;
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
