-- Milesian converter
-- A simple converter to and from Milesian dates
-- This programme is a console demonstrator for the referred packages
-- copyright Miletus 2015-2019 - no transformation allowed, no commercial use
-- application developed using GPS GPL 2014 of Adacore
-- inquiries: see www.calendriermilesien.org
-- Versions
--   M2017-01-13 : adaptation to new package specifications
--   M2019-01-16 : Milesian calendar intercalation back to Gregorian
----------------------------------------------------------------------------
-- Copyright Miletus 2015-2019
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
with Calendar.Formatting; use Calendar.Formatting;
with Scaliger; use Scaliger;
with Scaliger.Ada_conversion; use Scaliger.Ada_conversion;
with Milesian_calendar; use Milesian_calendar;
with Julian_calendar; use Julian_calendar;
with Lunar_phase_computations; use Lunar_phase_computations;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Text_IO; use Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Milesian_environment; use Milesian_environment;
   use Milesian_environment.Week_Day_IO;
   use Milesian_environment.Julian_Day_IO;


procedure Milesian_converter is

   NL : constant String := CR & LF ;
   Licence_text : constant String :=
     "Date converter and moon phase computer using the Milesian calendar."  & NL &
     "Written by Louis A. de Fouquieres, Miletus," & NL &
     "Initial version M2015-09-30, actual version M2019-01-16." & NL &
     "Generated with the GNAT Programming Studio GPL Edition 2014." & NL &
     "No warranty of any kind arising from or in connection with this application."
     & NL & "Library sources available on demand under GP licence."
     & NL & "No commercial usage allowed - inquiries: www.calendriermilesien.org";

   Prompter : constant String := "Type command and figures, or H for Help:";

   Help_text : constant String :=
     "This line mode program converts dates from and to "
     & NL &
     "Julian day, Milesian, Gregorian, and Julian calendars." & NL &
     "Mean Moon age, residue and lunar time are also computed, " & NL &
     "as well as yearly key figures."
     & NL &
     "Syntax: <Command> <1 to 6 numbers separated with spaces>." & NL &
     "<Command> is one character as described hereunder." & NL &
     "Numbers are decimal possibly beginning with + or -, without spaces," & NL &
     "with a dot (.) as decimal separator when applicable." & NL &
     "When a date is expected, it must be entered as: year (-4800 to 9999),"
     & NL &
     "month number (1 to 12, by default: 1), day number (1 to 31, by default: 1),"
     & NL &
     "hours (0 to 23, default 12), minutes and seconds (default 0, max 59)."
     & NL & "Time of day is Terrestrial Time (64,184 s ahead of UTC in 2000)."
     & NL &
     "Lunar time is time of day where the mean Moon stands" & NL &
     "at the same azimuth than the mean Sun at this solar time." & NL &
     "Yearly key figures ('Y' command) include" & NL &
     "- doomsday, i.e. day of the week that falls at same dates every year," & NL &
     "- lunar figures at new year's eve at 7h30 UTC," & NL &
     "- Milesian epact and yearly lunar residue, in half-integer," & NL &
     "- spring full moon residue in integer value," & NL &
     "- for years A.D., days between 21st March and Easter"
     & NL &
     "following the Gregorian and Julian Catholic ecclesiastical computus," & NL &
     "and finally the delay, in days, of dates in Julian compared to Gregorian."
     & NL &
     "Available commands:"  & NL &
     "D <Positive integer or decimal number>: Julian day;"  & NL &
     "G <Date>: Date in Gregorian calendar (even before 1582);"  & NL &
     "J <Date>: Date in Julian calendar;"  & NL &
     "M <Date>: Date in Milesian calendar;"  & NL &
     "Y <Year>: Yearly key figures (see above);"
     & NL &
     "A <Days> [<Hours> [<Minutes> [<Seconds>]]]: Add days, hours, mins, secs"
     & NL & "to current date, each figure is a signed integer, 0 by default;"
     & NL &
     "H: display this text;"  & NL &
     "L: display licence notice;" & NL &
     "X: exit program.";

   Command : Character := ' ';
   Roman_calendar_type : Calendar_type := Unspecified;

   -- Duration to substract to Julian Day of first day of a year, in order
   -- to obtain time of "doomsday" at which the moon phase is computed.
   To_Doomsday_time_duration : constant Historical_Duration
     := 86_400.0 + 4*3600.0 + 30*60.0;

   -- To substract to Milesian epact to obtain a good estimate
   -- of Easter full moon residue
   To_Spring_Full_Moon : Constant := 12.52 * 86_400;

   This_year : Historical_year_number := 0;

   M_date: Milesian_date := (4, 12, -4713);
   R_date : Roman_date := (1, 1, -4712);
   This_Julian_day: Julian_day := 0; -- in integer days
   This_historical_time: Historical_Time := 0.0; -- in seconds
   Displayed_time: Fractional_day_duration := 0.0; -- in fractional days
   This_hour : Hour_Number := 12;
   This_minute : Minute_Number := 0;
   This_second : Second_Number :=0;

   Day_time : Day_Duration := 0.0;
   Julian_hour : Day_Historical_Duration := 0.0;

   Day_Number_in_Week : Integer range 0..6;

   Moon_time, Moon_time_shift : H24_Historical_Duration;
   Moon_hour : Hour_Number;
   Moon_minute: Minute_Number;
   Moon_second: Second_Number;
   Moon_subsecond: Second_Duration;

   Help_request, Licence_request : Exception;

