//
//  SJViewController.h
//  TableTestView1
//
//  Created by DX141-XL on 2014-04-28.
//  Copyright (c) 2014 xtremer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table1;

@end
