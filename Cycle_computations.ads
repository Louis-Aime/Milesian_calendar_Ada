-- Cycle computations
-- A variant to the integer division, where the number of cycles and the phase
-- within the cycle are computed and returned by single function.
-- In these functions, the remainder (the phase) is always non-negative.
-- Decompose_cycle is the standard operation;
-- Decompose_cycle_ceiled is appropriate when the phase is authorised to be
-- equal to the divisor.
-- First variant for integer types,
-- second variant for fixed types.
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

package Cycle_computations is

   Generic type Num is range <>;
   package Integer_cycle_computations is
      subtype Positive_num is Num range 1..Num'Last;
      type Cycle_coordinates is record
         Cycle : Integer;
         Phase : Num;
      end record;

      function Decompose_cycle
        (Dividend : Num;
         Divisor  : Positive_num)
         return  Cycle_coordinates;
      -- Dividend = Cycle * Divisor + Phase, 0 <= Phase < Divisor

      function Decompose_cycle_ceiled
        (Dividend : Num;
         Divisor  : Positive_num;
         Ceiling  : Positive)
         return  Cycle_coordinates;
      -- 0 <= Dividend <= Ceiling * Divisor
      -- Dividend = Cycle * Divisor + Phase, 0 <= Phase <= Divisor,
      -- Phase = Divisor only for last value of Dividend, Cycle < Ceiling.

   end Integer_cycle_computations;

   Generic type Fixed_num is delta <>;
   package Fixed_Cycle_Computations is
      subtype Positive_num is Fixed_num range Fixed_num'Delta..Fixed_num'Last;
      type Cycle_coordinates is record
         Cycle    : Integer;
         Phase    : Fixed_num;
      end record;

      function Decompose_cycle
        (Dividend : Fixed_num;
         Divisor  : Positive_num)
         return  Cycle_coordinates;
      -- Dividend = Cycle * Divisor + Phase, 0 <= Phase < Divisor

      function Decompose_cycle_ceiled
        (Dividend : Fixed_num;
         Divisor  : Positive_num;
         Ceiling  : Positive)
         return  Cycle_coordinates;
      -- 0 <= Dividend <= Ceiling * Divisor
      -- Dividend = Cycle * Divisor + Phase, 0 <= Phase <= Divisor,
      -- Phase = Divisor only for last value of Dividend, Cycle < Ceiling.

   end Fixed_cycle_computations;

end Cycle_computations;
