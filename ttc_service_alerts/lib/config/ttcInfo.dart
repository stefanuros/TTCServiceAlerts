/// This class controls all TTC info that needs to be known

/// This is the list of regular expressions that is used to prevent issues when
/// attempting to isolate the line numbers in the tweet text. 
final List<RegExp> regLis = [
  // This line matches any links
  RegExp(r'(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)'),
  // This line matches any times
  RegExp(r'(\d+ ?[apAP]\.?[mM]|\d\d?:\d\d)'),
  // This line matches any 4 digit years
  RegExp(r'(\d{4})'),
  /// Getting rid of durations (15 minutes, etc)
  RegExp(r'(\d+ minutes)'),
  // These lines matche days and months of the year when the months are written
  // out in words, in any case (lower and upper and any combination of the two)
  RegExp(r'([Jj][Aa][Nn][Uu]?[Aa]?[Rr]?[Yy]? \d\d?)'), // Jan, January
  RegExp(r'([Ff][Ee][Bb][Rr]?[Uu]?[Aa]?[Rr]?[Yy]? \d\d?)'), // Feb, February
  RegExp(r'([Mm][Aa][Rr][Cc]?[Hh]? \d\d?)'), // Mar, March
  RegExp(r'([Aa][Pp][Rr][Ii]?[Ll]? \d\d?)'), // Apr, April
  RegExp(r'([Mm][Aa][Yy] \d\d?)'), // May
  RegExp(r'([Jj][Uu][Nn][Ee]? \d\d?)'), // Jun, June
  RegExp(r'([Jj][Uu][Ll][Yy]? \d\d?)'), // Jul, July
  RegExp(r'([Aa][Uu][Gg][Uu]?[Ss]?[Tt]? \d\d?)'), // Aug, August
  RegExp(r'([sS][eE][pP][tT]?[Ee]?[Mm]?[Bb]?[Ee]?[Rr]? \d\d?)'), // Sep, Sept, September
  RegExp(r'([Oo][Cc][Tt][Oo]?[Bb]?[Ee]?[Rr]? \d\d?)'), // Oct, October
  RegExp(r'([Nn][Oo][Vv][Ee]?[Mm]?[Bb]?[Ee]?[Rr]? \d\d?)'), // Nov, November
  RegExp(r'([Dd][Ee][Cc][Ee]?[Mm]?[Bb]?[Ee]?[Rr]? \d\d?)'), // Dec, December
];
