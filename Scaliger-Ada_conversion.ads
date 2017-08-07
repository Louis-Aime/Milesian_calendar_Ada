-- Julian.Ada_conversion, a sub-package of Julian.
-- This package focuses on conversion between the Julian time
-- i.e. duration and time expressed in fractional Julian days,
-- and Ada.Calendar duration and time data.
-- These routines are only usefull for implementations
-- where conversions to and from the Ada time system are necessary.
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

package Scaliger.Ada_conversion is

   function Julian_Time_Of (Ada_Timestamp : Time)
                            return Historical_Time;
   -- return Julian time following the classical convention i.e.:
   -- Julian time takes integer values at noon GMT.

   function Time_Of (Julian_Timestamp : Historical_Time) return Time;
   -- convert Julian time into Ada time.

   function Julian_Duration_Of (Ada_Offset : Duration) return Historical_Duration;
   -- convert Ada duration (seconds)
   -- to Julian duration (fractional days stored in seconds)

   function Julian_Duration_Of (Day : Julian_Day_Duration) return Historical_Duration;
   -- convert a Julian day (an integer) into a julian duration
   -- which is expressed in seconds to the 1/8s.

   function Duration_Of (Julian_Offset : Historical_Duration) return Duration;

   function Day_Julian_Offset (Ada_Daytime : Day_Duration)
                               return Day_Historical_Duration;
   -- Time of the day expressed in UTC time (0..86_400.0 s)
   -- to Julian duration expressed in (-0.5..+0.5)

   function Day_Offset (Julian_Offset : Day_Historical_Duration)
                         return Day_Duration;
   -- Julian day duration -0.5..+0.5 to time of day 0..86_400.0 s

   function Julian_Day_Of (Julian_Timestamp : Historical_Time)
                           return Julian_Day;
   -- gives the nearest integer of a Julian time

   function Julian_Day_Of (Ada_Timestamp : Time)
                           return Julian_Day;
   -- the day corresponding to the UTC day of Ada_Timestamp

   function Time_Of_At_Noon (Julian_Date : Julian_Day) return Time;
   -- By convention, the "seconds" field is set to 12.00 UTC in this routine.

end Scaliger.Ada_conversion;
