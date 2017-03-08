//
//  MenuViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "MenuViewController.h"

@implementation SWUITableViewCell
@end

@implementation MenuViewController

-(void)viewDidLoad{

    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
    if ( [sender isKindOfClass:[UITableViewCell class]] )
    {
//        UILabel* c = [(SWUITableViewCell *)sender label];
//        UINavigationController *navController = segue.destinationViewController;
//        ColorViewController* cvc = [navController childViewControllers].firstObject;
//        if ( [cvc isKindOfClass:[ColorViewController class]] )
//        {
//            cvc.color = c.textColor;
//            cvc.text = c.text;
//        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"Customer List";
            break;
            
        case 1:
            CellIdentifier = @"Settings";
            break;
            
        case 2:
            CellIdentifier = @"Old Proposals";
            break;
        case 3:
            CellIdentifier = @"Training Videos";
            break;
        case 4:
            CellIdentifier = @"Presentations";
            break;
    }
    SWUITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SWUITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    cell.tag = indexPath.row;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(cell.tag == indexPath.row) {
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            UIImageView *imagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator"]];
            imagView.frame = CGRectMake(10,cell.frame.size.height -1, self.view.frame.size.width-80, 0.5);
            [imagView setContentMode:UIViewContentModeScaleToFill];
            [cell addSubview:imagView];
        }
    });
    return cell;
}

#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}

@end
