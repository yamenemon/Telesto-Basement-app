//
//  MapItViewController.m
//  Telesto Basement App
//
//  Created by CSM on 6/15/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "MapItViewController.h"
#import "CustomerInfoObject.h"

@interface MapItViewController ()

@end

@implementation MapItViewController
@synthesize customInfoObject;
@synthesize mapView;
- (void)viewDidLoad {
    // AIzaSyB4I45UeOkUSSvnW070-1GFEf0THZjvZn0
    [super viewDidLoad];
//        [super viewDidLoad];
//        mapView = [[MKMapView alloc]
//                   initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
////        mapView.showsUserLocation = NO;
//        mapView.mapType = MKMapTypeStandard;
//        mapView.delegate = self;
//        [self.view addSubview:mapView];
    
}
-(void)viewWillAppear:(BOOL)animated{

    if( [self respondsToSelector:@selector(setEdgesForExtendedLayout:)] )
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self mapsDirections:nil];
}
- (void)mapsDirections:(id)sender {
    /*https://stackoverflow.com/questions/21983559/opens-apple-maps-app-from-ios-app-with-directions*/
    NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=35.6813023,139.7640529&daddr=35.4657901,139.6201192"];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: directionsURL]];
}
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
//    MKCoordinateRegion region;
//    MKCoordinateSpan span;
//    NSLog(@"Values: %f %f",[customInfoObject.latitude floatValue],[customInfoObject.longitude floatValue]);
//    span.latitudeDelta = 1;//[customInfoObject.latitude floatValue];
//    span.longitudeDelta = 1;//[customInfoObject.longitude floatValue];
//    CLLocationCoordinate2D location;
//    //37.276179,-104.6490397
//    location.latitude = [customInfoObject.latitude floatValue];//aUserLocation.coordinate.latitude;
//    location.longitude = [customInfoObject.longitude floatValue];//aUserLocation.coordinate.longitude;
//    region.span = span;
//    region.center = location;
//    [aMapView setRegion:region animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
