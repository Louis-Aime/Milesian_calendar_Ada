-- Package Scaliger
-- This package defines extended duration and time types using the "julian day"
-- as defined by Josef Juste Scaliger in 1783.
-- The duration is expressed as a number of 1/8 seconds.
-- Two numeric conversion functions are definied
-- exchanging a day expressed as a decimal figure from and to
-- an integer number of 1/8 seconds.
--
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

-- In a draft version, two type definitions of
-- the predefined Calendar package were used.
-- this reference has been eliminated for language portability.

package Scaliger is

   Time_Error : exception; -- same as in Calendar

   Day_unit : constant := 86_400.0;
   -- one day in real type seconds

   Horizon : Constant := 5_405_700 ;
   -- around 148 centuries in days, which covers years -4800 to 9999


   subtype Historical_year_number is integer range -4800 .. 9999;
   -- Year of the "Common era", equivalent to Anno Domini when positive,
   -- with a zero year and using negative values for years Before Christus.
   -- The lower limit -4800 enables computations using the gregorian cycles
   -- of 400 years.

   subtype Month_Number is Integer range 1 .. 12; -- same as in Ada.Calendar
   subtype Day_Number   is Integer range 1 .. 31; -- same as in Ada.Calendar

   subtype Julian_Day_Duration is Integer range -Horizon .. Horizon;

   subtype Julian_Day is Julian_Day_Duration range 0..Horizon;
   -- An integer Julian day represents any day on or after
   -- 1 January -4712 (Julian calendar).

   Duration_Horizon : Constant := Horizon * Day_unit;
   -- 148 centuries in seconds

   type Historical_Duration is
   delta 2#0.001# range -Duration_Horizon .. Duration_Horizon;
   -- Duration is stored and computed as an integer number of 1/8 seconds.
   -- This storage method is adequate because we express durations as
   -- a number of seconds (and minutes, hours and days).
   -- 1/8 second accuracy is suitable for computations involving the mean moon
   -- over a long period of time.
   -- Conversion method with durations expressed in fractional day is provided.

   subtype Historical_Time is Historical_Duration range 0.0 .. Duration_Horizon;
   -- Time counted from 1 Januray -4712 (Julian proleptic calendar) at 12:00
   -- As Historical duration, this is stored in seconds.

   subtype H24_Historical_Duration is Historical_Duration
   range 0.0 .. 86_400.0;
   -- As in Ada.calendar, duration of one full day maximum.

   subtype Day_Historical_Duration is Historical_Duration
   range -43_200.0 .. 43_200.0;
   -- The Greenwich hour of the day expressed with respect to 12:00 noon.

   type Fractional_day_duration is
   delta 1.0E-6 range - Horizon * 1.0 .. Horizon * 1.0;
   -- This type enables conversion to and from Historical_Duration
   -- with the an accuracy of around 1/10 s.
   -- Do not use for computations, only for display.

   type General_date is record
      day : Day_Number;
      month : Month_Number;
      year : Historical_year_number;
   end record;
   -- a record for expression of most calendars.
   -- zodiacal calendar does not fit (certain month have more than 31 days).

   function Fractionnal_day_of (My_duration : Historical_Duration)
                                return Fractional_day_duration;
   -- convert an historical duration (or time), in seconds,
   -- into a fractional day.

   function Convert_from_julian_day (Display : Fractional_day_duration)
                                     return Historical_Duration;
   -- used to convert manual entries in fractional day
   -- into usable time or duration expression.

End Scaliger;
