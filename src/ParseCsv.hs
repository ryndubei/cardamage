module ParseCsv (getPartCosts, getMultipliers) where

import Data.Map.Strict (Map)
import qualified Data.Map.Strict as M
import qualified Data.ByteString.Lazy as B
import qualified Data.Vector as V
import Data.Csv
import Paths_cardamage

type PartCosts = Map String Int 

type DamageMultipliers = Map String Double

getPartCosts :: IO PartCosts
getPartCosts = do
  csvData <- B.readFile =<< getDataFileName "partcost.csv"
  case decode NoHeader csvData of
    Left err -> fail err
    Right v -> pure (M.fromList . V.toList $ v)

getMultipliers :: IO DamageMultipliers
getMultipliers = do
  csvData <- B.readFile =<< getDataFileName "damage-multipliers.csv"
  case decode NoHeader csvData of
    Left err -> fail err
    Right v -> pure (M.fromList . V.toList $ v)