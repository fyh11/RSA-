//
//  ViewController.m
//  RSA加密&验签
//
//  Created by 樊义红 on 17/4/1.
//  Copyright © 2017年 樊义红. All rights reserved.
//

#import "ViewController.h"
#import "XYRSACryption.h"
#import "Macro.h"
#import "NSData+Extensiono.h"

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSData *signedData;
@property (nonatomic, strong) NSData *enData;
@property(nonatomic, strong) XYRSACryption *rsa ;
@property (weak, nonatomic) IBOutlet UIButton *encryption;
@property (weak, nonatomic) IBOutlet UIButton *decryption;
@property (weak, nonatomic) IBOutlet UIButton *signal;
@property (weak, nonatomic) IBOutlet UIButton *vertify;
@property (weak, nonatomic) IBOutlet UITextField *decryprotionText;
@property (weak, nonatomic) IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet UITextField *encryptionText;
@property (weak, nonatomic) IBOutlet UITextField *signalText;
@property (weak, nonatomic) IBOutlet UITextField *result;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XYRSACryption *rsa = [XYRSACryption new];
    _rsa = rsa;
    
    // 加载公钥
    NSString *derPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"public_key" ofType:@"der"];
    [_rsa loadPublicKeyFromFile:derPath];
    
    // 加载私钥
    NSString *p12Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"private_key" ofType:@"p12"];
    [_rsa loadPrivateKeyFromFile:p12Path password:@"123456"];

}

- (IBAction)cryption:(UIButton *)sender {
    if (sender == _encryption){
        
        NSString *enStr = _text.text;
        if (enStr.length == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入要加密的文本内容" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [_text becomeFirstResponder];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        // 加密后的数据
        NSData *enData = [_rsa rsaEncryptData:
                          [enStr dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *enDataUTF = [enData UTF8Data];
        _enData = enData;
        NSString *proStr = [[NSString alloc] initWithData:enDataUTF encoding:NSUTF8StringEncoding];
//        NSString *proStr = [self stringWithData:enData];
        _encryptionText.text = proStr;
        
    } else if(sender == _decryption){
        // 解密后的数据
        NSData *deData = [_rsa rsaDecryptData:_enData];
        NSString *deStr = [self stringWithData:deData];
        _decryprotionText.text = deStr;
    
    } else if(sender == _signal){
        // 签名
        NSData *signedData = [_rsa sha256WithRSA:_enData];
        _signedData = signedData;
        NSData *signalDataUTF = [signedData UTF8Data];
        NSString *signedString = [self stringWithData:signalDataUTF];
        _signalText.text = signedString;
        
    } else if(sender == _vertify){
        // 对前面进行验证
        BOOL result = [_rsa rsaSHA256VertifyingData:_enData withSignature:_signedData];
        if (result) {
            _result.text = @"验签成功";
        }else{
            _result.text = @"验签失败";
        }

    }
}

- (NSString *)stringWithData: (NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}


#pragma mark --- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end
