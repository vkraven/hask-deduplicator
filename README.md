# hask-deduplicator
My attempt to create a parallel duplicate identifier in Haskell.
This project was inspired by a need to speed up the detection of duplicate contact information in a database, where users were intentionally evading the duplicate rules in a major CRM.

No it longer runs out of memory!

## Usage
### Build
Exposing the Haskell RTS to the command line
`stack ghc -- -rtsopts -O2 -threaded leven.hs`

### Execute with RTS args
`./leven +RTS -N`

### Build with multithreading on default
`stack ghc -- --with-rtsopts="-N" -O2 -threaded leven.hs`

### Execute
`./leven`
