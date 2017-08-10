//
//  CameraBeautyViewController.m
//  ZTBCamera
//
//  Created by Tibin Zhang on 2017/5/27.
//  Copyright © 2017年 Xueshan Financial Information Service Co., Ltd. All rights reserved.
//

#import "CameraBeautyViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "YBPopupMenu.h"

#define TITLES @[@"开启", @"自动", @"禁用"]
#define ICONS @[@"camera_flash_open_normal", @"camera_flash_automatic_normal", @"camera_flash_close_normal"]

@interface CameraBeautyViewController () <UIGestureRecognizerDelegate, YBPopupMenuDelegate>

@property (nonatomic, strong) UIView *topHandlerView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *reversalButton;//前后摄像头翻转
@property (nonatomic, strong) UIButton *flashModelButton;//闪光灯
@property (nonatomic, strong) UIButton *whiteBalanceButton;//补光
@property (nonatomic, strong) UIButton *tailorButton;//裁剪

@property (nonatomic, assign) BeautyHandleType handleType;
@property (nonatomic, assign) AVCaptureDevicePosition cameraPosition;//相机前后置摄像头
@property (nonatomic, assign) AVCaptureWhiteBalanceMode whiteBalanceMode;//白平衡

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic) BOOL isPlayerEnd;
@property (nonatomic, assign) NSInteger runLoopCount;
@property (nonatomic, assign) CGPoint touchPoint;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *captureStillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property(nonatomic,assign)CGFloat beginGestureScale;//记录开始的缩放比例
@property(nonatomic,assign)CGFloat effectiveScale;//最后的缩放比例

@property (nonatomic, strong) UIButton *photographButton;//拍照

@end

@implementation CameraBeautyViewController