begin
   Put (Licence_text); New_Line;
   loop
      begin -- a block with exception handler
         Put (Prompter); New_Line;
         Get (Command);
         case Command is
            when 'H' => Skip_Line; raise Help_request;
            when 'L' => Skip_Line; raise Licence_request;
            when 'D' =>
               --Get section
               Get (Displayed_time); Skip_Line;
               -- Conversion section
               This_historical_time := Convert_from_julian_day (Displayed_time);
               This_Julian_day := Julian_Day_Of (This_historical_time);
               M_date := jd_to_milesian (This_Julian_day);
               Julian_hour := This_historical_time - Julian_Duration_Of (This_Julian_day);
               Day_time := Day_Offset (Julian_hour);
               This_hour := Integer (Day_time) / 3600;
               This_minute := Integer (Day_time) / 60 - This_hour*60;
               This_second := Integer (Day_time) - This_hour*3600 - This_minute*60;

            when 'G' | 'J' =>
               -- Get section.
               case Command is
                  when 'G' => Roman_calendar_type := Gregorian;
                  when 'J' => Roman_calendar_type := Julian;
                     when others => Roman_calendar_type := Unspecified;
               end case;
               R_date := (1, 1, -4712);
               This_hour := 12; This_minute := 0; This_second := 0;
               Get (R_date.year);
               if not End_Of_Line then Get (R_date.month); end if;
               if not End_Of_Line then Get (R_date.day); end if;
               if not End_Of_Line then Get (This_hour); end if;
               if not End_Of_Line then Get (This_minute); end if;
               if not End_Of_Line then Get (This_second); end if;
               Skip_Line;
               -- Conversion section;
               This_Julian_day := Roman_to_JD (R_date, Roman_calendar_type);
               -- This function raises Time_Error if date is improper
               Day_time := 3600.0 * This_hour + 60.0 * This_minute + 1.0 * This_second;
               This_historical_time := Julian_Duration_Of (This_Julian_day) + Day_Julian_Offset (Day_time);
               Displayed_time := Fractionnal_day_of (This_historical_time);
               M_date := JD_to_Milesian (This_Julian_day);

            when 'M' =>
               M_Date := (1, 1, -4712);
               This_hour := 12; This_minute := 0; This_second := 0;
               Get (M_date.year);
               if not End_Of_Line then Get (M_date.month); end if;
               if not End_Of_Line then Get (M_date.day); end if;
               if not End_Of_Line then Get (This_hour); end if;
               if not End_Of_Line then Get (This_minute); end if;
               if not End_Of_Line then Get (This_second); end if;
               Skip_Line;
               -- Conversion section;
               This_Julian_day := Milesian_to_JD (M_date);
               -- This function raises Time_Error if date is improper
               Day_time := 3600.0 * This_hour + 60.0 * This_minute + 1.0 * This_second;
               This_historical_time := Julian_Duration_Of (This_Julian_day) + Day_Julian_Offset (Day_time);
               Displayed_time := Fractionnal_day_of (This_historical_time);
               M_date := JD_to_Milesian (This_Julian_day);

            when 'Y' =>
               M_Date := (1, 1, -4712);
               This_hour := 12; This_minute := 0; This_second := 0;
               Get (This_year); M_date.year := This_year;
               Skip_Line;
               -- Conversion section: compute "doomsday"
               This_Julian_day := Milesian_to_JD (M_date);
               -- Set to "doomsday"
               Day_time := 3600.0 * This_hour + 60.0 * This_minute + 1.0 * This_second;
               This_historical_time := Julian_Duration_Of (This_Julian_day)
                 + Day_Julian_Offset (Day_time)
                 - To_Doomsday_time_duration;
               This_Julian_day := Julian_Day_Of (This_historical_time);
               M_date := jd_to_milesian (This_Julian_day);
               Displayed_time := Fractionnal_day_of (This_historical_time);

            when 'A' =>
               declare
                  Days : Julian_Day_Duration := 0;
                  Hour_Offset, Minute_Offset, Second_Offset : Integer := 0;
                  Julian_Time_Offset : Historical_Duration := 0.0;

               begin
                  -- Get section
                  Get (Days);
                  if not End_Of_Line then Get (Hour_Offset); end if;
                  if not End_Of_Line then Get (Minute_Offset); end if;
                  if not End_Of_Line then Get (Second_Offset); end if;
                  Skip_Line;
                  -- Conversion section
                  Julian_Time_Offset := Julian_Duration_Of
                    (3600.0 * Hour_Offset
                     + 60.0 * Minute_Offset
                     + 1.0 * Second_Offset);
                  This_historical_time :=
                    This_historical_time + Julian_Duration_Of (Days) + Julian_Time_Offset ;
                  This_Julian_day := Julian_Day_Of (This_historical_time);
                  M_date := jd_to_milesian (This_Julian_day);
                  Julian_hour := This_historical_time - Julian_Duration_Of (This_Julian_day);
                  Displayed_time := Fractionnal_day_of (This_historical_time);
                  begin
                     Day_time := Day_Offset (Julian_hour);
                  exception
                     when Constraint_Error =>
                        Put("Day time out of bounds - correcting"); New_Line;
                        Day_time := 86_399.88;
                        -- avoids out of bounds.
                  end;
                  This_hour := Integer (Day_time) / 3600;
                  This_minute := Integer (Day_time) / 60 - This_hour*60;
                  This_second := Integer (Day_time) - This_hour*3600 - This_minute*60;
               end;

            when 'X'       => put ("Bye");
            when others    =>
               put (">Invalid command "); New_Line; Skip_Line;
         end case;
         exit when Command = 'X';

         -- Display results section - Julian day and Milesian date.
         Day_Number_in_Week := This_Julian_day mod 7;

         If Command /= 'Y' then
            put ("Julian day  : ");
            put (Displayed_time,1,6); put ("; ");
            put ("Milesian : ");
            put (Day_Name'Val (This_Julian_day mod 7),3, Lower_Case); Put (' ');
            put (M_date.day,1); put (' ');
            put (M_date.month, 1); put("m "); put (M_date.year, 1);
            put (", "); put (This_hour, 1); put ("h "); put (This_minute, 1);
            put ("mn "); put (This_second, 1); Put ("s");
            New_Line;
            -- Put Julian and Gregorian calendar equivalent
            Put ("Julian      : ");
            R_date := JD_to_Roman (This_Julian_day, Julian);
            Put (R_date.day,1); Put ('/');
            Put (R_date.month,1); Put ('/');
            Put (R_date.year,1);
            Put ("; Gregorian : ");
            R_date := JD_to_Roman (This_Julian_day, Gregorian);
            Put (R_date.day,1); Put ('/');
            Put (R_date.month,1); Put ('/');
            Put (R_date.year,1);
         else
            put ("Year: "); put (This_year, 4); put("; Doomsday: ");
            put (Day_Name'Val (This_Julian_day mod 7),3, Lower_Case); Put (' ');
         end if ;
         -- Give Lunar phase
         New_Line;
         Put ("Lunar age: ");
         Julian_Day_IO.Put (Fractionnal_day_of(Mean_lunar_age (This_historical_time)),1);
         Put ("; Lunar residue: ");
         Julian_Day_IO.Put (Fractionnal_day_of(Mean_lunar_residue (This_historical_time)),1);
         Put (";");
         if Command /= 'Y' then -- Display lunar hour - not with year infos.
            New_Line; Put("Lunar time: ");
            Moon_time_shift := Mean_lunar_time_shift (This_historical_time);
            if Day_time >= Duration(Moon_time_shift)
            then Moon_time
                 := H24_Historical_Duration(Day_time - Duration(Moon_time_shift));
            else Moon_time
                 := H24_Historical_Duration(86_400.0 + Day_time - Duration(Moon_time_shift));
            end if;
            Split (Duration(Moon_time), Moon_hour, Moon_minute, Moon_second,
                   Moon_subsecond);
            Put(Moon_hour,2); Put ("h "); Put (Moon_minute,2); Put ("mn ");
            Put (Moon_second,2); Put ("s (shift : -");
            Split (Duration(Moon_time_shift), Moon_hour, Moon_minute, Moon_second,
                   Moon_subsecond);
            Put(Moon_hour,2); Put ("h "); Put (Moon_minute,2); Put ("mn ");
            Put (Moon_second,2); Put ("s, or +");
            Split (Duration(86_400.0 - Moon_time_shift), Moon_hour, Moon_minute, Moon_second,
                   Moon_subsecond);
            Put(Moon_hour,2); Put ("h "); Put (Moon_minute,2); Put ("mn ");
            Put (Moon_second,2); Put ("s)");
         end if;
         If Command = 'Y' then
            declare
               type Simplified_lunar_age is delta 0.5 range 0.0 .. 29.5;
               package Lunar_age_IO is
                 new Text_IO.Fixed_IO (Num => Simplified_lunar_age);
                  Age : Lunar_age := Mean_lunar_age (This_historical_time);
               Simple_Age : Simplified_lunar_age :=
                 Simplified_lunar_age (Float(Fractionnal_day_of(Age)));
               Simple_Residue : Simplified_lunar_age := 29.5 - Simple_Age;
               Spring_residue : Integer := 0;
            begin
               if Age <= To_Spring_Full_Moon
               then Spring_residue :=  Integer (Float'Floor
                    (Float(Fractionnal_day_of(To_Spring_Full_Moon - Age))));
               else Spring_residue := Integer (Float'Floor
                       (Float(29.53 - Fractionnal_day_of
                        (Age - To_Spring_Full_Moon))));
               end if;
               New_Line;
               Put ("Year moon age: ");
               Lunar_age_IO.Put(Item => Simple_Age,
                                Fore => 2,
                                Aft  => 1);
               Put ("; Year moon residue: ");
               Lunar_age_IO.Put(Item => Simple_Residue,
                                Fore => 2,
                                Aft  => 1);
               Put ("; Spring full moon residue: ");
               Put(Spring_residue, 2); Put (".");
               If This_year >= 1 then
                  New_Line;
                  Put ("21 March to Easter, Gregorian Computus: ");
                  Put (Easter_days (This_year,Gregorian),2);
                  Put (", Julian: "); Put (Easter_days (This_year,Julian),2);
                  Put (".");
               end if;
               New_Line;
               Put ("Delay in days of Julian calendar with respect to Gregorian :");
               Put (Julian_to_Gregorian_Delay(This_year),3);
            end;
         end if;

      exception
         when Constraint_Error =>
            Put (" Out of bounds");
         when Data_Error =>
            Put (" Invalid data");
         when Scaliger.Time_Error =>
            Put (" Invalid date");
         when Help_request      => Put (Help_text);
         when Licence_request   => Put (Licence_text);
         when others            => Put (" Unknown error");
      end;
      New_Line;

   end loop;

end Milesian_converter;
