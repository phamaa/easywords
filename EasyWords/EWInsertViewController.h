//
//  EWInsertViewController.h
//  EasyWords
//
//  Created by Pham on 2/9/13.
//  Copyright (c) 2013 com.quangpham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface EWInsertViewController : UIViewController <MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
}
@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *lastNameText;
- (IBAction)saveButtonDidTapped:(id)sender;

@end
