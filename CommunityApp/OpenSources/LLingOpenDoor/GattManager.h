//
//  GattManager.h
//  BlueDemo
//
//  Created by mac on 14-7-15.
//  Copyright (c) 2014年 izhihuicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreMotion/CoreMotion.h>
#import "ScannerDelegate.h"

//#define SERVICE_UUID 0xFFE0
//#define CHAR_UUID    0xFFE1

//#define SERVICE_UUID 0xFEE7
//#define CHAR_UUID_W    0xFEC7
//#define CHAR_UUID_N   0xFEC8
#define Target_Name    @"RUANTEST"
#define TestString     @"12345678"

#define TranslateDataLenght   8

@protocol GattBLEDelegate <NSObject>

-(void)getBleSearchAnswer:(int)result resultString:(NSString *)str26;

@end


/**
 *  BLE 蓝牙处理类
 */
@interface GattManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate,GattBLEDelegate,ScannerDelegate>
{
    //连接等待次数
    int connectCounts;
    NSMutableArray *bleNameArray;
    int bleSearchCounts;
    int bleFlag;
    NSTimer *bleNameTimer;
    float bleNameTimerCount;
    CBUUID *service_uuid;
    CBUUID *char_uuid_w;
    CBUUID *char_uuid_n;
    
}


///中央端
@property(strong,nonatomic) CBCentralManager *centrelManager;
///外设端
@property(strong,nonatomic) CBPeripheral *targetPeripheral;
///发送给外设端的数据
@property(strong,nonatomic) NSData *postData;

@property(strong,nonatomic) NSMutableData *revicedData;
@property(strong, nonatomic) NSMutableData *receivedWeiData;

@property(strong,nonatomic) NSString *gattUserInfo;
@property(strong,nonatomic) NSString *gattUserFID;
@property(strong,nonatomic) NSArray *gattUserInfoArray;
@property(strong,nonatomic) NSArray *gattUserFIDArray;
@property(strong,nonatomic) NSArray *gattUserKeyArray;
@property(strong,nonatomic) NSString *gattOpenKeyString;

@property(assign,nonatomic) id<GattBLEDelegate> delegate;

@property(strong,nonatomic)CMMotionManager*motionManager;

@property(nonatomic, strong) NSArray *allInfo;

///扫描次数
@property(assign,nonatomic) int countScan;
///发现服务失败次数
@property(assign,nonatomic) int serverAgain;
///发现特性失败次数
@property(assign,nonatomic) int charAgain;
///设置更新失败
@property(assign,nonatomic) int updateAgain;
///获得数据次数
@property(assign,nonatomic) int recDataCount;
///发现服务或特性失败后是否重连
@property(assign,nonatomic) BOOL isConnectAgain;
///添加数据的标志
@property(assign,nonatomic) BOOL tagAddData;
//微信包数据标志
@property(assign,nonatomic) BOOL tagWeiData;
//随机数
@property(assign,nonatomic) UInt32 randomData;
//FID位置
@property(assign,nonatomic) int fidCount;


///将标志设置为初始值
-(void)setFlagDefault;

///创建中央端
-(void) setUp;

///中央端扫描外围
-(void) scan:(int)count;
///中央端停止扫描外围
-(void) stopScan;

///传输数据至外设端
-(void) write:(CBPeripheral *)peripheral data:(NSData *)data;
///读取数据
//-(void) read:(CBPeripheral *)peripheral;
///打印外设端的信息
- (void) printPeripheralInfo:(CBPeripheral*)peripheral;


-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on;

-(UInt16) swap:(UInt16)s;

-(CBService *) findServiceFromUUIDEx:(CBUUID *)UUID p:(CBPeripheral *)p;
-(CBCharacteristic *) findCharacteristicFromUUIDEx:(CBUUID *)UUID service:(CBService*)service;
-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data;
-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p;
-(void) notify:(CBPeripheral *)peripheral on:(BOOL)isOn;
//-(id)initWithCode:(NSCoder*)aDecoder;
-(NSString *)getOpenKey;

@end
