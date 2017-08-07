-- Package body Cycle_computations
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
Package body Cycle_computations is

Package body Integer_cycle_computations is

   function Decompose_cycle
     (Dividend : Num; Divisor: Positive_num)
      return  Cycle_coordinates is
      Cycle : Integer := 0; Phase : Num := Dividend;
   begin
      while phase < 0 loop
         phase := phase + divisor;
         cycle := cycle - 1;
      end loop;
      while phase >= divisor loop
        phase := phase - divisor;
        cycle := cycle + 1;
      end loop;
      return (cycle, phase);
   end Decompose_cycle;

   function Decompose_cycle_ceiled
     (Dividend : Num; Divisor: Positive_num;
      Ceiling : Positive)
   return  Cycle_coordinates is
      Cycle : Integer := 0; Phase : Num := Dividend;
      Ceiling_minus_one : Natural := Ceiling - 1;
   begin
      if Phase > Num(ceiling) * divisor then raise constraint_error; end if;
      while phase >= divisor and then cycle < Ceiling_minus_one loop
        phase := phase - divisor;
        cycle := cycle + 1;
      end loop;
      return (cycle, phase);
   end Decompose_cycle_ceiled;

end Integer_cycle_computations;

Package body Fixed_cycle_computations is

   function Decompose_cycle
     (Dividend : Fixed_num; Divisor: Positive_num)
      return  Cycle_coordinates is
      Cycle : Integer := 0; Phase : Fixed_num := Dividend;
   begin
      while phase < 0.0 loop
         phase := phase + divisor;
         cycle := cycle - 1;
      end loop;
      while phase >= divisor loop
        phase := phase - divisor;
        cycle := cycle + 1;
      end loop;
      return (cycle, phase);
   end Decompose_cycle;

   function Decompose_cycle_ceiled
     (Dividend : Fixed_num; Divisor: Positive_num;
      Ceiling : Positive)
   return  Cycle_coordinates is
      Cycle : Integer := 0; Phase : Fixed_num := Dividend;
      Ceiling_minus_one : Natural := Ceiling - 1;
   begin
      if Phase > Ceiling * Divisor then raise constraint_error; end if;
      while phase >= divisor and then cycle < Ceiling_minus_one loop
        phase := phase - divisor;
        cycle := cycle + 1;
      end loop;
      return (cycle, phase);
   end Decompose_cycle_ceiled;

end Fixed_cycle_computations;

end Cycle_computations;
