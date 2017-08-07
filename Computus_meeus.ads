-- Package Computus_meeus.
-- Compute number of days between 21 March and Easter sunday
-- Uses Meeus (Butcher andd Delambre) methods (function Butcher and Delambre)
-- This functions are developed only for comparison purposes.
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
package Computus_meeus is

   -- Give Easter Sunday as a number of days after 21 March
   -- using Butcher's method
   function Butcher (Year : Natural) return Natural;

   -- Give Easter Sunday as a number of days after 21 March
   -- using Delambre's method

   function Delambre (Year : Natural) return Natural;


end Computus_meeus;
