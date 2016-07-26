//
//  GoogleCalendarEventDetailViewController.h
//  MeetBox
//
//  Created by Erik Hope on 7/25/16.
//  Copyright © 2016 Erik Hope. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTLRCalendar_Event;
@interface GoogleCalendarEventDetailViewController : UIViewController

- (id)initWithEvent:(GTLRCalendar_Event *)event;

@end
