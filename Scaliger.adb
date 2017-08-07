-- Body of package Scaliger
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

Package body Scaliger is

   function Fractionnal_day_of (My_duration : Historical_Duration)
                             return Fractional_day_duration is
   begin
      return My_duration / 86400.0;
   end Fractionnal_day_of;

   function Convert_from_julian_day (Display : Fractional_day_duration)
                                        return Historical_Duration is
      -- The fractional part of the julian day is displayed as a decimal figure
      -- and is stored as an integer number of the "delta",
      -- delta being in negative power of 2,
      -- whereas the number of seconds in a day, 86400, is not a power of 2.
      -- Multiplying this figure by 86400 is multiplying the delta by the same.
      -- So we use floating number multiplication
      -- to convert the fractional part from (fractional) day to seconds
      Day : Integer := Integer (Display); -- extract integer part of Julian Day
      Time_in_day : Fractional_day_duration
        := Display - Fractional_day_duration (Day); -- in fixed-point day
      Pad : Float := Float (Time_in_day);
      Julian_hours : Historical_Duration := Historical_Duration (Pad * 86400.0);
   begin
      return Historical_Duration (Day * 86400) + Julian_hours;
   end Convert_from_julian_day;

end Scaliger;
