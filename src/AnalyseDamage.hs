{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module AnalyseDamage where

import Data.ByteString (ByteString)
import Network.HTTP.Simple (Request, parseRequest, Header, setRequestHeaders, setRequestBodyJSON, setRequestSecure, httpBS)
import Data.Maybe (fromJust)
import Data.Text (Text)
import Data.Aeson (ToJSON (toEncoding), genericToEncoding, defaultOptions)
import GHC.Generics (Generic)
import Data.ByteString.Base64 (encodeBase64)
import Network.HTTP.Client.Conduit (responseBody)

type Image = ByteString
type ApiKey = ByteString

-- | Given a list of images, output a list of damaged car parts according
-- to the image classification model.
analyseImages :: ApiKey -> [Image] -> IO [String]
analyseImages apiKey imgs = do
  rawOutputs <- mapM (runModel apiKey) imgs
  pure (map show rawOutputs)

runModel :: ApiKey -> Image -> IO ByteString
runModel apiKey image = do
  response <- httpBS (apiRequest apiKey image)
  pure (responseBody response)

-- | Given an Image and the api key, construct an HTTP request to server
-- hosting the AI model.
apiRequest :: ApiKey -> Image -> Request
apiRequest apiKey image = 
  setRequestSecure True 
  . setRequestBodyJSON body 
  . setRequestHeaders headers 
  $ baseRequest
  where
    baseRequest = fromJust $ parseRequest "POST https://vehicle-damage-assessment.p.rapidapi.com/run"
    headers = 
      [ ("content-type", "application/json")
      , ("X-RapidAPI-Key", apiKey)
      , ("X-RapidAPI-Host", "vehicle-damage-assessment.p.rapidapi.com")] :: [Header]
    body = ApiPayload 
      { draw_result = False 
      , remove_background = False 
      , image = encodeBase64 image 
      }

testImage :: Image
testImage = ""

data ApiPayload = ApiPayload 
  { draw_result :: Bool
  , remove_background :: Bool
  , image :: Text -- Base64-encoded
  } deriving (Generic, Show)

instance ToJSON ApiPayload where
  toEncoding = genericToEncoding defaultOptions

-- | Output for specifically
data ApiOutput = ApiOutput
  { bbox :: [Int]
  , damage_category :: String
  , damage_color :: [Int]
  , damage_id :: String
  , damage_location :: String
  , score :: String
  }