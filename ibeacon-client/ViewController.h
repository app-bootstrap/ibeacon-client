//
//  ViewController.h
//  ibeacon-client
//
//  Created by xdf on 5/5/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeacon.h"

typedef enum : int {
    ESTScanTypeBluetooth,
    ESTScanTypeBeacon
    
} ESTScanType;

@interface ViewController : UIViewController

@end

