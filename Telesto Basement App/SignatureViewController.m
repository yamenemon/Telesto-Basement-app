//
//  SignatureViewController.m
//  Telesto Basement App
//
//  Created by CSM on 7/28/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "SignatureViewController.h"

@interface SignatureViewController ()

@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Proposal Confirmation";
    // Do any additional setup after loading the view.
    SignatureView *signView= [[ SignatureView alloc] initWithFrame: CGRectMake(10, 64, self.view.frame.size.width-40, 500)];
    [signView setBackgroundColor:[UIColor whiteColor]];
    signView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    signView.layer.borderWidth = 1.0;
    [self.view addSubview:signView];
    
    UILabel *confirmationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 515+64, self.view.frame.size.width-40, 30)];
    [self.view addSubview:confirmationLabel];
    confirmationLabel.textColor = [UIColor darkGrayColor];
    confirmationLabel.backgroundColor = [UIColor lightGrayColor];
    confirmationLabel.text = @"You are entering into a contract. If that contract is a result of or in connection with a salesman's direct contact with or call to you at your residence without your soliciting the contract or call then you have a legal right to void the contract or sale by notifying us within (3) business days from whichever of the following events occurs last: \n 1) The date of the transaction, which is %@ \n 2) The date you received this notice of cancellation.\nHow To Cancel\n   If you decide to cancel this transaction, you may do so by notifying us in writing at  Pioneer Basement 31 Sanford Rd, Westport, MA 02790. You may use any written statement that is signed and dated by you and states your intentions to cancel, or you may use this notice by dating and signing below. Keep one copy of the notice because it contains important information about your rights. If you cancel by mail or telegram, you must send the notice no later than midnight of the third business day following the latest of the two events listed above. If you send or deliver your written notice to cancel some other way; it must be delivered to the above address no later than that time.";
        CGRect labelRect = [confirmationLabel.text
                        boundingRectWithSize:confirmationLabel.frame.size
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{
                                     NSFontAttributeName : [UIFont systemFontOfSize:4]
                                     }
                        context:nil];
    
    CGRect frame = confirmationLabel.frame;
    frame.size.height = labelRect.size.height;
    confirmationLabel.frame = frame;
    confirmationLabel.numberOfLines = 0;
    [confirmationLabel sizeToFit];

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
