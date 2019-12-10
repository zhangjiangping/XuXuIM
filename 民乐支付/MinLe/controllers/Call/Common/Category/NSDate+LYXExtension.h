//
//  NSDate+LYXExtension.h
//  VETEphone
//
//  Created by Liu Yang on 31/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NSDateNormalTimeLanguage) {
    NSDateNormalTimeLanguageCN = 0,
    NSDateNormalTimeLanguageEN = 1,
};

//  当天的显示具体时间，昨天显示Yesterday，一周内的显示星期几，一周后显示日期。
@interface NSDate (LYXExtension)

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month; // (1~12)
@property (nonatomic, readonly) NSInteger day;  // (1~31)
@property (nonatomic, readonly) NSInteger hour;  // (0~23)
@property (nonatomic, readonly) NSInteger minute;  // (0~59)
@property (nonatomic, readonly) NSInteger second;  // (0~59)
@property (nonatomic, readonly) NSInteger weekday;  //  (0~7)
@property (nonatomic, readonly) NSInteger weekdayOrdinal; ///< WeekdayOrdinal component
@property (nonatomic, readonly) NSInteger weekOfMonth; ///< WeekOfMonth component (1~5)
@property (nonatomic, readonly) NSInteger weekOfYear; ///< WeekOfYear component (1~53)
@property (nonatomic, readonly) NSInteger yearForWeekOfYear; ///< YearForWeekOfYear component
@property (nonatomic, readonly) NSInteger quarter; ///< Quarter component
@property (nonatomic, readonly) BOOL isLeapMonth; ///< whether the month is leap month
@property (nonatomic, readonly) BOOL isLeapYear; ///< whether the year is leap year
@property (nonatomic, readonly) BOOL isToday; ///< whether date is today (based on current locale)
@property (nonatomic, readonly) BOOL isYesterday; ///< whether date is yesterday (based on current locale)
@property (nonatomic, readonly) BOOL isTomorrow; ///< whether date is yesterday (based on current locale)

- (BOOL) isSameWeekAsDate:(NSDate *) aDate;

- (nullable NSDate *)dateByAddingYears:(NSInteger)years;
- (nullable NSDate *)dateByAddingMonths:(NSInteger)months;
- (nullable NSDate *)dateByAddingWeeks:(NSInteger)weeks;
- (nullable NSDate *)dateByAddingDays:(NSInteger)days;
- (nullable NSDate *)dateByAddingHours:(NSInteger)hours;
- (nullable NSDate *)dateByAddingMinutes:(NSInteger)minutes;
- (nullable NSDate *)dateByAddingSeconds:(NSInteger)seconds;

- (NSDate *)dateByAddingDays:(NSInteger)days;

//  当天的显示具体时间，昨天显示Yesterday，一周内的显示星期几，一周后显示日期。
+ (NSString *)convertToNormalTimeWithDate:(NSDate *) date
                                 language:(NSDateNormalTimeLanguage) language;

@end
