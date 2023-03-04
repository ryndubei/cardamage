module AnalyseDamage (analyseImages, Image) where

import Data.ByteString.Lazy (ByteString)

type Image = ByteString

-- | Given a list of images, output a list of damaged car parts according
-- to the image classification model.
analyseImages :: [Image] -> IO [String]
analyseImages imgs = mapM runModel imgs >>= \outputs ->
  pure . map fst . filter (\(_,confidence) -> confidence >= 0.6) . concat $ outputs

type Confidence = Double

runModel :: Image -> IO [(String, Confidence)]
runModel img = undefined
