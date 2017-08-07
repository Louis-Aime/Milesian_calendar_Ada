-- Julian_calendar.ads
-- Specifications of conversion routines between julian and gregorian calendar
-- versus Julian day. Here they are named Roman calendar.
-- i.e. Julian calendar as initiated by Julius Caesar in 709 Ab Urbe Condita
-- and Gregorian calendar as enforced by Gregorius XIII in 1582 Anno Domini)
-- are also implemented here.
-- The computation of Easter following Julian and Gregorian computus
-- is also specified here.

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

With Scaliger; use Scaliger;
-- Defines Julian_Day and General date (i.e. Day 1..31, Month 1..12, Year).

Package Julian_calendar is

   type Roman_date is new General_date;
   type Calendar_type is (Unspecified, Julian, Gregorian);

-- the function names are similar to names of conversion functions in php

   function JD_to_Roman (jd : Julian_Day;
                         Calendar : Calendar_type := Unspecified)
                         return Roman_date;
   -- given an integer Julian day, compute the corresponding Roman day
   -- by default: following the Julian calendar.

   function Roman_to_JD (Date : Roman_date;
                         Calendar : Calendar_type := Unspecified)
                         return Julian_Day;
   -- given a date in Roman form, compute the corresponding Julian day.

   function Julian_to_Gregorian_Delay (Year : Historical_year_number)
                                       return Integer;
   -- Delay of the Julian calendar to the Gregorian in days,
   -- i.e. days to add the Julian date in order to obtain the Gregorian one.
   -- This delay is valid from 1 March of specified year,
   -- until last day of February of next year, Julian calendar.

   function Easter_days (Year : Natural;
                         Calendar : Calendar_type := Unspecified)
                         return Natural;
   -- Give number of days to add to 21 March in order to land Easter sunday.
   -- Delambre method and "Milesian" method (no dependency to Milesian calendar)

end Julian_calendar;
