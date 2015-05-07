//
//  ViewController.m
//  ibeacon-client
//
//  Created by xdf on 5/5/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import "ViewController.h"
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"

#define MAX_DISTANCE 20
#define TOP_MARGIN   150

@interface ViewController () <ESTBeaconManagerDelegate>
@property (nonatomic) UILabel *descLabel;
@property (nonatomic, assign) ESTScanType scanType;
@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) NSArray *beaconsArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBeaconManager];
    [self initView];
}

- (void)initView {
    self.navigationItem.title = @"connect";
    [self initBeaconView];
}

-(void)initBeaconManager {
    self.scanType = ESTScanTypeBeacon;
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.returnAllRangedBeaconsAtOnce = YES;
    [self.beaconManager startRangingBeaconsInRegion: self.region];
    self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                      identifier:@"EstimoteSampleRegion"];
    [self startRangingBeacons];
    NSLog(@"startRangingBeacons");
}

-(void)startRangingBeacons {
    if ([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            /*
             * No need to explicitly request permission in iOS < 8, will happen automatically when starting ranging.
             */
            [self.beaconManager startRangingBeaconsInRegion:self.region];
        } else {
            /*
             * Request permission to use Location Services. (new in iOS 8)
             * We ask for "always" authorization so that the Notification Demo can benefit as well.
             * Also requires NSLocationAlwaysUsageDescription in Info.plist file.
             *
             * For more details about the new Location Services authorization model refer to:
             * https://community.estimote.com/hc/en-us/articles/203393036-Estimote-SDK-and-iOS-8-Location-Services
             */
            [self.beaconManager requestAlwaysAuthorization];
        }
    } else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        [self.beaconManager startRangingBeaconsInRegion:self.region];
    } else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Denied"
                                                        message:@"You have denied access to location services. Change this in app settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    } else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Not Available"
                                                        message:@"You have no access to location services."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {
    self.beaconsArray = beacons;
    
    ESTBeacon *beacon = [self.beaconsArray objectAtIndex: 0];
    [self updateBeaconView: beacon.major :beacon.minor :beacon.distance];
}

- (void)initBeaconView {
    NSInteger labelHeight = 100;
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - labelHeight) / 2, self.view.frame.size.width, labelHeight)];
    self.descLabel.text = @"disconnect";
    self.descLabel.numberOfLines = 2;
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel.font = [self.descLabel.font fontWithSize:16];
    self.descLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:.6];
    [self.view addSubview: self.descLabel];
}

- (void)updateBeaconView: (NSNumber *)major :(NSNumber *)minor :(NSNumber *)distance {
    self.descLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@\nDistance: %.2f", major, minor, [distance floatValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
