# Milesian_calendar_Ada
Packages in Ada defining the Milesian calendar, conversion from/to Julian day, from/to julian-gregorian, 
and giving the phase of the mean moon.
# Main programs
## milesian_converter
A line-mode program. Give a date in Julian, Gregorian or Milesian calendar, or give the Julian day,
obtain the same date in all other calendar, and the Moon phase.
Get also the key figure of a year, including the date of Easter.
## computus_test
Test the difference between Butcher's and Delambre's method,
and the "Milesian" method.
# Packages
## Computus_meeus
Compute the date of Easter following Delambre's and Butcher's methods.
For comparison with the method defined in Julian_calendar.
## Scaliger
Define the Julian day, as defined by Scaliger, and give thr framework of calendars
## Scaliger-Ada_conversion
Convert to/from Julian day and Ada time.
## Cycle_computations
Define the integer division with remainder, and the integer division with "ceiling"
These routines facilitate calendar computations
## milesian_environment
Instantiations of IO packages.
## Milesian_calendar
Definition of the Milesian calendar, with respect to Julian day.
## Julian_calendar
Julian and gregorian calendars with respect to Julian Day,
plus the computation of the date of Easter, with a simplified (but exact) method.
## Lunar_phase_computations
Compute lunar age, lunar residue, and shift between solar and lunar time.