- (UIView *)topHandlerView
{
    if (!_topHandlerView) {
        _topHandlerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
        _topHandlerView.backgroundColor = [UIColor clearColor];
    }
    return _topHandlerView;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(5, 2, 40, 40);
        [_backButton setBackgroundImage:[UIImage imageNamed:@"common_back_rect"] forState:UIControlStateNormal];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"common_back_rect"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(leftBackButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)reversalButton
{
    if (!_reversalButton) {
        _reversalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reversalButton.frame = CGRectMake(self.view.frame.size.width - 45, 10, 24, 24);
        [_reversalButton setBackgroundImage:[UIImage imageNamed:@"btn_camera_reserval"] forState:UIControlStateNormal];
        [_reversalButton setBackgroundImage:[UIImage imageNamed:@"btn_camera_reserval"] forState:UIControlStateHighlighted];
        [_reversalButton addTarget:self action:@selector(reversalButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reversalButton;
}

- (UIButton *)flashModelButton
{
    if (!_flashModelButton) {
        _flashModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashModelButton.frame = CGRectMake(self.view.frame.size.width - 95, 9, 26, 26);
        [_flashModelButton setBackgroundImage:[UIImage imageNamed:@"camera_flash_automatic_normal"] forState:UIControlStateNormal];
        [_flashModelButton setBackgroundImage:[UIImage imageNamed:@"camera_flash_automatic_normal"] forState:UIControlStateHighlighted];
        [_flashModelButton addTarget:self action:@selector(flashModelButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashModelButton;
}

- (UIButton *)whiteBalanceButton
{
    if (!_whiteBalanceButton) {
        _whiteBalanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _whiteBalanceButton.frame = CGRectMake(self.view.frame.size.width - 140, 9, 26, 26);
        [_whiteBalanceButton setBackgroundImage:[UIImage imageNamed:@"camera_light_automatic_normal"] forState:UIControlStateNormal];
        [_whiteBalanceButton setBackgroundImage:[UIImage imageNamed:@"camera_light_automatic_normal"] forState:UIControlStateHighlighted];
        [_whiteBalanceButton addTarget:self action:@selector(whiteBalanceButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _whiteBalanceButton;
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshView:)];
    }
    return _displayLink;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAVCaptureSession];
    _cameraPosition = AVCaptureDevicePositionFront;
    [self initHandlerView];
    [self setUpGesture];
    [self initTouchFocusView];
    _effectiveScale = _beginGestureScale = 1.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (self.captureSession) {
        [self.captureSession startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}

- (void)initHandlerView
{
    [self.view addSubview:self.topHandlerView];
    [_topHandlerView addSubview:self.backButton];
    [_topHandlerView addSubview:self.reversalButton];
    [_topHandlerView addSubview:self.flashModelButton];
    [_topHandlerView addSubview:self.whiteBalanceButton];
    
    self.photographButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _photographButton.frame = CGRectMake(self.view.frame.size.width/2 - 42, self.view.frame.size.height - 90, 84, 84);
    [_photographButton setBackgroundImage:[UIImage imageNamed:@"camera_photograph_nor"] forState:UIControlStateNormal];
    [_photographButton setBackgroundImage:[UIImage imageNamed:@"camera_photograph_pre"] forState:UIControlStateHighlighted];
    [_photographButton addTarget:self action:@selector(photographButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_photographButton];
    
}

- (void)initAVCaptureSession
{
    self.captureSession = [[AVCaptureSession alloc] init];
    NSError *error = nil;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags =NSKeyValueObservingOptionNew;
    [captureDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [captureDevice lockForConfiguration:nil];
    //设置闪光灯为自动
    [captureDevice setFlashMode:AVCaptureFlashModeAuto];
    [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
    [captureDevice unlockForConfiguration];
    
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    
    self.captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.captureStillImageOutput setOutputSettings:outputSettings];
    
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        [self.captureSession addInput:self.captureDeviceInput];
    }
    if ([self.captureSession canAddOutput:self.captureStillImageOutput]) {
        [self.captureSession addOutput:self.captureStillImageOutput];
    }
    
    // 预览图层
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    self.captureVideoPreviewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.view.layer.masksToBounds = YES;
    [self.view.layer addSublayer:self.captureVideoPreviewLayer];
    
}

- (void)initTouchFocusView
{
    if (self.isPlayerEnd) {
        CGFloat rectValue = 60 - self.runLoopCount % 60;
        CGRect rectangle = CGRectMake(self.touchPoint.x - rectValue / 2.0, self.touchPoint.y - rectValue / 2.0, rectValue, rectValue);
        //获得上下文句柄
        NSLog(@"$$$$$$$ (%.1f, %.1f, %.1f, %.1f)", rectangle.origin.x, rectangle.origin.y, rectangle.size.width, rectangle.size.height);
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        if (rectValue <= 30) {
            self.isPlayerEnd = NO;
            [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            self.displayLink = nil;
            self.runLoopCount = 0;
            CGContextClearRect(currentContext, rectangle);
        } else {
            //创建图形路径句柄
            CGMutablePathRef path = CGPathCreateMutable();
            //设置矩形的边界
            //添加矩形到路径中
            CGPathAddRect(path,NULL, rectangle);
            //添加路径到上下文中
            CGContextAddPath(currentContext, path);
            //    //填充颜色
            [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:0] setFill];
            //设置画笔颜色
            [[UIColor redColor] setStroke];
            //设置边框线条宽度
            CGContextSetLineWidth(currentContext,1.0f);
            //画图
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            /* 释放路径 */
            CGPathRelease(path);
        }
    }
}

- (void)focusAction
{
    // 当设置完成之后，需要回调到上面那个方法⬆️
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        // 触摸屏幕的坐标点需要转换成0-1，设置聚焦点
        CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:self.touchPoint];
        /*****必须先设定聚焦位置，在设定聚焦方式******/
        //聚焦点的位置
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:cameraPoint];
        }
        // 聚焦模式
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        } else {
            NSLog(@"聚焦模式修改失败");
        }
        //曝光点的位置
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:cameraPoint];
        }
        //曝光模式
        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }else{
            NSLog(@"曝光模式修改失败");
        }
        // 防止点击一次，多次聚焦，会连续拍多张照片
//        self.canTakePicture = YES;
    }];
}

