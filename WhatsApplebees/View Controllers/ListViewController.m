//
//  ListViewController.m
//  WhatsApplebees
//
//  Created by Michael Walker on 3/6/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "ListViewController.h"
#import "MessageInputView.h"
#import "Message.h"
#import "MessageCell.h"
#import "NotInApplebeesView.h"

#import <UIView+FLKAutoLayout.h>
#import <UIView+MWKeyboardAnimation.h>
#import <UIView+MWLayoutHelpers.h>
#import <Parse/Parse.h>
#import "NSObject+ClassName.h"
#import "UIImage+ImageWithColor.h"
#import <IntentKit/INKMapsHandler.h>

static NSString * const CellIdentifier = @"CellIdentifier";

@interface ListViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) MessageInputView *messageInputView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic) NotInApplebeesView *notInApplebeesView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *coordinates;
@property (strong, nonatomic) CLLocation *currentApplebees;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (assign, nonatomic) BOOL canUseApp;
@property (assign, nonatomic) BOOL override;
@property (assign, nonatomic) BOOL firstFetch;

@end

@implementation ListViewController

- (id)init {
    self = [super init];
    if (!self) return nil;

    [self loadCoordinates];

    self.title = @"WhatsApplebee's";

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined && [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    } else if (CLLocationManager.authorizationStatus != kCLAuthorizationStatusDenied) {
        [self.locationManager startUpdatingLocation];
        self.currentLocation = self.locationManager.location;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = @"Location Services Disabled";
        alert.message = @"In order to connect with other Applebee's fans, you'll need to open the Settings app and enable Location Services for WhatsApplebee's";
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    }


    self.notInApplebeesView = [NotInApplebeesView new];
    [self.view addSubview:self.notInApplebeesView];
    [self.notInApplebeesView alignToView:self.view];
    self.notInApplebeesView.hidden = YES;

    __weak ListViewController *weakSelf = self;
    self.notInApplebeesView.toggleBlock = ^{
        [weakSelf toggleAvailability];
    };

    self.notInApplebeesView.locateBlock = ^{
        [weakSelf locate];
    };

    self.messageInputView = [[MessageInputView alloc] init];
    [self.view addSubview:self.messageInputView];
    self.messageInputView.x = 0;
    self.messageInputView.width = self.view.width;
    self.messageInputView.height = 44.0;
    self.messageInputView.bottom = self.view.bottom;

    self.messageInputView.sentMessageCompletionBlock = ^void(Message *message){
        weakSelf.data = [weakSelf.data arrayByAddingObject:message];
        [weakSelf.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.data.count - 1 inSection:0];
        [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    };

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView alignTopEdgeWithView:self.view predicate:nil];
    self.bottomConstraint = [[self.tableView alignBottomEdgeWithView:self.view predicate:@"-44"] firstObject];
    [self.tableView alignLeadingEdgeWithView:self.view predicate:nil];
    [self.tableView alignTrailingEdgeWithView:self.view predicate:nil];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.tableView registerNib:[UINib nibWithNibName:MessageCell.className bundle:NSBundle.mainBundle] forCellReuseIdentifier:CellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view bringSubviewToFront:self.messageInputView];

    [self startFetching];

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setCanUseApp:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.canUseApp ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

- (void)startFetching {
    self.firstFetch = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(fetch) userInfo:nil repeats:YES];
}

- (void)stopFetching {
    [self.timer invalidate];
}

- (void)fetch {
    if (!self.canUseApp) return;

    PFQuery *query = [Message query];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query orderByDescending:@"date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            objects = [[objects reverseObjectEnumerator] allObjects];
            NSIndexPath *lastIndex = self.tableView.indexPathsForVisibleRows.lastObject;
            BOOL atBottom = lastIndex.row == self.data.count - 1;
            self.data = objects;
            [self.tableView reloadData];

            if (self.firstFetch) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.data.count-1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                self.firstFetch = NO;
            } else if (atBottom && self.data.count > lastIndex.row + 1) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:lastIndex.row + 1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }

        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 
