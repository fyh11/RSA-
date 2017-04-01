//
//  ViewController.m
//  RSA加密&验签
//
//  Created by 樊义红 on 17/4/1.
//  Copyright © 2017年 樊义红. All rights reserved.
//

#import "ViewController.h"
#import "XYRSACryption.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.\
    
    
    [self test];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test
{
    
    XYRSACryption *_rsa = [XYRSACryption new];
    // 加载公钥
    NSString *derPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"public_key" ofType:@"der"];
    [_rsa loadPublicKeyFromFile:derPath];
    
    // 加载私钥
    NSString *p12Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"private_key" ofType:@"p12"];
    [_rsa loadPrivateKeyFromFile:p12Path password:@"123456"];
    
    NSString *enStr = @"请替换为你要加密的文本内容！";
    
    // 加密后的数据
    NSData *enData = [_rsa rsaEncryptData:
                      [enStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *proStr = [[NSString alloc] initWithData:enData encoding:NSUTF8StringEncoding];
    
    // 解密后的数据
    NSData *deData = [_rsa rsaDecryptData:enData];
    NSString *deStr = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
   
    
    // 签名
    NSData *signedData = [_rsa sha256WithRSA:enData];
    
    // 对前面进行验证
    BOOL result = [_rsa rsaSHA256VertifyingData:enData withSignature:signedData];
    
    

}


@end
