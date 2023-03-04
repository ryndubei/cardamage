{-# LANGUAGE DeriveGeneric #-}
module AnalyseDamage.ApiResponse (ApiOutput, displayApiOutput) where

import GHC.Generics (Generic)
import Data.Aeson ( ToJSON (toEncoding), genericToEncoding, defaultOptions, FromJSON )

data ApiOutput = ApiOutput
  { job_id :: String
  , draw_result :: Bool
  , output :: Output
  } deriving (Generic, Show)

data Output = Output 
  { elements :: [Element]

-- Commented out because draw_result is False and so these fields don't exist:
--, output_url :: String
--, url_expiry :: String

  } deriving (Generic, Show)

data Element = Element
  { bbox :: [Int]
  , damage_category :: String
  , damage_color :: [Int]
  , damage_id :: String
  , damage_location :: String
  , score :: String
  } deriving (Generic, Show)

instance ToJSON ApiOutput where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON ApiOutput

instance ToJSON Element where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON Element

instance ToJSON Output where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON Output

-- | List of tuples containing names of car parts and their damage types.
displayApiOutput :: ApiOutput -> [(String, String)]
displayApiOutput apiOutput = 
  let
    outputElements = elements . output $ apiOutput
   in [ (damage_category e, damage_category e) | e <- outputElements ]