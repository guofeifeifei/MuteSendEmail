//
//  ViewController.m
//  AddressBook
//
//  Created by ZZCN77 on 2017/11/27.
//  Copyright © 2017年 ZZCN77. All rights reserved.
//

#import "ViewController.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@interface ViewController ()<SKPSMTPMessageDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
     [self loadData];
   
}




- (void)loadData {
    /*
     邮箱号和SMTP的授权码是我自己编的，需要换成你们的
     */
    SKPSMTPMessage *myMessage = [[SKPSMTPMessage alloc] init];
    //发信人
    myMessage.fromEmail=@"123567@163.com";
    //收件人
    myMessage.toEmail=@"987687@qq.com";
    //bccEmail、ccEmail可传可不传，如果需要的填写
//    myMessage.bccEmail=@"123567@163.com";//暗抄送
//    myMessage.ccEmail = @"123567@163.com";//抄送人
    //发送邮件代理服务器
   // myMessage.relayHost=@"smtp.qq.com";//qq个人
//    myMessage.relayHost=@"smtp.exmail.qq.com";qq企业账号

    myMessage.relayHost=@"smtp.163.com";
    myMessage.requiresAuth=YES;//验证身份是否登录
    if (myMessage.requiresAuth) {
        //发信人
        myMessage.login=@"123567@163.com"; //发信人账号
        myMessage.pass=@"sgj2222dsssww";//发信人的SMTP的授权码
    }
    myMessage.wantsSecure =YES; //需要加密
    /*
     163邮箱报错的
     S: 554 DT:SPM 163 smtp9,DcCowADXPVEoF_FaG5peAg--.47217S3 1525749544,please see http://mail.163.com/help/help_spam_16.htm?ip=125.118.133.189&hostid=smtp9&time=1525749544
     重新修改subject内容
     */
    myMessage.subject = @"你的第一封信";//// 设置邮件主题
    myMessage.delegate = self;// 设置邮件代理
    //设置邮件内容
    NSString *sendMessageStr = @"hello,您好！";
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain; charset=UTF-8",kSKPSMTPPartContentTypeKey,
                               sendMessageStr,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    
    myMessage.parts = [NSArray arrayWithObjects:plainPart,nil];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //发送
        [myMessage send];
    });
  
    
}


- (void)messageSent:(SKPSMTPMessage *)message
{
    NSLog(@"邮件发送成功");
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    NSLog(@"不好意思,邮件发送失败%@",error);

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
