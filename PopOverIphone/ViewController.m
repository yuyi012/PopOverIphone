//
//  ViewController.m
//  PopOverIphone
//
//  Created by 俞 億 on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsFilter.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "CMPopTipView.h"

#define kDefaultAlertTag 100
#define k5AlertTAg 101
#define kCustomAlertTag 102

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *provincePath = [[NSBundle mainBundle]pathForResource:@"Province" ofType:@"plist"];
    provinceArray = [[NSArray alloc]initWithContentsOfFile:provincePath];
}

- (void)dealloc
{
    [provinceArray release];
    [super dealloc];
}

#pragma mark alert
-(IBAction)alertButtonClick:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"亲,给个五星好评吧"
                                                      delegate:self
                                             cancelButtonTitle:@"下次再说"
                                             otherButtonTitles:@"进行评价",@"不再提醒", nil];
    alertView.tag = kDefaultAlertTag;
    [alertView show];
    [alertView release];
}

-(IBAction)alert5ButtonClick:(id)sender{
    UIAlertView *alertView5 = [[UIAlertView alloc]initWithTitle:@"登录" 
                                                        message:@"请输入帐户名和密码"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认", nil];
    alertView5.tag = k5AlertTAg;
    alertView5.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alertView5 show];
    [alertView5 release];
}

-(IBAction)alertWithCustomViewButtonClick:(id)sender{
    UIAlertView *customAlert = [[UIAlertView alloc]initWithTitle:@"正在加载"
                                                         message:@"\n\n"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确认", nil];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingView.center = CGPointMake(140, 70);
    [customAlert addSubview:loadingView];
    [loadingView startAnimating];
    [loadingView release];
    customAlert.tag = kCustomAlertTag;
    [customAlert show];
    [customAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==kDefaultAlertTag) {
        NSLog(@"buttonIndex:%d",buttonIndex);
        if (buttonIndex==1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=425349261"]];
        }
    }else if (alertView.tag==k5AlertTAg) {
        if (buttonIndex==1) {
            NSLog(@"name:%@,pass:%@",[alertView textFieldAtIndex:0].text,[alertView textFieldAtIndex:1].text);
        }
    }
}

#pragma mark action sheet
-(IBAction)actionSheetButtonClick:(id)sender{
    UIActionSheet *photoActionSheet = [[UIActionSheet alloc]initWithTitle:@"选择照片"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照",@"相册",nil];
    [photoActionSheet showInView:self.view];
    [photoActionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex:%d",buttonIndex);
    
    NSString *selectedButtontTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([selectedButtontTitle isEqualToString:@"拍照"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentModalViewController:imagePickerController animated:YES];
            [imagePickerController release];
        }
    }else if ([selectedButtontTitle isEqualToString:@"相册"]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:imagePickerController animated:YES];
        [imagePickerController release];
    }
}

#pragma mark picker
-(IBAction)pickerButtonClick:(id)sender{
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 245, 320, 300)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:pickerView];
    [pickerView release];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger numberOfRows;
    if (component==0) {
        numberOfRows = provinceArray.count;
    }else if(component==1){
        NSDictionary *provinceDic = [provinceArray objectAtIndex:component];
        NSArray *cityArray = [provinceDic objectForKey:@"cityArray"];
        numberOfRows = cityArray.count;
    }
    return numberOfRows;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        NSDictionary *provinceDic = [provinceArray objectAtIndex:row];
        return [provinceDic objectForKey:@"provinceName"];
    }else if (component==1) {
        NSDictionary *provinceDic = [provinceArray objectAtIndex:[pickerView selectedRowInComponent:0]];
        NSArray *cityArray = [provinceDic objectForKey:@"cityArray"];
        return [cityArray objectAtIndex:row];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        [pickerView reloadComponent:1];
    }
}

-(IBAction)datePickerButtonClick:(id)sender{
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 250, 320, 300)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.maximumDate = [NSDate date];
    datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:60*60*24*365*10];
    [datePicker addTarget:self
                   action:@selector(dateSelect:) 
         forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
}

