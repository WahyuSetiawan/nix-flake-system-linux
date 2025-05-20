{ lib, self, ... }:
{
  options.home.user-info = (self.commonModules.system-user { inherit lib; }).options.users.primaryUsers;
}
