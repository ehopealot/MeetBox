//
//  GoogleCalendarViewController.m
//  MeetBox
//
//  Created by Erik Hope on 7/25/16.
//  Copyright © 2016 Erik Hope. All rights reserved.
//

#import "GoogleCalendarViewController.h"

#import "GoogleCalendarEventDetailViewController.h"
#import "GTMOauth2ViewControllerTouch.h"
#import "GTLRCalendar.h"
#import "GTLRCalendarQuery.h"
#import "GTLRCalendarService.h"

static NSString *const KEYCHAIN_NAME = @"Google Calendar API";

@interface GoogleCalendarViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GTLRCalendarService *service;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GTLRCalendar_Events *events;

@end

@implementation GoogleCalendarViewController

+ (NSString *)getClientId
{
    static NSString *clientId = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"]];
        clientId = dictionary[@"google_client_id"];
    });
    return clientId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.service = [[GTLRCalendarService alloc] init];
    self.service.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:KEYCHAIN_NAME clientID:[GoogleCalendarViewController getClientId] clientSecret:nil];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    UITableView *t = self.tableView;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[t]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(t)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[t]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(t)]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ID"];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];

    self.title = @"Upcoming Events";
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.service.authorizer.canAuthorize) {
        [self presentViewController:[self createAuthController] animated:YES completion:nil];
    } else {
        [self fetchEvents];
    }
}

- (UIViewController *)createAuthController
{
    NSArray *scopes = @[kGTLRAuthScopeCalendarReadonly];
    GTMOAuth2ViewControllerTouch *authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:[scopes componentsJoinedByString:@" "] clientID:[GoogleCalendarViewController getClientId] clientSecret:nil keychainItemName:KEYCHAIN_NAME completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
        if (error != nil) {
            // boo. Dismiss 2x to just go all the way back to the root controller.
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            self.service.authorizer = auth;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    return authController;
}

- (void)fetchEvents
{
    GTLRCalendarQuery_EventsList *query = [GTLRCalendarQuery_EventsList queryWithCalendarId:@"primary"];
    query.maxResults = 10;
    query.timeMin = [GTLRDateTime dateTimeWithDate:[NSDate date]];
    query.singleEvents = YES;
    query.orderBy = kGTLRCalendarOrderByStartTime;
    [self.service executeQuery:query completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
        if (!callbackError) {
            _events = object;
        }
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_events.items count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Calendar Events";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    GTLRCalendar_Event *event = _events.items[indexPath.item];
    cell.textLabel.text = event.summary;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoogleCalendarEventDetailViewController *detailVC = [[GoogleCalendarEventDetailViewController alloc] initWithEvent:_events.items[indexPath.item]];
    [self.navigationController pushViewController:detailVC animated:YES];
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
