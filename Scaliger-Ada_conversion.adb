-- Package body Scaliger.Ada_conversion
----------------------------------------------------------------------------
-- Copyright Miletus 2015
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:
-- 1. The above copyright notice and this permission notice shall be included
-- in all copies or substantial portions of the Software.
-- 2. Changes with respect to any former version shall be documented.
--
-- The software is provided "as is", without warranty of any kind,
-- express of implied, including but not limited to the warranties of
-- merchantability, fitness for a particular purpose and noninfringement.
-- In no event shall the authors of copyright holders be liable for any
-- claim, damages or other liability, whether in an action of contract,
-- tort or otherwise, arising from, out of or in connection with the software
-- or the use or other dealings in the software.
-- Inquiries: www.calendriermilesien.org
-------------------------------------------------------------------------------
with Calendar; use Calendar;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;
package body Scaliger.Ada_conversion is
   -- Julian_Time and Julian_Duration are also in seconds.
   Day_Unit : constant := 86_400;
   Half_Day : constant := 43_200.0; -- used as a fixed real operand
   -- Work_Day_Unit: constant Work_duration := 86_400.0;
   -- One day expressed in seconds.
   Ada_Zero_Time : Time := Time_Of (2150, 1, 1, 0.0,
                                    Time_Zone => 0);
   -- Ada time epoch choosen in the middle of the Ada time span (1901..2399)
   -- in order to minimize computation problems with a too high duration
   Ada_Zero_in_Julian : constant := 2_506_331.5 * Day_Unit;
   -- Julian time corresponding to Ada_Zero_Time
   Ada_Zero_Day_in_Julian : constant := 2_506_332;
   -- Julian day corresponding to the day of the Ada epoch, at 12h UTC

   function Julian_Time_Of (Ada_Timestamp : Time) return Historical_Time is
      Ada_Time_Offset : Duration := Ada_Timestamp - Ada_Zero_Time;
   begin
      return Historical_Duration (Ada_Time_Offset) + Ada_Zero_in_Julian;
   end Julian_Time_Of;

   function Time_Of (Julian_Timestamp : Historical_Time) return Time is
      Duration_offset : Duration :=
        Duration_Of (Julian_Timestamp - Ada_Zero_in_Julian);
      -- Here the accuracy relies on function Duration_Of
   begin
      return Ada_Zero_Time + Duration_offset;
   end Time_Of;

   function Julian_Duration_Of (Ada_Offset : Duration) return Historical_Duration is
   begin
      return Historical_Duration (Ada_Offset);
   end Julian_Duration_Of;

   function Julian_Duration_Of (Day : Julian_Day_Duration) return Historical_Duration is
   begin
      return Day_Unit * Historical_Duration (Day);
   end Julian_Duration_Of;

   function Duration_Of (Julian_Offset : Historical_Duration) return Duration is
      -- since Julian Duration is stored as seconds,
      -- we make here a simple type conversion.
      -- The only problem could be an error of bounds.
   begin
      return Duration (Julian_Offset);
   end Duration_Of;

   function Day_Julian_Offset (Ada_Daytime : Day_Duration)
                               return Day_Historical_Duration is
      -- Time of the day expressed in UTC time (0..86_400.0 s)
      -- to Julian duration expressed in (-0.5..+0.5) but stored in seconds
      Offset : Historical_Duration := Historical_Duration(Ada_Daytime)- Half_Day;
   begin
      return Offset;
   end Day_Julian_Offset;

   function Day_Offset (Julian_Offset : Day_Historical_Duration)return Day_Duration
   is
      -- Julian day duration -0.5..+0.5 but stored in seconds
      -- to time of day 0..86_400.0 s
      Offset : Duration := Duration(Julian_Offset) + Half_Day;
   begin
      return Offset;
   exception
      when Constraint_Error => -- if more than 86400.0 seconds...
         return 86400.0;
   end Day_Offset;

   function Julian_Day_Of (Julian_Timestamp : Historical_Time) return Julian_Day is
   begin
      return Julian_Day (Julian_Timestamp / Day_Unit);
         -- This will convert to the nearest integer value exactly as required:
         -- this is a numeric type conversion, and
         -- "If the target type is an integer type
         -- and the operand type is real,
         -- the result is rounded to the nearest integer
         -- (away from zero if exactly halfway between two integers)".
         -- (Ada 2005 manual, 4.6, line 33).
   end Julian_Day_Of;

   function Julian_Day_Of (Ada_Timestamp : Time) return Julian_Day is
   begin
      return Julian_Day (Julian_Time_Of(Ada_Timestamp) / Day_Unit);
   end Julian_Day_Of;

   function Time_Of_At_Noon (Julian_Date : Julian_Day) return Time is
      subtype Ada_Calendar_Days_Offset is Julian_Day'Base
      range -250*366..250*366;
      Day_offset : Ada_Calendar_Days_Offset
        := (Julian_Date - Ada_Zero_Day_in_Julian);
      Duration_offset : Duration := Duration (Day_offset*Day_Unit + Day_Unit/2);
      -- raises contraint error if not in Ada calendar.
   begin
      return Ada_Zero_Time + Duration_offset;
   end Time_Of_At_Noon;

   end Scaliger.Ada_conversion;
