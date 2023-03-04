{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module AnalyseDamage.ApiResponse (ApiOutput, displayApiOutput) where

import GHC.Generics (Generic)
import Data.Aeson ( FromJSON, withObject, (.:) )
import Data.Aeson.Types (parseJSON)

data ApiOutput = ApiOutput
  { job_id :: String
  , draw_result :: Bool
  , output :: Output
  } deriving (Generic, Show)

instance FromJSON ApiOutput

data Output = Output
  { elements :: [Element]

-- Commented out because draw_result is False so these fields don't exist:
--, output_url :: String
--, url_expiry :: String

  } deriving (Generic, Show)

instance FromJSON Output

data Element = Element
  { bbox :: [Int]
  , damage_category :: String
  , damage_color :: [Int]
  , damage_id :: String
  , damage_location :: String
  , score :: Double
  } deriving (Generic, Show)

instance FromJSON Element where
  parseJSON = withObject "elements" $ \v -> Element
    <$> (v .: "bbox")
    <*> (v .: "damage_category")
    <*> (v .: "damage_color")
    <*> (v .: "damage_id")
    <*> (v .: "damage_location")
    <*> (v .: "score") 

-- | List of tuples containing names of car parts and their damage types.
displayApiOutput :: ApiOutput -> [(String, String)]
displayApiOutput apiOutput =
  let
    outputElements = elements . output $ apiOutput
   in [ (damage_location e, damage_category e) | e <- outputElements ]