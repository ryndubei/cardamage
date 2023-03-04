module Main (main) where

import CommandLine
import AnalyseDamage

main :: IO ()
main = do
  parts <- analyseImages =<< getImages
  mapM_ putStrLn parts
