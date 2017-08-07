-- Package Milesian_calendar
-- Definitions and basic operation on the Milesian calendar
-- with respect to Julian Day defined in Julian package.
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

With Scaliger; use Scaliger;
-- Defines Julian_Day and General date (i.e. Day 1..31, Month 1..12, Year).

Package Milesian_calendar is

   Type Milesian_date is new General_date;
   -- the function names are similar to names of conversion functions in php

   function JD_to_Milesian (jd : Julian_Day) return Milesian_date ;
   -- given an integer Julian day, compute the corresponding Milesian date
   function Milesian_to_JD (md : Milesian_date) return Julian_Day ;
   -- given a date in Milesian, compute the Julian day

end Milesian_calendar;