//更改设备属性前一定要锁上
-(void)changeDevicePropertySafety:(void (^)(AVCaptureDevice *captureDevice))propertyChange{
    //也可以直接用_videoDevice,但是下面这种更好
    AVCaptureDevice *captureDevice= [_captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁,意义是---进行修改期间,先锁定,防止多处同时修改
    BOOL lockAcquired = [captureDevice lockForConfiguration:&error];
    if (!lockAcquired) {
        NSLog(@"锁定设备过程error，错误信息：%@",error.localizedDescription);
    }else{
        [self.captureVideoPreviewLayer.session beginConfiguration];
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
        [self.captureVideoPreviewLayer.session commitConfiguration];
    }
}

- (void)refreshView:(CADisplayLink *) link{
    [self initTouchFocusView];
    self.runLoopCount++;
}

#pragma mark - 摄像头反转
- (void)reversalButtonDidClick:(id)sender
{
    ZTBLog(@"== 反转 ==");
    _handleType = BeautyHandleTypeCameraReverse;
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == _cameraPosition) {
            [self.captureVideoPreviewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.captureVideoPreviewLayer.session.inputs) {
                [[self.captureVideoPreviewLayer session] removeInput:oldInput];
            }
            [self.captureVideoPreviewLayer.session addInput:input];
            [self.captureVideoPreviewLayer.session commitConfiguration];
            break;
        }
    }
    if (_cameraPosition == AVCaptureDevicePositionFront){
        _cameraPosition = AVCaptureDevicePositionBack;
    } else {
        _cameraPosition = AVCaptureDevicePositionFront;
    }
}

#pragma mark - 闪光灯模式
- (void)flashModelButtonDidClick:(id)sender
{
    ZTBLog(@"== 闪光灯模式 ==");
    _handleType = BeautyHandleTypeFlashModel;
    [YBPopupMenu showRelyOnView:sender titles:TITLES icons:ICONS menuWidth:85 delegate:self];
}

#pragma mark - 白平衡
- (void)whiteBalanceButtonDidClick:(id)sender
{
    _handleType = BeautyHandleTypeWhiteBalance;
    [YBPopupMenu showRelyOnView:sender titles:@[@"持续", @"自动", @"禁用"] icons:@[@"camera_light_on_normal", @"camera_light_automatic_normal", @"camera_light_off_normal"] menuWidth:85 delegate:self];
}

- (void)photographButtonDidClick:(id)sender
{
    AVCaptureConnection *stillImageConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无相册权限"
                                                           message:nil
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        
//        ALAssetsLibrary *customLibrary = [[ALAssetsLibrary alloc] init];//存储到自定义相册
//        [customLibrary addAssetsGroupAlbumWithName:@"希小希" resultBlock:^(ALAssetsGroup *group) {
//            //创建相簿成功
//        } failureBlock:^(NSError *error) {
//        }];
        
//        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
//                                                                    imageDataSampleBuffer,
//                                                                    kCMAttachmentMode_ShouldPropagate);
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];//存储到系统相册
//        [customLibrary writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
//        }];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:[UIImage imageWithData:jpegData] toAlbum:@"希小希" completion:^(NSURL *assetURL, NSError *error) {
        } failure:^(NSError *error) {
        }];
        
    }];
}

- (void)setUpGesture
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinGesture
{
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [pinGesture numberOfTouches];
    for (NSInteger i = 0; i < numTouches; ++i ) {
        CGPoint location = [pinGesture locationOfTouch:i inView:self.view];
        CGPoint convertedLocation = [self.captureVideoPreviewLayer convertPoint:location fromLayer:self.captureVideoPreviewLayer.superlayer];
        if (![self.captureVideoPreviewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    if (allTouchesAreOnThePreviewLayer) {
        self.effectiveScale = self.beginGestureScale * pinGesture.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,pinGesture.scale);
        CGFloat maxScaleAndCropFactor = [[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > maxScaleAndCropFactor) {
            self.effectiveScale = maxScaleAndCropFactor;
        }
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
    }
}

#pragma mark - 闪光灯
- (void)flashModelStatus:(AVCaptureFlashMode)status
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash]) {
        if (status == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOff;
        }
        else if (status == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeOn;
        }
        else if (status == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeAuto;
        }
    } else {
        NSLog(@"设备不支持闪光灯");
    }
    [device unlockForConfiguration];
}

