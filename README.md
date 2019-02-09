# hask-deduplicator
Attempt to create a parallel duplicate identifier in Haskell.

Note that any sizeable file size will still run out of memory.

## Usage
### Build
`stack ghc -- -rtsopts -threaded leven.hs`

### Execute
`./leven +RTS -N`
