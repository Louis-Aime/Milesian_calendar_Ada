-- Package body Computus_meeus
--
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
package body Computus_meeus is

   function Butcher (Year : Natural) return Natural is
      -- Compute days to Easter following Buther's method
      -- works only for the Gregorian calendar (no check whether Year < 1583).
      -- Rank of century
      S : Natural := Year / 100;
      -- Rank of quadrisaeculum
      Q : Natural := Year / 400;
      -- Rank of century in quadrisaeculum
      C : Natural range 0..3 := (Year - Q*400) / 100;
      -- Rank of quadriannum in current century
      B : Natural range 0..24 := (Year - S*100) / 4;
      -- Rank of year in current quadriannuem
      N : Natural range 0..3 := (Year - S*100 - B*4);
      -- Gold number minus one in Meton's cycle
      G : Natural range 0..18 := Year mod 19;
      -- Rank of proemptose cycle. Cycle 0 in 1583, 1 from 1800
      PC : Natural := (S + 8) / 25;
      -- Proemptose
      P: Natural := (S - PC + 1) / 3;
      -- Easter residue, number of days from 21 March until Easter full moon
      R : Natural range 0..29 := (15 + 19*G + S - Q - P) mod 30;
      -- Number of days until Easter eve
      L : Natural range 0..6 := (32 + 2*C + 2*B - N - R) mod 7 ;
   begin
      return 1 + R + L - 7*((G + 11*R + 22*L)/451);
   end Butcher;

   function Delambre (Year : Natural) return Natural is
      -- Compute days to Easter following Buther's method
      -- works only for the Julian calendar.
      -- Number of quadriannum
      B : Natural := Year / 4;
      -- Rank of year in current quadriannum
      N : Natural range 0..3 := Year mod 4;
      -- Gold number minus one in Meton's cycle
      G : Natural range 0..18 := Year mod 19;
      -- Easter residue, number of days from 21 March until Easter full moon
      R : Natural range 0..29 :=
        (15 + 19*G) mod 30;
   begin
      return 1 + R + (6 + 2*B - N - R) mod 7;
   end Delambre;

end Computus_meeus;
