//
//  PQAPI.h
//  PQAPI
//
//  Created by Mac on 2021/12/13.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void (^PQDidOpenedPrinterBlock)(BOOL isSuccess);

@interface PQAPI : NSObject


/**
 * @brief   Start searching for Bluetooth devices.
 */
+ (void)openScan;

/**
 * @brief   Get the list of Bluetooth found.
 */
+ (NSArray<CBPeripheral *> *)getDiscoveredPeripherals;
/**
 * @brief   Connect to a printer with the specified name.
 *
 * @param   printerName     Printer Bluetooth name.
 * @param   completion      Operation after connecting the printer.
 *
 * @note    isSuccess       Whether the printer is successfully connected.
 */
+ (void)openPrinterWithName:(NSString *)printerName completion:(PQDidOpenedPrinterBlock)completion;

/**
 * @brief   Connect the specified peripheral.
 *
 * @param   peripheral      Printer Bluetooth peripherals.
 * @param   completion      Operation after connecting the printer.
 *
 * @note    isSuccess       Whether the printer is successfully connected.
 */
+ (void)openPrinterWithPeripheral:(CBPeripheral *)peripheral completion:(PQDidOpenedPrinterBlock)completion;

/**
 * @brief   Gets the name of the currently connected printer.
 */
+ (NSString *)getConnectingPrinterName;

/**
 * @brief   Turn off the currently connected printer.
 */
+ (void)closePrinter;
/**
 * @brief   Connect the specified peripheral.
 
 * @param   discovered      When scanning Bluetooth devices, the callback of Bluetooth peripherals is found.

 */
+ (void)discoveredPeripheralBlock:(void(^)(void))discovered;

/**
 * @brief  Refresh search to Bluetooth peripherals
 */
+ (void)refreshDiscoveredPeripheral;

/**
 * @brief   Print pictures directly.
 *
 * @param   image          Printed pictures
 * @param   width          Print width in mm
 * @param   height         Print height in mm
 * @param   completion     Print result callback
 *
 * @note    isSuccess       Whether the printer is successfully connected.
 */
+ (void)printImage:(UIImage *)image width:(NSInteger)width height:(NSInteger)height completion:(void(^)(BOOL isSuccess))completion;

/**
 * @brief   Enable the progress prompt box.
 */
+ (void)enableProgress:(BOOL)enable;


/**
 * @brief   Enable prompt callback.
 *
 
 0x30    Printer device disconnected
 0x31    Failed to connect printer device
 * 
 0x50    printer out of paper
 0x51    The printer cover is open 
 0x52    Print data error
 0x53    Printer power is too low

 *
 */
+ (void)didReadPrinterStateHandler:(void(^)(int code, NSString *message))didReadPrinterStateHandler;

@end
