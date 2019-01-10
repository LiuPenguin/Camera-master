//
//  ViewController.m
//  Camera
//
//  Created by wzh on 2017/6/2.
//  Copyright © 2017年 wzh. All rights reserved.
//

#import "ViewController.h"
#import "CameraViewController.h"
#import "ClipViewController.h"
@interface ViewController ()<CameraDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ClipPhotoDelegate>

@property(nonatomic, strong) CameraViewController *cameraViewvController;

@property (nonatomic, strong)  UIImageView *imgeView;

@property(nonatomic,strong) UIAlertController * alertCon;

@property(nonatomic,strong) UIImagePickerController *imgPicker;

@property(nonatomic,strong) UIImageView * imageV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(cameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(btn.frame) + 100, 300, 300)];
    imageV.backgroundColor = [UIColor orangeColor];
    self.imageV = imageV;
    [self.view addSubview:imageV];

    UIAlertController * alertCon = [UIAlertController alertControllerWithTitle:@"" message:@"选择照片途径" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * actionOne = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cameraViewvController = [[CameraViewController alloc] init];
        self.cameraViewvController.delegate = self;
//        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        [self presentViewController:self.cameraViewvController animated:YES completion:nil];
//        [self openImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction * actionTwo = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"actionTwo");
        [self openImagePickerControllerWithType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }];
    UIAlertAction * actionThree = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alertCon addAction:actionOne];
    [alertCon addAction:actionTwo];
    [alertCon addAction:actionThree];
    self.alertCon = alertCon;
}

- (void)cameraAction
{
    [self presentViewController:self.alertCon animated:YES completion:nil];
    return;
}


/// 打开ImagePickerController的方法
- (void)openImagePickerControllerWithType:(UIImagePickerControllerSourceType)type
{
    // 设备不可用  直接返回
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;

    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.sourceType = type;
    self.imgPicker.delegate = self;
    self.imgPicker.allowsEditing = NO;
    [self presentViewController:self.imgPicker animated:YES completion:nil];
}


#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
// 选择照片之后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{

    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self cropImage:image];
}
//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)cropImage: (UIImage *)image {
    ClipViewController *viewController = [[ClipViewController alloc] init];
    viewController.image = image;
    viewController.picker = _imgPicker;
    viewController.controller = self;
    viewController.delegate = self;
    viewController.isTakePhoto = NO;
    [_imgPicker presentViewController:viewController animated:NO completion:nil];
}


#pragma mark -- ClipPhotoDelegate
- (void)clipPhoto:(UIImage *)image
{
    //选取照片的回调
    NSLog(@"-----%@",image);
    self.imageV.image = image;
}
-(void)CameraTakePhoto:(UIImage *)image{
    //paizhao的回调
    NSLog(@"--paizhao---%@",image);
    self.imageV.image = image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
