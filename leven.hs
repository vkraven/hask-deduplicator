
module Main where

import qualified Data.Text as T
import Data.Text.Metrics
import Data.Ratio
import Control.Parallel.Strategies

wrds :: IO String
wrds = readFile "/usr/share/dict/cracklib-small" 

twrds :: IO [T.Text]
twrds = T.words <$> fmap T.pack wrds

first :: (a, b, c) -> a
first (a, _, _) = a

second :: (a, b, c) -> b
second (_, b, _) = b

third :: (a, b, c) -> c
third (_, _, c) = c

pairme :: [T.Text] -> [(T.Text, T.Text)]
pairme x = [(x1, x2) | x1 <- x, x2 <- x, x1 /= x2]

similarityCalc :: (T.Text, T.Text) -> (String, String, Ratio Int)
similarityCalc (x, y) = (T.unpack x, T.unpack y, levenshteinNorm x y)


main :: IO ()
main = do
        allWords <- twrds
        let y = pairme allWords
            z = map similarityCalc y `using` (parListChunk 1000) rdeepseq
         in putStrLn $ show (filter (\x -> third x > 0.85) z)
                {- putStrLn $ show (filter (\x -> (first x /= second x) && (third x > 0.85)) $ similarityCalc allWords)-}
