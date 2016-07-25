//
//  ViewController.m
//  MeetBox
//
//  Created by Erik Hope on 7/25/16.
//  Copyright © 2016 Erik Hope. All rights reserved.
//

#import "ViewController.h"
#import "GoogleCalendarViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *connectDropboxButton;
@property (nonatomic, strong) UIButton *connectGCalButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _connectDropboxButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_connectDropboxButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    _connectGCalButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_connectGCalButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.view addSubview:_connectDropboxButton];
    [self.view addSubview:_connectGCalButton];

    [_connectDropboxButton setTitle:@"Connect Dropbox" forState:UIControlStateNormal];
    [_connectGCalButton setTitle:@"Connect Google Calendar" forState:UIControlStateNormal];

    [_connectDropboxButton addTarget:self action:@selector(connectDropbox:) forControlEvents:UIControlEventTouchUpInside];
    [_connectGCalButton addTarget:self action:@selector(connectGoogle:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_connectDropboxButton(40)]-20-[_connectGCalButton(40)]"
                                                                      options:NSLayoutFormatAlignAllCenterX metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_connectDropboxButton, _connectGCalButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_connectDropboxButton(300)]"
                                                                      options:0 metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_connectDropboxButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_connectGCalButton(300)]"
                                                                      options:0 metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_connectGCalButton)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_connectDropboxButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_connectDropboxButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];


    [_connectDropboxButton setBackgroundColor:[UIColor redColor]];
    [_connectGCalButton setBackgroundColor:[UIColor redColor]];
}

- (void)connectDropbox:(id)sender {

}

- (void)connectGoogle:(id)sender {
    GoogleCalendarViewController *calendarController = [[GoogleCalendarViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:calendarController] animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
