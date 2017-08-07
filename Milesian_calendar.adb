-- Package body Milesian_calendar
----------------------------------------------------------------------------
-- Copyright Miletus 2016
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
-- Version 2: uses Milesian solar intercalation:
-- as an extension to the Gregorian rules,
-- every 3200 years, the 400-year that is bissextile under Gregorian rule
-- is not under Milesian rule.
-- The years under this rule are -4000, -800, 2400, 5600, 8800...
-- The Milesian era numbered '0' starts at -4000.
-- This can be considered as the Milesian epoch.
-- The Milesian era numbered '1' starts on 1 1m -800 until 30 12m 2399.
-- This era can be considered "historical", since there is no serious hisorical
-- date outside this era.

With Cycle_Computations;

Package body Milesian_calendar is
   Package Julian_Day_cycle is
     new Cycle_computations.Integer_cycle_computations
     (Num => Julian_Day'Base);
   Use Julian_Day_cycle;

   subtype computation_month is integer range 0..12;

   function is_long_Milesian_year -- following the Milesian rule
     (y : Historical_year_number) return boolean is
      y1 : Historical_year_number'Base := y+801;
   begin
      return y1 mod 4 = 0 and then (y1 mod 100 /= 0
                                    or else (y1 mod 400 = 0
                                   and then y1 mod 3200 /= 0));
   End is_long_Milesian_year;

   function valid
     (date : milesian_date)
      return boolean is -- whether the given date is an existing one
      -- on elaboration, the basic range checks on record fields have been done
   begin
      return date.day <= 30
        or else (date.month mod 2 = 0
                 and
                   (date.month /= 12 or else is_long_Milesian_year(date.year)));
   end valid;

   function JD_to_Milesian (jd : Julian_Day) return Milesian_Date is
      cc : Cycle_coordinates := Decompose_cycle (jd-260081, 1168775);
      -- intialise current day for the computations to
      -- day of the "milesian epoch" i.e. 0 relative to 1/1m/-4000.
      yc : Historical_year_number'Base := cc.cycle*3200 - 4000;
      -- year components for computations initialised to base of Milesian era
      -- i.e.: -7200 or -4000 or -800
      mc : computation_month; -- bimester and monthe rank for computations
   begin
      cc := Decompose_cycle (cc.Phase, 146097);
      -- cc.cycle is rank of quadriseculum is Milesian era,
      -- cc.phase is rank of day within quadriseculum,
      yc := yc + cc.cycle * 400; -- base quadriseculum
      cc := Decompose_cycle_ceiled (cc.phase, 36524, 4);
      -- cc.cycle is rank of century in quadriseculum,
      -- cc.phase is rank of day within century.
      -- rank of century is 0 to 3, phase can be 36524 if rank is 3.
      yc := yc + (cc.cycle) * 100; -- base century
      cc := Decompose_cycle (cc.phase, 1461); -- quadriannum
      yc := yc + cc.cycle * 4;
      cc := Decompose_cycle_ceiled (cc.phase, 365, 4); -- year in quadriannum
      yc := yc + cc.cycle; -- here we get the year
      cc := Decompose_cycle (cc.phase, 61);
      -- cycle is rank of bimester in year; phase is rank of day in bimester
      mc := cc.cycle * 2; -- 0 to 10
      cc := Decompose_cycle_ceiled (cc.phase, 30, 2);
      -- whether firt (0) or second (1) month in bimester,
      -- and rank of day, 0 .. 30 if last month.
      return (year => yc, month => mc + cc.cycle + 1,
              day => integer(cc.phase) + 1);
      -- final month number and day number computed in return command.
   end JD_to_Milesian;

   function Milesian_to_JD (md : milesian_date) return julian_day is
      yc : Julian_Day'Base := md.year + 4800;
      -- year starting at -4800 in order to be positive;
      -- as a variant: we could start at -4000, forbidding years before -4000.
      mc : computation_month := md.month - 1;
   begin
      if not valid (md) then raise Time_Error; end if;
      return Julian_Day'Base (yc*365) -32113
        + Julian_Day'Base (yc/4 -yc/100 +yc/400 -(yc +2400)/3200
                           +mc*30 +mc/2 +md.day);
      -- integer divisions yield integer quotients.
   end Milesian_to_JD;

end Milesian_calendar;
