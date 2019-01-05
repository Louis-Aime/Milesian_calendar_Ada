-- Computus_test : Comparison of Easter date computations methods.
-- copyright Miletus 2015-2017 - no transformation allowed, no commercial use
-- application developed using GPS GPL 2014 of Adacore
-- inquiries: see www.calendriermilesien.org
-- Versions
--   M2017-11-14 : several tests possible within one single session.
--   M2019-01-16 : minor presentation enhancement
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
with Julian_calendar; use Julian_calendar;
with Computus_meeus; use Computus_meeus;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Text_IO; use Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure computus_test is

   NL : constant String := CR & LF ;
   Prompter : constant String := "Type command and figure, or H for Help:";
   Help_text : constant String :=
     "This line mode program challenges the Milesian Easter computation method"
     & NL & "with standard Meeus methods." & NL &
     "Copyright Louis-A. de Fouquieres, Miletus, 2015-2017." & NL &
     "More at www.calendriermilesien.org." & NL &
     "Syntax: <Command> <End year>." & NL &
     "<Command> is one character as described hereunder." & NL &
     "<End year> is an integer, the final year for the test." & NL &
     "Tests begin with year 0 for both Julian and Gregorian algorithms, " & NL &
     "although there is no historical sense" & NL &
     "before around 525 (julian) or 1583 (gregorian)." & NL &
     "Result of Eater computation is Easter day rank, i.e. " & NL &
     "number of days after March 21st when Easter Sunday occurs." & NL &
     "Available commands:"  & NL &
     "S: Silent mode (by default), list discrepancies only." & NL &
     "V: Verbose mode, report year per year results." & NL &
     "J <End year>: test Julian calendar computus from 0 to <End year>." & NL &
     "G <End year: test Gregorian computus from 0 to <End year>." & NL &
     "H: Help, display this text." & NL &
     "X: Exit program.";

   Command : Character := ' ';
   Verbose : Boolean := False;
   Level, D1, D2 : Natural := 0;

   Help_request, Command_error : exception;


begin
   Put ("Copyright Louis-A. de Fouquieres, Miletus, 2015-2019, calendriermilesien.org");
   New_Line;
   loop
      begin -- a block with exception handler
         Put (Prompter); New_Line;
         Get (Command);
         case Command is
            when 'X' => Put ("Bye !");
            when 'H' => Skip_Line; raise Help_request;
            when 'V' => Verbose := True; Put ("Verbose mode on");
            when 'S' => Verbose := False; Put ("Verbose mode off");
            when 'G' | 'J' =>
               Get (Level);
               Put("Calendar: "); Put (Command);
               Put (", final year: "); Put (Level, 7);

               case Command is
               when 'G' =>
                    For Year in 0 .. Level loop
                     D1 := Butcher (Year); D2 := Easter_days (Year, Gregorian);
                     if Verbose or D1 /= D2 then
                        New_Line; Put ("Year: "); Put (Year);
                        Put (", Butcher: "); Put (D1,2);
                        Put (", Milesian: "); Put (D2,2);
                     end if;
                  end loop;
               when 'J' =>
                  For Year in 0 .. Level loop
                     D1 := Delambre (Year); D2 := Easter_days (Year, Julian);
                     if Verbose or D1 /= D2 then
                        New_Line; Put ("Year: "); Put (Year);
                        Put (", Delambre: "); Put (D1,2);
                        Put (", Milesian: "); Put (D2,2);
                     end if;
                  end loop;
                  when others =>  raise Command_error;
               end case;
               New_Line; Put ("== End comparison ==");

            when others => raise Command_error;
         end case;
      exception
         when Help_request => Put (Help_text);
         when Command_error => Put (" Invalid command !"); Skip_Line;
         when others => Put (" Unknown error !"); Skip_Line;
      end;
      exit when Command = 'X';
      New_Line;
   end loop;
end computus_test;
