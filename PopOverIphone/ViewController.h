//
//  ViewController.h
//  PopOverIphone
//
//  Created by 俞 億 on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    NSArray *provinceArray;
}
-(IBAction)alertButtonClick:(id)sender;
@end
