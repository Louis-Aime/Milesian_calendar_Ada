-- Mean lunar phase computations
-- Given a date expressed as a decimal Julian day,
-- compute the 'mean' lunar age (days since last mean new moon)
-- and the 'mean' lunar phase, a figure in the range 0.0 .. 4.0
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
-- The length of the mean synodic month and the reference date
-- for the mean new moon are discussed in
-- "The Length of the Lunar Cycle", Dr Irv Bromberg, Univ. of Toronto, Canada
-- http://www.sym454.org/lunar
-------------------------------------------------------------------------------

with Cycle_Computations; use Cycle_Computations;

Package body Lunar_phase_computations is
   Mean_synodic_month : constant Historical_Duration := 2_551_442.88;
   -- this value is the length of the mean synodic month
   -- suitable for mean moon computations

   New_moon_reference : constant Historical_Time
     := 2_451_550.0*Day_unit + 2*3600.0 + 20*60.0 + 44.0;
   -- This is the mean new moon nearest to 2000-01-01 gregorian
   -- and also the next after 1 1m 2000
   -- 2000-01-06 (gregorian) at 14:20:44 Terrestrial Time (TT)

   Package Lunar_Cycle is new Fixed_Cycle_Computations
     (Fixed_num => Historical_Duration);
   Use Lunar_Cycle;

   function Mean_lunar_age (This_day : Historical_Time) return Lunar_age is
      Moon_hour : Cycle_coordinates := Decompose_cycle
        (Dividend => This_day - New_moon_reference,
         Divisor  => Mean_synodic_month);
   begin
      return Moon_hour.Phase;
   end Mean_lunar_age;

   function Mean_lunar_residue (This_day : Historical_Time) return Lunar_age is
      Moon_hour : Cycle_coordinates := Decompose_cycle
        (Dividend => New_moon_reference - This_day,
         Divisor  => Mean_synodic_month);
   begin
      return Moon_hour.Phase;
   end Mean_lunar_residue;

   function Mean_lunar_time_shift (This_day : Historical_Time)
                                   return H24_Historical_Duration is
      -- Conversion factor to reprensent lunar age in sec. in range [0 .. 24h[
      Lunar_time_scale : constant Long_Float
        := 86_400.0 / Long_Float (Mean_synodic_month);
      P : Long_Float
        := Lunar_time_scale * Long_Float (Mean_lunar_age (This_day));
   begin
      return H24_Historical_Duration (P);
   end Mean_lunar_time_shift;

end Lunar_phase_computations;
