{ pkgs, ... }: with pkgs;[
    go
    gopls
    delve
    go-outline
    gopkgs
    gocode-gomod
    godef

    # Tools tambahan yang berguna
    gotools
    govulncheck
    golangci-lint

    # Build tools
    gnumake
    cmake
]
