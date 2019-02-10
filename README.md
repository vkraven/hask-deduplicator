# hask-deduplicator
Attempt to create a parallel duplicate identifier in Haskell.

No longer runs out of memory!

## Usage
### Build
`stack ghc -- -rtsopts -O2 -threaded leven.hs`

### Execute
`./leven +RTS -N`
