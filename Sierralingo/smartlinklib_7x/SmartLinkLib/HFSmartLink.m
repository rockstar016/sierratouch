//
//  HFSmartLink.m
//  SmartlinkLib
//
//  Created by wangmeng on 15/3/16.
//  Copyright (c) 2015年 HF. All rights reserved.
//

#import "HFSmartLink.h"
#import "Udpproxy.h"
#include "hf-pmk-generator.h"

#define SMTV30_BASELEN      76
#define SMTV30_STARTCODE      '\r'
#define SMTV30_STOPCODE       '\n'



@implementation HFSmartLink{
    SmartLinkProcessBlock processBlock;
    SmartLinkSuccessBlock successBlock;
    SmartLinkFailBlock failBlock;
    SmartLinkStopBlock stopBlock;
    SmartLinkEndblock endBlock;
    NSString * pswd;
    char cont[200];
    int cont_len;
    BOOL isconnnecting;
    BOOL userStoping;
    NSInteger sendTime;
    NSMutableDictionary *deviceDic;
    Udpproxy * udp;
    BOOL withV3x;
}

+(instancetype)shareInstence{
    static HFSmartLink * me = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
         me = [[HFSmartLink alloc]init];
    });
    return me;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /**
         *  初始化 套接字
         */
//        [UdpProxy shaInstence];
        udp = [Udpproxy shareInstence];
        deviceDic = [[NSMutableDictionary alloc]init];
        self.isConfigOneDevice = true;
        self.waitTimers = 30;//15;
        withV3x=true;
    }
    return self;
}

- (int)getStringLen:(NSString*)str
{
    int strlen=0;
    char *p=(char *)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0;i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];i++)
    {
        if (*p)
        {
            p++;
            strlen++;
        }
        else
        {
            p++;
        }
    }
    return strlen;
}

-(void)startWithSSID:(NSString*)ssidStr Key:(NSString*)pswdStr withV3x:(BOOL)v3x processblock:(SmartLinkProcessBlock)pblock successBlock:(SmartLinkSuccessBlock)sblock failBlock:(SmartLinkFailBlock)fblock endBlock:(SmartLinkEndblock)eblock

{
    NSLog(@"to send...");
    withV3x=v3x;
    if(udp){
        [udp CreateBindSocket];
    }else{
        udp = [Udpproxy shareInstence];
        [udp CreateBindSocket];
    }

    int ssidLen=[self getStringLen:ssidStr];
    int pswdLen=[self getStringLen:pswdStr];
    
    unsigned char buf[33];
    memset(buf, 0, 33);
    pbkdf2_sha1([pswdStr UTF8String], [ssidStr UTF8String], ssidLen, 4096, buf, 32);
    
    char contC[200];
    int contC_len=0;
    memset(contC,0,200);
    contC[contC_len++]=[self getStringLen:ssidStr];//[ssidStr length];
    contC[contC_len++]=[self getStringLen:pswdStr];//[pswdStr length];
    if (pswdLen!=0)
        contC[contC_len++]=32;
    else
        contC[contC_len++]=0;
    contC[contC_len++]=0;
    sprintf(&(contC[contC_len]), "%s", [ssidStr UTF8String]);
    contC_len+=ssidLen;//[ssidStr length];
    sprintf(&(contC[contC_len]), "%s", [pswdStr UTF8String]);
    contC_len+=pswdLen;//[pswdStr length];
    if (pswdLen/*[pswdStr length]*/!=0)
    {
        memcpy(&(contC[contC_len]), buf, 32);
        contC_len+=32;
    }
    
    if (contC_len % 2!=0){
        contC_len++;
    }
    
    pswd=pswdStr;
    memcpy(cont, contC, contC_len);
    cont_len=contC_len;
    // print content
    NSLog(@"***To Print Content***");
    char output[500];
    memset(output, 0, 500);
    for (int i=0;i<cont_len;i++){
        sprintf(output, "%s %X", output, (unsigned char)cont[i]);
    }
    NSLog(@"%s", output);
    processBlock = pblock;
    successBlock = sblock;
    failBlock = fblock;
    endBlock = eblock;
    sendTime = 0;
    userStoping = false;
    [deviceDic removeAllObjects];
    if(isconnnecting){
        failBlock(@"is connecting ,please stop frist!");
        return ;
    }
    isconnnecting = true;
    //开始配置线程
    [[[NSOperationQueue alloc]init]addOperationWithBlock:^(){
        [self connectV70];
    }];
    
    [[[NSOperationQueue alloc]init]addOperationWithBlock:^(){
        [self doProcess];
    }];
}

- (void)doProcess
{
    NSLog(@"start waitting module msg ");
    NSInteger waitCount = 0;
    while (waitCount < self.waitTimers&&isconnnecting) {
        [udp sendSmartLinkFind];
        sleep(1);
        waitCount++;
        NSLog(@"waitCount=%ld", (long)waitCount);
        processBlock(waitCount*100/self.waitTimers);
    }
    isconnnecting = false;
}

