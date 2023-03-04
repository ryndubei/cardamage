module Main (main) where

import Options.Applicative
import qualified Data.ByteString as B
import AnalyseDamage
import Paths_cardamage

main :: IO ()
main = do
  apiKey <- B.readFile =<< getDataFileName ".secrets/API_KEY.secret"
  parts <- analyseImages apiKey =<< getImages
  mapM_ putStrLn parts

data Parameters = Parameters { images :: [FilePath] }

parameters :: Parser Parameters
parameters = Parameters
      <$> some (argument str 
                  ( metavar "IMAGES..." 
                 <> help "Images to analyse"
                  )
               ) 

getImages :: IO [Image]
getImages = execParser opts >>= \params -> mapM B.readFile (images params)
  where
    opts = info (parameters <**> helper)
      ( fullDesc
     <> progDesc "Return a list of broken car parts from a list of images"
     <> header "haskell-cardamage")
