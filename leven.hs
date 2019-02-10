module Main where

import qualified Data.Text as T
import Data.Text.Metrics
import Control.Parallel.Strategies
import System.CPU (logicalCores, getCPUs)
import System.Info (os)

wrds :: IO [String]
wrds = readFile "smallwords" >>= return . words 

cores :: IO Int
cores = case os of
          "darwin" -> return 4
          otherwise -> do
                        cpu <- getCPUs
                        return $ logicalCores cpu

calcLev :: [String] -> String -> [(String, String)]
calcLev base word = go base [] where
                       go (x:xs) res
                         | xs == [] = if (x /= word) && (levenshteinNorm (T.pack x) (T.pack word) > 0.85) then [(word, x)] <> res else res
                         | otherwise = go xs (if (x /= word) && (levenshteinNorm (T.pack x) (T.pack word) > 0.85) then [(word, x)] <> res else res)


main :: IO ()
main = do
        allWords <- wrds
        coreNum <- cores
        let z = map (calcLev allWords) allWords `using` (parListChunk (length allWords `div` coreNum)) rdeepseq
         in putStrLn $ show (concat z)
