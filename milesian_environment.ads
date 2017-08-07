-- Milesian converter I/O environment
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
with Text_IO;
with Scaliger;
with Calendar.Formatting;
with Lunar_phase_computations;
Package Milesian_environment is
   package Duration_IO is new Text_IO.Fixed_IO (Num => Duration);
   package Week_Day_IO is new
     Text_IO.Enumeration_IO (Enum => Calendar.Formatting.Day_Name);
   package Julian_Day_IO is
     new Text_IO.Fixed_IO (Num => Scaliger.Fractional_day_duration);
--   package Lunar_phase_IO is
--     new Text_IO.Fixed_IO (Num => Lunar_phase_computations.Lunar_phase);
end Milesian_environment;
