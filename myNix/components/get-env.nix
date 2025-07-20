nameEnv: default:
let
  valueEnv = builtins.getEnv nameEnv;
  value = if valueEnv == "" then default else valueEnv;
in
value