-(void)stopWithBlock:(SmartLinkStopBlock)block{
    stopBlock = block;
    isconnnecting = false;
    userStoping = true;
}
-(void)closeWithBlock:(SmartLinkCloseBlock)block{
    if(isconnnecting){
        dispatch_async(dispatch_get_main_queue(), ^(){
            block(@"please stop connect frist",false);
        });
    }
    
    if(udp){
        [udp close];
        dispatch_async(dispatch_get_main_queue(), ^(){
            block(@"close Ok",true);
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(){
            block(@"udp sock is Closed,on need Close more",false);
        });
    }
}

#pragma Send and Rcv
-(void)connectV70{
    //开始接收线程
    [[[NSOperationQueue alloc]init]addOperationWithBlock:^(){
        NSLog(@"start recv");
        [self recvNewModule];
    }];

    int flyTime=0;      // unit:10ms
    while (isconnnecting) {
        char cip[20];
        char c[100];
        memset(c, 0, 100);
        int sn=0;
        
        for (int i=0;i<sn+30;i++){
            c[i]='a';
        }
        
        for (int i=0;i<5;i++){
            [udp sendMCast:c withAddr:"239.48.0.0" andSN:0];
            usleep(10000);
            [self sendSmtlkV30:flyTime];
            flyTime++;
        }
        
        while (isconnnecting&&(sn*2<cont_len)) {
            memset(cip, 0, 20);
            sprintf(cip, "239.46.%d.%d",(unsigned char)cont[sn*2],(unsigned char)cont[sn*2+1]);
//            NSLog(@"%X %X", (unsigned char)cont[sn*2],(unsigned char)cont[sn*2+1]);
            [udp sendMCast:c withAddr:cip andSN:0];
            usleep(10000);
            [self sendSmtlkV30:flyTime];
            flyTime++;
            c[sn+30]='a';
            sn++;
        }

        for (int i=0;i<5;i++){
            usleep(10000);
            [self sendSmtlkV30:flyTime];
            flyTime++;
        }
        
//        if (isconnnecting){
//            sendTime++;
//            NSLog(@"send time %d",sendTime);
//            dispatch_async(dispatch_get_main_queue(), ^(){
//                processBlock(sendTime);
//            });
//        }
    }
}

- (void) sendSmtlkV30:(int)ft
{
    int pswdLen=[self getStringLen:pswd];
    if (withV3x==false)
        return;
    
    while (ft>= 200+(3+pswdLen+6)*5){
        ft-=200+(3+pswdLen+6)*5;
    }
    
    if (ft< 200){
        [self sendOnePackageByLen:SMTV30_BASELEN];
    }else if (ft % 5 == 0){
        int ft5=(ft-200)/5;
        if (ft5<3){
            [self sendOnePackageByLen:SMTV30_BASELEN+SMTV30_STARTCODE];
        }else if (ft5<3+pswdLen){
            int code=SMTV30_BASELEN+ [pswd characterAtIndex:(ft5-3)];
            [self sendOnePackageByLen:code];
            NSLog(@"code:%X", (unsigned char)[pswd characterAtIndex:(ft5-3)]);
        }else if (ft5<3+pswdLen+3){
            [self sendOnePackageByLen:SMTV30_BASELEN+SMTV30_STOPCODE];
        }else if (ft5< 3+pswdLen+6){
            [self sendOnePackageByLen:SMTV30_BASELEN+pswdLen+256];
        }
    }
}

-(void)sendOnePackageByLen:(NSInteger)len{
    char data[len+1];
    memset(data, 5, len);
    data[len]='\0';
    [udp send:data];
}
-(void)recvNewModule{
    while (isconnnecting) {
        HFSmartLinkDeviceInfo * dev = [udp recv];
        if(dev == nil){
            continue;
        }
        
        if([deviceDic objectForKey:dev.mac] != nil){
            continue;
        }

        [deviceDic setObject:dev forKey:dev.mac];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            successBlock(dev);
        });
        
        if (self.isConfigOneDevice) {
            NSLog(@"end config once");
            isconnnecting = false;
            dispatch_async(dispatch_get_main_queue(), ^(){
                endBlock(deviceDic);
            });
            [udp close];
            return ;
        }
    }
    
    if(userStoping){
        dispatch_async(dispatch_get_main_queue(), ^(){
            stopBlock(@"stop connect ok",true);
        });
    }
    
    if(deviceDic.count <= 0&&!userStoping){
        dispatch_async(dispatch_get_main_queue(), ^(){
            failBlock(@"smartLink fail ,no device is configed");
        });
    }
    
    [udp close];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        endBlock(deviceDic);
    });
}

@end
