-- Mean lunar phase computations
-- Given a date expressed as a decimal Julian day,
-- compute the mean lunar phase (and later the next mean new moon).
-- The algorithm is in the public domain
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
with Scaliger; use Scaliger;

Package Lunar_phase_computations is

   subtype Lunar_age is Historical_Duration range 0.0 .. 29.9*Day_unit;
   -- A duration that is not more than a real lunar month.

--   subtype Lunar_phase is Duration range -86_400.0 .. 86_400.0;
   -- a cyclic unit of -24 hours to + 24 hours in seconds,
   -- aimed at giving a lunar time representing the moon's azimut
   -- the same way as you estimate the sun's position from your clock's hour.
   -- The lunar phase is the duration
   -- to be substracted from the clock hour
   -- to obtain the lunar time.

   function Mean_lunar_age (This_day : Historical_Time) return Lunar_age;
   -- The number of fractional days since the last mean new moon.

   function Mean_lunar_residue (This_day : Historical_Time) return Lunar_age;
   -- The number of fractional days until the next mean new moon.

   function Mean_lunar_time_shift (This_day : Historical_Time)
                                   return H24_Historical_Duration;
   -- Duration to be substracted from the clock hour modulo 86_400.0 s
   -- in order to obtain the lunar time


--   function Mean_lunar_phase (This_day : Historical_Time) return Lunar_phase;
   -- Mean lunar phase, a duration in the range 0.0 .. 24.0 in sesconds;
   -- Practically, value 24.0 is displayed when rounding.

end Lunar_phase_computations;
