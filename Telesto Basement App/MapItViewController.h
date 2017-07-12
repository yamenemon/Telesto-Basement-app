//
//  MapItViewController.h
//  Telesto Basement App
//
//  Created by CSM on 6/15/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class CustomerInfoObject;
@interface MapItViewController : UIViewController<MKMapViewDelegate> {
    MKMapView *mapView;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CustomerInfoObject *customInfoObject;
@end
