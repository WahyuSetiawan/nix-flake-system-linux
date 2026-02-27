{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.darwinModules.sops
    ./browser.nix
    ./homebrew.nix
    # ./mouseless.nix
    ./packages.nix
    ./shells.nix
    ./system.nix
    ./tui.nix
    ./virtualize.nix
  ];
}




#   UW PICO 5.09                                                                                                                                          File: /private/tmp/nix-shell-50814-3493666111/3490963524/secrets.yaml

# ssh_vps_spada: |
#     -----BEGIN OPENSSH PRIVATE KEY-----
#     b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAArAAAABNlY2RzYS
#     1zaGEyLW5pc3RwNTIxAAAACG5pc3RwNTIxAAAAhQQAxGyFiWcAntC+eG7SokEMtViQ8hNZ
#     Ycc4GsqoGeX/O8y/mlxZTIgarrkvwbPnlbo10+hkbrTnYWjh2+IMBMlZ3qMB5JGMsr82Fc
#     amLKy8G/bvfnH+ZRC8sQBGw+6NVJz5Z8I1y1CvdSSZPYOZxZo4926zBDw+7m5Zk62HHuwm
#     js7iXC4AAAEIidWEnYnVhJ0AAAATZWNkc2Etc2hhMi1uaXN0cDUyMQAAAAhuaXN0cDUyMQ
#     AAAIUEAMRshYlnAJ7Qvnhu0qJBDLVYkPITWWHHOBrKqBnl/zvMv5pcWUyIGq65L8Gz55W6
#     NdPoZG6052Fo4dviDATJWd6jAeSRjLK/NhXGpiysvBv2735x/mUQvLEARsPujVSc+WfCNc
#     tQr3UkmT2DmcWaOPduswQ8Pu5uWZOthx7sJo7O4lwuAAAAQXOahmunS2wH40+t9d6MusHf
#     yNsyxdM5RSPBJaNIRU0XqlosbSE3merMIA1wJWzl966tgqnzvDmaNzSmG4bfz3hgAAAAC3
#     dhaHl1QHdhaHl1
#     -----END OPENSSH PRIVATE KEY-----
# ssh_gitlab: |
# -----BEGIN OPENSSH PRIVATE KEY-----
# b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
# QyNTUxOQAAACDFILvYGwrl052MglBOqbX1e/mxNCmGnHY4J/EAoiLBJAAAAJCIUKNkiFCj
# ZAAAAAtzc2gtZWQyNTUxOQAAACDFILvYGwrl052MglBOqbX1e/mxNCmGnHY4J/EAoiLBJA
# AAAEB6/LMu0hiUBzcIc9IeiBAH0SkeiSSq0ALxRo5c+e0DGMUgu9gbCuXTnYyCUE6ptfV7
# +bE0KYacdjgn8QCiIsEkAAAACTxjb21tZW50PgECAwQ=
# -----END OPENSSH PRIVATE KEY-----
# ssh_gitlab_siber: |
#     -----BEGIN OPENSSH PRIVATE KEY-----
#     b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
#     QyNTUxOQAAACCtUW7aiX6quPu5rw2wrwWILI8fkl9bDoMogKSoSlDv1wAAAKC66PEAuujx
#     AAAAAAtzc2gtZWQyNTUxOQAAACCtUW7aiX6quPu5rw2wrwWILI8fkl9bDoMogKSoSlDv1w
#     AAAEBm6BHouhh/vtTtn89wADk4vlBwDJc/dhYokeQ625d1Gq1RbtqJfqq4+7mvDbCvBYgs
#     jx+SX1sOgyiApKhKUO/XAAAAHGRldi53YWh5dS5zZXRpYXdhbkBnbWFpbC5jb20B
#     -----END OPENSSH PRIVATE KEY-----
# ssh_github: |
# -----BEGIN OPENSSH PRIVATE KEY-----
# b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
# QyNTUxOQAAACB8pKWdB7JnqLqfg/TzzAuvTFji2bEr4aJKIwKAyq4iaAAAAKBLJ+xmSyfs
# ZgAAAAtzc2gtZWQyNTUxOQAAACB8pKWdB7JnqLqfg/TzzAuvTFji2bEr4aJKIwKAyq4iaA
# AAAEBPMSH7egNsGUgF/fRqkYkI/f+IvuqcOM2S82ji0m+KT3ykpZ0Hsmeoup+D9PPMC69M
# WOLZsSvhokojAoDKriJoAAAAHGRldi53YWh5dS5zZXRpYXdhbkBnbWFpbC5jb20B
# -----END OPENSSH PRIVATE KEY-----
# ssh_github_sentra: |
# -----BEGIN OPENSSH PRIVATE KEY-----
# b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAArAAAABNlY2RzYS
# 1zaGEyLW5pc3RwNTIxAAAACG5pc3RwNTIxAAAAhQQAcBwSlsydhDpHa8+xNHRiywMWfvdG
# omB4iRtqE4gVrzbzk9yIlxO/0uHCLxGH9Lrz1W6RFYjI0oHBQq2Jdz5JBdYA8KeO3QCihb
# cztKHFOjqZwuSLamdOpBjURQGk7ua92HiLvxpDBNZ8+fxU2TQ5rr6nRK0j0sDcO6Hs7kFh
# MRWDxpAAAAEIGQcx6BkHMegAAAATZWNkc2Etc2hhMi1uaXN0cDUyMQAAAAhuaXN0cDUyMQ
# AAAIUEAHAcEpbMnYQ6R2vPsTR0YssDFn73RqJgeIkbahOIFa8285PciJcTv9Lhwi8Rh/S6
# 89VukRWIyNKBwUKtiXc+SQXWAPCnjt0AooW3M7ShxTo6mcLki2pnTqQY1EUBpO7mvdh4i7
# 8aQwTWfPn8VNk0Oa6+p0StI9LA3Duh7O5BYTEVg8aQAAAAQRLRG7/WKpm450x6tkslWYW4
# oh9QaNVbgjhUohHVOweGdpbmHyefxfaq1ZJS4VDAdWIZAXhe0ew+9sGvjWnHNpMCAAAAC3
# dhaHl1QHdhaHl1
# -----END OPENSSH PRIVATE KEY-----
# ssh_vps_akademik_user: |
#     -----BEGIN OPENSSH PRIVATE KEY-----
#     b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAArAAAABNlY2RzYS
#     1zaGEyLW5pc3RwNTIxAAAACG5pc3RwNTIxAAAAhQQB4I52aeax+Qr7LdI/FLjRP0oLMN1v
#     J+/2rOqsZZNM0yextBKMxNB8nJmWrg7F7JzNq3A07QgmnHsHaOrB88kp3sAAcHmGssoj4s
#     G8RM197GQz4RBfL7ISUIzX99i5kBs2lLn84fIe5KuMjBcNHumPLsF6ZRaTTj44a6dhfETk
#     efUAsBYAAAEQvrrx1L668dQAAAATZWNkc2Etc2hhMi1uaXN0cDUyMQAAAAhuaXN0cDUyMQ
#     AAAIUEAeCOdmnmsfkK+y3SPxS40T9KCzDdbyfv9qzqrGWTTNMnsbQSjMTQfJyZlq4Oxeyc
#     zatwNO0IJpx7B2jqwfPJKd7AAHB5hrLKI+LBvETNfexkM+EQXy+yElCM1/fYuZAbNpS5/O
#     HyHuSrjIwXDR7pjy7BemUWk04+OGunYXxE5Hn1ALAWAAAAQgDD/iMb94iKjBanGbgrN5Ue
#     ub0qLc/gU0X961iUGGY9X4uJLJQM+ADOese2rdettxhQWZJVfs7AZhNo10Va+UrUuAAAAA
#     t3YWh5dUB3YWh5dQECAwQFBgc=
#     -----END OPENSSH PRIVATE KEY-----
# ssh_vps_prod: |
#     -----BEGIN OPENSSH PRIVATE KEY----
#     b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAArAAAABNlY2RzYS
#     1zaGEyLW5pc3RwNTIxAAAACG5pc3RwNTIxAAAAhQQAxGyFiWcAntC+eG7SokEMtViQ8hNZ
#     Ycc4GsqoGeX/O8y/mlxZTIgarrkvwbPnlbo10+hkbrTnYWjh2+IMBMlZ3qMB5JGMsr82Fc
#     amLKy8G/bvfnH+ZRC8sQBGw+6NVJz5Z8I1y1CvdSSZPYOZxZo4926zBDw+7m5Zk62HHuwm
#     js7iXC4AAAEIidWEnYnVhJ0AAAATZWNkc2Etc2hhMi1uaXN0cDUyMQAAAAhuaXN0cDUyMQ
#     AAAIUEAMRshYlnAJ7Qvnhu0qJBDLVYkPITWWHHOBrKqBnl/zvMv5pcWUyIGq65L8Gz55W6
#     NdPoZG6052Fo4dviDATJWd6jAeSRjLK/NhXGpiysvBv2735x/mUQvLEARsPujVSc+WfCNc
#     tQr3UkmT2DmcWaOPduswQ8Pu5uWZOthx7sJo7O4lwuAAAAQXOahmunS2wH40+t9d6MusHf
#     yNsyxdM5RSPBJaNIRU0XqlosbSE3merMIA1wJWzl966tgqnzvDmaNzSmG4bfz3hgAAAAC
#     dhaHl1QHdhaHl1
#     -----END OPENSSH PRIVATE KEY-----



