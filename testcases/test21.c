/* weirdnesses that are OK for syntax analysis but won't be once we
   have type information. */
  a["foo"] = "bar";
  foo['\n'] = bar[foo["foo"]];
  foo = "bar" + 1;

