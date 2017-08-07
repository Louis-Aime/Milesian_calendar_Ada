-- Package body Julian_calendar
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
------------------------------------------------------------------------------
With Cycle_Computations;

Package body Julian_calendar is
   Package Julian_Day_cycle is
     new Cycle_computations.Integer_cycle_computations
     (Num => Julian_Day'Base);
   Use Julian_Day_cycle;

   subtype computation_month is integer range 0..12;

   function is_bissextile_year -- in the sense of Julian or Gregorian
     (year : Historical_year_number; Calendar : Calendar_type := Unspecified)
      return Boolean is
      Is_Julian : Boolean := Calendar = Julian or else
         (Calendar = Unspecified and then year < 1583);
   begin
      return year mod 4 = 0 and then
        (Is_Julian or else (year mod 100 /= 0
                                  or else year mod 400 = 0));
   end is_bissextile_year;

   function is_valid
     (date : Roman_date; Calendar : Calendar_type := Unspecified)
      return Boolean is  -- whether the given date is an existing one
      -- on elaboration, the basic range cheks on record fields have been done
   begin
      case date.month is
         when 4|6|9|11 => return date.day <= 30;
         when 2 => return date.day <= 28
              or else (date.day = 29
                       and is_bissextile_year (date.year , Calendar));
         when others => return True;
      end case;
   end is_valid;

   function JD_to_Roman (jd : Julian_Day;
                         Calendar : Calendar_type := Unspecified)
                        -- Gregorian : Boolean := (jd > 299160))
                         return Roman_date is
         Is_Gregorian : Boolean := Calendar = Gregorian or else
         (Calendar = Unspecified and then jd > 299160);
      -- by default, the return date shall be specified in gregorian
      -- if it falls after 1582-10-04 (julian)
      cc : Cycle_coordinates := (0, jd+1401);
      -- Initiated for the julian calendar case;
      -- Base of cycle if julian calendar is 1/3/-4716 julian calendar
      Shifted_month : Integer;
      Shifted_year : Historical_year_number := -4716;
   begin
      -- 1. Find the year and day-of-year in the shifted Roman calendar,
      -- i.e. the calendar that begins on 1 March.
      -- 1.1 If Gregorian, find quadrisaeculum, then century, then quadriannum;
      -- else find directly quadriannum;
      -- 1.2 Find shifted year and rank of day in shifted year;
      -- 1.3 Find shifted month, find day rank in shifted month
      -- 2. Set to unshifted calendar.
      if Is_Gregorian then -- 1.1
         cc := Decompose_cycle (jd+32044, 146097);
         -- intialise current day for the computations to
         -- day of a "gregorian epoch" such as 0 is 1/3/-4800 gregorian
         Shifted_year := (cc.cycle - 12) * 400;
         -- Initiated for the gregorian calendar
         cc := Decompose_cycle_ceiled (cc.phase, 36524, 4);
         -- cc.cycle is rank of century in quadriseculum,
         -- cc.phase is rank of days within century.
         -- rank of century is 0 to 3, phase can be 36524 if rank is 3.
         Shifted_year := Shifted_year + (cc.cycle) * 100; -- base century
      end if;
      -- 1.2; cc and shifted_year already initiated.
      cc := Decompose_cycle (cc.phase, 1461); -- quadriannum
      Shifted_year := Shifted_year + cc.cycle * 4;
      cc := Decompose_cycle_ceiled (cc.phase, 365, 4); -- year in quadriannum
      Shifted_year := Shifted_year + cc.cycle;
      -- here we get the (shifted) year and the rank of day, cc.phase.
      -- 1.3 use a variant of Troesch method
      cc := Decompose_cycle (5 * cc.Phase + 2 , 153);
      Shifted_month := cc.Cycle;
      -- here Shifted_day = cc.Phase / 5;
      if Shifted_month < 10 -- 0..9 meaning March to December
      then return (year => Shifted_year,
                   month => Shifted_month + 3,
                   day => cc.Phase/5 + 1);
      else return (year => Shifted_year + 1,
                   month => Shifted_month - 9,
                   day => cc.Phase/5 + 1);
      end if;
   end JD_to_Roman;

   function Roman_to_JD (Date : Roman_date;
                         Calendar : Calendar_type := Unspecified)
                         return Julian_Day is
      Is_Gregorian : Boolean := Calendar = Gregorian or else
        (Calendar = Unspecified and then
         (Date.year > 1583 or else
          (Date.year = 1582 and then
           (Date.month > 10 or else
            (Date.month = 10 and then Date.day > 4)))));
      Jd   : Julian_Day;
      Days : Julian_Day_Duration;
      Shifted_month : integer := Date.month;
      Shifted_year  : Integer := Date.year;
      Centuries : Integer;
   begin
      if not is_valid (date , Calendar) then raise Time_Error; end if;
      if Shifted_month in 1..2 then
         Shifted_month := Shifted_month + 9; -- 10 or 11
         Shifted_year := Shifted_year - 1;
      else
         Shifted_month := Shifted_month - 3; -- 0 to 9
      end if;
      Centuries := (Shifted_year + 4800)/100; -- Computed from -4800;
      Days := (Shifted_year + 4716) / 4 --  for each leap year
        + (Shifted_month*306 + 5) / 10
      -- osssia  + Integer (Fractional_day_in_year (Shifted_month * 30.6))
        + date.day - 307;
      If Is_Gregorian then
         Days := Days - Centuries + Centuries/4 + 38;
         end if;
      Jd := (Shifted_year + 4713) * 365; -- 365 days per years
      Jd := Jd + Days;
      Return Jd;
   end Roman_to_JD;

   function Julian_to_Gregorian_Delay (Year : Historical_year_number)
                                       return Integer is
      A : Natural := Year + 4800 ; -- force positive.
   begin
      return -38 + A/100 - A/400; -- divisions use only with positive arguments
   end Julian_to_Gregorian_Delay;

   function Easter_days (Year : Natural;
                         Calendar : Calendar_type := Unspecified)
                         return Natural is
      Is_Gregorian : Boolean := Calendar = Gregorian or else
         (Calendar = Unspecified and then year > 1582);
      -- Initialisation: decompose year in suitable parts,
      -- Compute Gold number, compute Easter residue.
      -- Rank of century
      S : Natural := Year / 100;
      -- Rank of quadrisaeculum
      Q : Natural := S/4;
      -- Rank of quadriannum in current century
      B : Natural range 0..24 := (Year - S*100) / 4;
      -- Rank of year in current quadriannum
      N : Natural range 0..3 := (Year - S*100 - B*4);
      -- Gold number minus one in Meton's cycle
      G : Natural range 0..18 := Year mod 19;
      -- Easter residue, number of days from 21 March until Easter full moon
      R : Natural range 0..29 :=
        (15 + 19*G -- Computation of Easter residue after Delambre...
          + Boolean'Pos (Is_Gregorian) * (S - Q - (8*S + 13)/25))
          -- Gregorian: add Metemptose and Proemptose.
          -- Proemptose is computed with the Zeller-Troesch formula.
         mod 30; -- Take the remainder by 30 residue before correction.
   begin
      if Is_Gregorian then
         R := R - (G + 11*R) / 319 ; -- correction on residue
      end if;
      if Is_Gregorian then
         return 1 + R + (4 - Q + 2*S + 2*B - N - R) mod 7 ;
      else
         return 1 + R + (6 + S + 2*B - N - R) mod 7 ;
      end if;

   end Easter_days;

end Julian_calendar;