#pragma mark - 白平衡
- (void)whiteBalanceModelStatus:(AVCaptureWhiteBalanceMode)status
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    NSError *error = nil;
    if ([device lockForConfiguration:&error]) {
        
    }
    if ([device hasFlash]) {
        if ((status == AVCaptureWhiteBalanceModeAutoWhiteBalance) && [device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            device.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
            NSLog(@"自动");
        }
        if (status == AVCaptureWhiteBalanceModeLocked && [device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeLocked]) {
            device.whiteBalanceMode = AVCaptureWhiteBalanceModeLocked;
            NSLog(@"禁用");
        }
        if (status == AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance && [device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
            NSLog(@"持续");
        }
    } else {
        NSLog(@"设备不支持闪光灯");
    }
    [device unlockForConfiguration];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        result = AVCaptureVideoOrientationLandscapeRight;
    }
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
        result = AVCaptureVideoOrientationLandscapeLeft;
    }
    return result;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    ZTBLog(@"点击了 %@ 选项",TITLES[index]);
    switch (index) {
        case 0:
        {
            if (_handleType == BeautyHandleTypeFlashModel) {
                [self flashModelStatus:AVCaptureFlashModeOn];
                [_flashModelButton setBackgroundImage:[UIImage imageNamed:@"camera_flash_open_normal"] forState:UIControlStateNormal];
                [_flashModelButton setBackgroundImage:[UIImage imageNamed:@"camera_flash_open_normal"] forState:UIControlStateHighlighted];
            }
            else if (_handleType == BeautyHandleTypeWhiteBalance) {
                [_whiteBalanceButton setBackgroundImage:[UIImage imageNamed:@"camera_light_on_normal"] forState:UIControlStateNormal];
                [_whiteBalanceButton setBackgroundImage:[UIImage imageNamed:@"camera_light_on_normal"] forState:UIControlStateHighlighted];
                [self whiteBalanceModelStatus:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            }
        }
            break;
            
        case 1:
        {
            if (_handleType == BeautyHandleTypeFlashModel) {
                [self flashModelStatus:AVCaptureFlashModeAuto];
                [_flashModelButton setBackgroundImage:[UIImage imageNamed:@"camera_flash_automatic_normal"] forState:UIControlStateNormal];
                [_flashModelButton setBackgroundImage:[UIImage imageNamed:@"camera_flash_automatic_normal"] forState:UIControlStateHighlighted];
            }
            else if (_handleType == BeautyHandleTypeWhiteBalance) {
                [self whiteBalanceModelStatus:AVCaptureWhiteBalanceModeAutoWhiteBalance];
                [_whiteBalanceButton setBackgroundImage:[UIImage imageNamed:@"camera_light_automatic_normal"] forState:UIControlStateNormal];
                [_whiteBalanceButton setBackgroundImage:[UIImage imageNamed:@"camera_light_automatic_normal"] forState:UIControlStateHighlighted];
            }
        }
            break;
            
        case 2:
        {
            if (_handleType == BeautyHandleTypeFlashModel) {
                [self flashModelStatus:AVCaptureFlashModeOff];
                [_flashModelButton setBackgroundImage:[UIImage imageNamed:@"camera_flash_close_normal"] forState:UIControlStateNormal];
                [_flashModelButton setBackgroundImage:[UIImage imageNamed:@"camera_flash_close_normal"] forState:UIControlStateHighlighted];
            }
            else if (_handleType == BeautyHandleTypeWhiteBalance) {
                [_whiteBalanceButton setBackgroundImage:[UIImage imageNamed:@"camera_light_off_normal"] forState:UIControlStateNormal];
                [_whiteBalanceButton setBackgroundImage:[UIImage imageNamed:@"camera_light_off_normal"] forState:UIControlStateHighlighted];
                [self whiteBalanceModelStatus:AVCaptureWhiteBalanceModeLocked];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    ZTBLog(@"------(%.1f, %.1f)------", point.x, point.y);
    if (self.isPlayerEnd)
        return;
    self.isPlayerEnd = YES;
    self.touchPoint = point;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self focusAction];
    
}

// 监听焦距发生改变
-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    
    if([keyPath isEqualToString:@"adjustingFocus"]){
        BOOL adjustingFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
        
        NSLog(@"adjustingFocus~~%d  change~~%@", adjustingFocus, change);
        // 0代表焦距不发生改变 1代表焦距改变
        if (adjustingFocus == 0) {
            
            // 判断图片的限制个数
//            if ((self.images.count == 1 && self.cameraType == ZLCameraSingle) || !self.GraphRecognition || !self.canTakePicture) {
//                return;
//            }
            
            // 点击一次可能会聚一次焦，也有可能会聚两次焦。一次聚焦，图像清晰。如果聚两次焦，照片会在第二次没有聚焦完成拍照，应为第一次聚焦完成会触发拍照，而拍照时间在第二次未聚焦完成，图像不清晰。增加延时可以让每次都是聚焦完成的时间点
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSThread sleepForTimeInterval:0.2];
                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [self stillImage:nil];
                });
            });
        }
        
    }
}

- (void)dealloc
{
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
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
