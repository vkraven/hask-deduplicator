
module Main where

import qualified Data.Text as T
import Data.Text.Metrics
import Data.Ratio
import Control.Parallel.Strategies
import System.CPU (logicalCores, getCPUs)

wrds :: IO [String]
wrds = readFile "cracklib-smaller" >>= return . words 
        {-
twrds :: IO [T.Text]
twrds = T.words <$> fmap T.pack wrds 
-}
first :: (a, b, c) -> a
first (a, _, _) = a

second :: (a, b, c) -> b
second (_, b, _) = b

third :: (a, b, c) -> c
third (_, _, c) = c

pairme :: [String] -> [(String, String)]
pairme x = [(x1, x2) | x1 <- x, x2 <- x, x1 /= x2]

similarityCalc :: (String, String) -> (String, String, Ratio Int)
similarityCalc (x, y) = (x, y, levenshteinNorm (T.pack x) (T.pack y))



calcLev :: [String] -> String -> [(String, String)]
calcLev base word = go base [] where
                       go (x:xs) res
                         | xs == [] = if (x /= word) && (levenshteinNorm (T.pack x) (T.pack word) > 0.85) then [(word, x)] <> res else res
                         | otherwise = go xs (if (x /= word) && (levenshteinNorm (T.pack x) (T.pack word) > 0.85) then [(word, x)] <> res else res)


main :: IO ()
main = do
        allWords <- wrds
        cpu <- getCPUs
        let z = map (calcLev allWords) allWords `using` (parListChunk (length allWords `div` logicalCores cpu)) rdeepseq
         in putStrLn $ show (concat z)
                {- putStrLn $ show (filter (\x -> (first x /= second x) && (third x > 0.85)) $ similarityCalc allWords)-}
