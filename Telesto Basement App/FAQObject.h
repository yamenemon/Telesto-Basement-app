//
//  FAQObject.h
//  Telesto Basement App
//
//  Created by CSM on 8/2/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAQObject : NSObject
@property (assign, nonatomic) int heatTextField;
@property (assign, nonatomic) int airTextField;
@property (assign, nonatomic) int currentOutsideConditionTextField;
@property (strong, nonatomic) NSString * outsideRelativeHumidity;
@property (strong, nonatomic) NSString * outsideTemperature;
@property (strong, nonatomic) NSString * firstFloorRelativeHumidity;
@property (strong, nonatomic) NSString * firstFloorTemperature;

@property (strong, nonatomic) NSString * basementRelativeHumidity;
@property (strong, nonatomic) NSString * basementTemperature;
@property (assign, nonatomic) int basementDehumidifier;
@property (strong, nonatomic) NSString* otherCommentsTextView;

@property (assign, nonatomic) int groundWaterTextField;
@property (assign, nonatomic) int ironBacteriaTextField;
@property (assign, nonatomic) int condensationTextField;
@property (assign, nonatomic) int wallCracksTextField;
@property (assign, nonatomic) int floorCracksTextField;
@property (assign, nonatomic) int existingSumpPumpTextField;
@property (assign, nonatomic) int RandomSystemTextField;
@property (assign, nonatomic) int foundationTypeTextField;
@property (strong, nonatomic) NSString* otherComments;

@property (assign, nonatomic) int groundWaterRatingField;
@property (assign, nonatomic) int ironWaterRatingField;
@property (assign, nonatomic) int condensationRatingField;
@property (assign, nonatomic) int wallCracksRatingField;
@property (assign, nonatomic) int floorCracksRatingField;

@property (assign, nonatomic) int existingDranageSystemTextField;
@property (assign, nonatomic) int drayerVentTextField;
@property (assign, nonatomic) int vulkHeadTextField;

@property (assign, nonatomic) int questionOneBoolField;
@property (strong, nonatomic) NSString * questionOneTextField;

@property (assign, nonatomic) int questionTwoBoolField;
@property (strong, nonatomic) NSString * questionTwoTextField;

@property (assign, nonatomic) int question3BoolField;
@property (assign, nonatomic) int question4BoolField;

@property (strong, nonatomic) NSString * question4TextField;

@property (assign, nonatomic) int question5BoolField;
@property (strong, nonatomic) NSString * question5TextField;

@property (assign, nonatomic) int question6BoolField;
@property (strong, nonatomic) NSString * question6TextField;

@property (assign, nonatomic) int question7BoolField;
@property (strong, nonatomic) NSString * question7TextField;

@property (assign, nonatomic) int question8BoolField;
@property (strong, nonatomic) NSString * question8TextField;

@property (strong, nonatomic) NSString * question9TextField;

@property (assign, nonatomic) int question10BoolField;
@property (strong, nonatomic) NSString * question10TextField;

@property (assign, nonatomic) int question11BoolField;
@property (strong, nonatomic) NSString * question11TextField;

@property (assign, nonatomic) int question12BoolField;
@property (assign, nonatomic) int question12BoolField2;

@property (strong, nonatomic) NSString * question13TextField;

@property (assign, nonatomic) int question14BoolField;
@property (strong, nonatomic) NSString * question14TextField;

@property (assign, nonatomic) int question15BoolField;
@property (assign, nonatomic) int question15BoolField2;

@property (strong, nonatomic) NSString *commentTextView;
@end