-(void)dateSelect:(UIDatePicker*)theDatePicker{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"date:%@",[dateFormatter stringFromDate:theDatePicker.date]);
    [dateFormatter release];
}

-(IBAction)popControllerButtonClick:(id)sender{
    UIViewController *viewController = [[UIViewController alloc]init];
    UIPopoverController *popOverController = [[UIPopoverController alloc]initWithContentViewController:viewController];
    [popOverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];
    [popOverController release];
}
-(IBAction)customViewButtonClick:(id)sender{
    UIView *singleMapView = [[UIView alloc]
                                        initWithFrame:CGRectMake(0, (460-250)/2, 320, 250)];
    singleMapView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:singleMapView];
    //singleMapView.layer.anchorPoint = CGPointMake(160, tableHeight/2);
    CATransform3D start1 = CATransform3DIdentity;
    start1.m34 = 1.0 / -500;
    start1 = CATransform3DRotate(start1,0.0f,0.0f,1.0f,0.0f);
    start1 = CATransform3DScale(start1, 0.2, 0.2, 1);
    CATransform3D half = CATransform3DIdentity;
    half.m34 = 1.0 / -500;
    half = CATransform3DRotate(half,M_PI/2,0.0f,1.0f,0.0f);
    half = CATransform3DScale(half, 0.85, 0.85, 1);
    CATransform3D half2 = CATransform3DIdentity;
    half2.m34 = 1.0 / -500;
    half2 = CATransform3DRotate(half2,M_PI*3/2,0.0f,1.0f,0.0f);
    half2 = CATransform3DScale(half2, 0.85, 0.85, 1);
    CATransform3D end = CATransform3DIdentity;
    end.m34 = 1.0 / -500;
    end = CATransform3DRotate(end,0.0f,0.0f,1.0f,0.0f);
    end = CATransform3DScale(end, 1, 1, 1);
    //翻转动画
    singleMapView.layer.zPosition = 100;
    singleMapView.layer.transform = start1;
    UIButton *button = (UIButton*)sender;
    singleMapView.layer.position = button.center;
    //singleMapView.alpha = 0.6;
    [UIView animateWithDuration:0.5
                     animations:^{
                         singleMapView.layer.position = CGPointMake(160, 180);
                         singleMapView.layer.transform = half;
                         //singleMapView.alpha = 0.9;
                         //singleMapView.alpha = 0.8;
                     }completion:^(BOOL finish){
                         singleMapView.layer.transform = half2;
                         [UIView animateWithDuration:0.6 animations:^{
                             //singleMapView.center = CGPointMake(160, 230);
                             singleMapView.layer.transform = end;
                             singleMapView.layer.position = CGPointMake(160, 230);
                             //singleMapView.alpha = 1;
                         }];
                     }];
}

-(IBAction)shanZhaiUIAlert:(id)sender{
    UIView *singleMapView = [[UIView alloc]
                             initWithFrame:CGRectMake(10, 150, 300, 250)];
    singleMapView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:singleMapView];
//    UIButton *button = (UIButton*)sender;
//    singleMapView.center = button.center;
    singleMapView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    [UIView animateWithDuration:0.5
                     animations:^{
                         singleMapView.transform = CGAffineTransformMakeScale(1.2, 1.2);  
                     }completion:^(BOOL finish){
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              singleMapView.transform = CGAffineTransformMakeScale(0.9, 0.9);  
                                          }completion:^(BOOL finish){
                                              [UIView animateWithDuration:0.2
                                                               animations:^{
                                                                   singleMapView.transform = CGAffineTransformMakeScale(1, 1);  
                                                               }completion:^(BOOL finish){
                                                                   
                                                               }];
                                          }];
                     }];
}

-(IBAction)thirdPartButtonClick:(id)sender{
    UIButton *button = (UIButton*)sender;
    CMPopTipView *popTipView = [[CMPopTipView alloc]initWithMessage:@"自定义弹出"];
    [popTipView presentPointingAtView:button inView:self.view animated:YES];
    [popTipView release];
}
@end
