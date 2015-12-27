//
//  MaVue.h
//  ISouvenir
//
//  Created by m2sar on 27/11/2014.
//  Copyright (c) 2014 m2sar. All rights reserved.
//

#import "MaVue.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <coreLocation/CLLocationManagerDelegate.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MapKit/MapKit.h>
#import <MobileCoreServices/MobileCoreServices.h> // pour pouvoir acceder aux données


@interface MaVue : UIView <CLLocationManagerDelegate, MKMapViewDelegate,ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate , UIPopoverControllerDelegate,UIPickerViewDelegate>
@property (nonatomic,assign)UIViewController* mycontroller;


- (void) positionner:(CGSize) size;

@end
