//
//  ListViewController.h
//  WhatsApplebees
//
//  Created by Michael Walker on 3/6/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end
