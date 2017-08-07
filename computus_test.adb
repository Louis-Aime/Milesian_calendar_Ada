-- Comparison of Easter date computations methods.
with Julian_calendar; use Julian_calendar;
with Computus_meeus; use Computus_meeus;
with Text_IO; use Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure computus_test is
   Calendar_char : Character := ' ';
   Level, D1, D2 : Natural := 0;
begin
   Put ("Computus test. Enter G or J then final year of test: "); New_Line;
   Get (Calendar_char); Get (Level);
   New_Line; Put("Calendar: "); Put (Calendar_char);
   Put (", final year: "); Put (Level, 7);
   case Calendar_char is
      when 'G' =>
         For Year in 0 .. Level loop
            D1 := Butcher (Year); D2 := Easter_days (Year, Gregorian);
            if D1 /= D2 then
               New_Line; Put ("Year: ");
               Put ("Butcher: "); Put (D1,2);
               Put ("Milesian: "); Put (D2,2);
            end if;
         end loop;
      when 'J' =>
          For Year in 1 .. Level loop
            D1 := Delambre (Year); D2 := Easter_days (Year, Julian);
            if D1 /= D2 then
               New_Line; Put ("Year: ");
               Put ("Delambre: "); Put (D1,2);
               Put ("Milesian: "); Put (D2,2);
            end if;
         end loop;
      when others => Put (" Invalid calendar !");
   end case;
   Put (" .. End comparison.");
end computus_test;
