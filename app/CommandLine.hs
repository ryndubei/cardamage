module CommandLine (getImages) where

import Options.Applicative
import qualified Data.ByteString.Lazy as B
import AnalyseDamage

data Parameters = Parameters
  { images :: [FilePath]
  }

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

