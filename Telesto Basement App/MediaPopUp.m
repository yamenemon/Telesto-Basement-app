//
//  MediaPopUp.m
//  Telesto Basement App
//
//  Created by CSM on 6/7/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "MediaPopUp.h"
#import "CustomerRecordViewController.h"

@implementation MediaPopUp
@synthesize customerRecordVC;
@synthesize isFromBuildingMedia;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initialize{
    _mediaPopUpTable.delegate = self;
    _mediaPopUpTable.dataSource = self;
    _mediaPopUpTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    if (isFromBuildingMedia == YES){ return 2;}//4;    }
    else{ return 2; }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    if (isFromBuildingMedia == YES) {
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"GalleryIcon"];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                cell.textLabel.text = @"Gallery Picture";
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"cameraPicture"];
                cell.textLabel.text = @"Capture Picture";
                break;
                // TODO::
//            case 2:
//                cell.imageView.image = [UIImage imageNamed:@"pdfImage"];
//                cell.textLabel.text = @"Load Video";
//                break;
//            case 3:
//                cell.imageView.image = [UIImage imageNamed:@"pdfImage"];
//                cell.textLabel.text = @"Capture Video";
//                break;
//            default:
//                break;
        }
    }
    else{
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"GalleryIcon"];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                cell.textLabel.text = @"Gallery Picture";

                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"cameraPicture"];
                cell.textLabel.text = @"Capture Picture";
                break;
            default:
                break;
        }
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isFromBuildingMedia == NO) {
        if (indexPath.row==0) {
            [customerRecordVC loadImageFromViaMedia:ProfilePicFromGallery];
        }
        else if (indexPath.row==1){
            [customerRecordVC loadImageFromViaMedia:ProfilePicFromCamera];
        }
    }
    else if (indexPath.row == 0){
        [customerRecordVC loadImageFromViaMedia:PictureForBuildingMediaFromGallery];
    }
    else if (indexPath.row == 1){
        [customerRecordVC loadImageFromViaMedia:PictureForBuildingMediaFromCamera];
    }
    //TODO::
//    else if (indexPath.row == 2){
//        [customerRecordVC loadImageFromViaMedia:VideoForBuildingMediaFromGallery];
//    }
//    else if (indexPath.row == 3){
//        [customerRecordVC loadImageFromViaMedia:VideoForBuildingMediaFromCamera];
//    }
}
-(BOOL)shouldAutorotate{
    return NO;
}

@end