- (void)loadCoordinates {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *coordinates = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    NSMutableArray *newCoordinates = [NSMutableArray new];
    for (NSDictionary *coords in coordinates) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[coords[@"latitude"] doubleValue] longitude:[coords[@"longitude"] doubleValue]];
        [newCoordinates addObject:location];
    }

    self.coordinates = [newCoordinates copy];

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(MessageCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.data[indexPath.row];
    cell.message = message;

    if (indexPath.row == 0) {
        cell.showsDayHeader = YES;
    } else {
        Message *previousMessage = self.data[indexPath.row - 1];
        if (![message.day isEqualToString:previousMessage.day]) {
            cell.showsDayHeader = YES;
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = (Message *)self.data[indexPath.row];
    NSString *text = message.message;
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(MessageCell.messageWidth, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:MessageCell.font}
                                             context:nil];
    CGFloat estimatedHeight = ceil(boundingRect.size.height) + 30;

    CGFloat dayHeader = 0;
    if (indexPath.row == 0) {
        dayHeader = 20.0;
    } else  {
        Message *previousMessage = (Message *)self.data[indexPath.row - 1];
        if (![message.day isEqualToString:previousMessage.day]) {
            dayHeader = 20.0;
        }
    }

    return MAX(estimatedHeight, 44.0) + dayHeader;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
}

#pragma mark - Keyboard animation
- (void)keyboardWillShow:(NSNotification *)notification {
    NSIndexPath *lastRow = self.tableView.indexPathsForVisibleRows.lastObject;

    [UIView animateWithKeyboardNotification:notification animations:^(CGRect keyboardFrame) {
        self.messageInputView.bottom = self.view.bottom - keyboardFrame.size.height;

        self.bottomConstraint.constant = -(keyboardFrame.size.height + 44);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];

}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithKeyboardNotification:notification animations:^(CGRect keyboardFrame) {
        self.messageInputView.bottom = self.view.bottom;
        self.bottomConstraint.constant = -44;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations.count == 0) return;
    self.currentLocation = locations.lastObject;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorized) {
        [self.locationManager startUpdatingLocation];
        self.currentLocation = self.locationManager.location;
    }
}

#pragma mark -
- (void)setCurrentLocation:(CLLocation *)currentLocation {
    if (self.override) return;

    _currentLocation = currentLocation;

    CGFloat MAX_DISTANCE = 130.0;
    if (currentLocation == nil) {
        self.currentApplebees = nil;
    } else {
        if (self.currentApplebees) {
            if (![currentLocation distanceFromLocation:self.currentApplebees] < MAX_DISTANCE) {
                self.currentApplebees = nil;
            }
        }

        if (!self.currentApplebees) {
            for (CLLocation *location in self.coordinates) {
                if ([currentLocation distanceFromLocation:location] < MAX_DISTANCE) {
                    self.currentApplebees = location;
                }
            }
        }
    }

    self.canUseApp = !(self.currentApplebees == nil);
}

- (void)setCanUseApp:(BOOL)canUseApp {
    _canUseApp = canUseApp;
    if (canUseApp || self.override) {
        self.tableView.hidden = self.messageInputView.hidden = NO;
        self.navigationController.navigationBarHidden = NO;
        self.notInApplebeesView.hidden = YES;
    } else {
        self.tableView.hidden = self.messageInputView.hidden = YES;
        self.navigationController.navigationBarHidden = YES;
        self.notInApplebeesView.hidden = NO;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)toggleAvailability {
    self.override = !self.override;
    self.canUseApp = self.override;
}

- (void)locate {
    INKMapsHandler *handler = [INKMapsHandler new];
    handler.center = self.currentLocation.coordinate;
    handler.zoom = 14;
    [[handler searchForLocation:@"Applebee's"] presentModalActivitySheetFromViewController:self
                                                                                completion:nil];
}
@end
